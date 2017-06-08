#ifndef READCMD_H
#define READCMD_H

#include <stdlib.h>
#include <algorithm>
#include <fstream>


/* Using the code snippet taken here: https://stackoverflow.com/a/868894
 * 
 * All auhtorship for these functions goes to the above mentioned link.
 *
 */

// Tools for reading commandline option
bool cmdOptionExists(char** begin, char** end, const std::string& option)
{
	return std::find(begin, end, option) != end;
}

char* getCmdOption(char ** begin, char ** end, const std::string & option)
{
	char ** itr = std::find(begin, end, option);
	if (itr != end && ++itr != end)
	{
	    return *itr;
	}
	return 0;
}


#endif
