# Get the git version, such that it could be 
# passed during the compilation and later used 
# as an proxy to the code version.
# GIT_VERSION = $(shell git describe --abbrev=6 --dirty --always --tags)

# Main executable name, which will be used both in the 
# makefile as well as in the main function file for generating
# the usage massage.
EXE=run-black-box-learning

# Compiler #
CC 		= g++
# CFLAGS	= -std=c++11 -Wall -DVERSION=\"$(GIT_VERSION)\" 
CFLAGS	= -std=c++11 -Wall 
OPT 	= 
# OPT 	= -O2 -g

# My directories
HEADERS	= include
SRC 	= src
BUILD   = build


all: ${EXE} #${TEST_EXE} 

${EXE}: ${SRC}/*.cpp ${HEADERS}/*.hpp ${BUILD}
	${CC} ${CFLAGS} ${OPT} -o ${BUILD}/${EXE} ${SRC}/*.cpp -I${HEADERS}

${BUILD}:
	mkdir -p ${BUILD}

clean:
	rm ${BUILD}/*