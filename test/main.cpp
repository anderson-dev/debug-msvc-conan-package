// main.cpp : main function - to test contact and addressbook functionality
//

#include <cstdint>
#include <string>
#include <iostream>

#include <boost/uuid/uuid.hpp>
#include <boost/uuid/uuid_generators.hpp>
#include <boost/uuid/uuid_io.hpp>

using namespace std;

int main()
{
    boost::uuids::uuid ret = boost::uuids::random_generator()();
    cout << ret;

    return 1;
}
