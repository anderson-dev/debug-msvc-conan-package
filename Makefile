ifeq ($(OS),Windows_NT)
PWSH := powershell.exe -NoProfile -Command
endif
PROJECT_NAME:=$(shell $(PWSH) '$$(git config --get remote.origin.url).Split("/")[-1].Replace(".git", "")')
# BUILD_IMAGE_VERSION:=$(shell $(PWSH) 'if (-not (Test-Path GitVersion.json)) { gitversion.exe -output file }; $$(Get-Content  GitVersion.json | ConvertFrom-Json).SemVer')
BUILD_IMAGE_VERSION:=0.1.0-version.h.1

WIN_VERSION?=ltsc2019
PUBLISH_SERVER?=mydocker
VSBUILDTOOLS_VERSION?=16
DOCKER_CACHE_ARG?=--no-cache

IMAGE:=$(PROJECT_NAME):$(BUILD_IMAGE_VERSION)
BUILD_VOLUME:=$(PROJECT_NAME)_$(BUILD_IMAGE_VERSION)
BUILD_CACHE_VOLUME:=build-cache_$(PROJECT_NAME)_$(BUILD_IMAGE_VERSION)
ifneq ("$(USERNAME)","ContainerAdministrator")
BUILD_VOLUME:=$(CURDIR)
BUILD_CACHE_VOLUME:=$(USERPROFILE)/.conan
endif

.PHONY: clean verify compile build test package publish finalize
all: clean build publish finalize

clean:
	git clean -xdf

WIN_VERSION_REGKEY:=Registry::HKEY_LOCAL_MACHINE\Software\Microsoft\Windows NT\CurrentVersion
verify:
	$(PWSH) '$$(Get-ItemProperty -Path "$(WIN_VERSION_REGKEY)" ProductName).ProductName'
	$(PWSH) '$$(Get-ItemProperty -Path "$(WIN_VERSION_REGKEY)" ReleaseId).ReleaseId'
	$(PWSH) '$$host.Version'
	make -version
	docker version

compile:
	docker build \
		-f docker/dev/Dockerfile \
		$(DOCKER_CACHE_ARG) \
		--build-arg WIN_VERSION="$(WIN_VERSION)" \
		--build-arg DOCKER_SERVER="$(PUBLISH_SERVER)" \
		--build-arg VSBUILDTOOLS_VERSION="$(VSBUILDTOOLS_VERSION)" \
		-t "$(IMAGE)" \
		.
	docker run --rm -v "$(BUILD_VOLUME):C:/src" -v "$(BUILD_CACHE_VOLUME):C:/Users/containeradministrator/.conan" "$(IMAGE)" \
		powershell conan install -if make/msvc/x64/Release/.conan .;conan build -if make/msvc/x64/Release/.conan .
	
build: verify compile test package

test:
	docker run --rm -v "$(BUILD_VOLUME):C:/src" -v "$(BUILD_CACHE_VOLUME):C:/Users/containeradministrator/.conan" "$(IMAGE)" \
		powershell make/msvc/x64/Release/TestAddressBook.exe
package:
	docker run --rm -v "$(BUILD_VOLUME):C:/src" -v "$(BUILD_CACHE_VOLUME):C:/Users/containeradministrator/.conan" "$(IMAGE)" \
		powershell conan package -if make/msvc/x64/Release/.conan .
publish:

finalize:
	docker rmi "$(IMAGE)"
	ifneq ("$(USERNAME)","ContainerAdministrator")
	docker volume rm $(BUILD_VOLUME) $(BUILD_CACHE_VOLUME)
	endif