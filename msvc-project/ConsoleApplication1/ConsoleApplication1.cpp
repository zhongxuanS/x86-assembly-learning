// ConsoleApplication1.cpp : This file contains the 'main' function. Program execution begins and ends there.
//

#include <stdio.h>
#include <iostream>

#include <memory>

extern "C" int bar(int); // written in assembly!

typedef int* CURL;

void test(CURL* ptrCurl)
{

}

int main(int argc, char** argv)
{
	int ii = 123;
	CURL i = &ii;
	std::shared_ptr<CURL> shptr(&i, test);
    return 0;
}