// main.cpp : main function - to test contact and addressbook functionality
//

#include "AddressBook.h"

#include <cstdint>
#include <string>
#include <iostream>

#include <boost/uuid/uuid.hpp>
#include <boost/uuid/uuid_generators.hpp>
#include <boost/uuid/uuid_io.hpp>
#include <boost/lexical_cast.hpp>

using namespace std;

namespace EDOT
{
	AddressBook::AddressBook()
	{
	}

	AddressBook::~AddressBook()
	{
	}

	string AddressBook::GetAddressBookId()
	{
		boost::uuids::uuid ret = boost::uuids::random_generator()();
		const std::string tmp = boost::lexical_cast<std::string>(ret);
		return tmp;
	}
}
