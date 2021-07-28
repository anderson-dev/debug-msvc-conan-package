from conans import ConanFile, MSBuild
import os

def get_version():
    # return os.environ.get('GitVersion_SemVer', None)
    return "0.1.0-version.h.1"

class ConanPackageInfo(ConanFile):
    name = "AddressBook"
    version = get_version()
    license = "MIT"
    settings = "os", "compiler", "build_type", "arch"
    generators = "visual_studio"
    exports_sources = "include/*", "src/*", "make/*", "test/*"
    requires = "boost/1.75.0" # comma-separated list of requirements
    #    default_options = {"boost:shared": True}

    def build(self):
        msbuild = MSBuild(self)
        msbuild.build("make/msvc/AddressBook.sln", upgrade_project=False, use_env=False, verbosity="normal")
        
    def package(self):
        self.copy("*.h", dst="include", src="include")
        self.copy("*.lib", dst="lib", keep_path=False)

    def package_info(self):
        self.cpp_info.libs = ["AddressBook.lib"]