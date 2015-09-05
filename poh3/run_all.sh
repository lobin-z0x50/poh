#!/bin/bash

if [ "$1" = "" ]; then
	echo " Usage: $0 <datafile>"
	echo ""
	exit 1
fi

#echo == 1 ==
#time ruby paiza1.rb < $1 2> /dev/null 

#echo == 2 ==
#time ruby paiza2.rb < $1 2> /dev/null 

echo == 3 ==
time ruby paiza3.rb < $1 2> /dev/null 

echo == nishi4 ==
time ruby nishi4.rb < $1 2> /dev/null 
