#!/bin/sh
#===============================================================================
#
#          FILE: test1.sh
#
#         USAGE: ./test1.sh
#
#   DESCRIPTION:
#
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: YOUR NAME (),
#  ORGANIZATION:
#       CREATED: 2018年08月28日 16时56分05秒
#      REVISION:  ---
#===============================================================================

set -o nounset                              # Treat unset variables as an error

for i in 8 7 6 5 4 3 2 1
do
    echo $i
done

while 1:
do
    echo "hello"
    sleep 10
done



