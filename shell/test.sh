#!/bin/bash - 
#===============================================================================
#
#          FILE: test.sh
# 
#         USAGE: ./test.sh 
# 
#   DESCRIPTION: 
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: YOUR NAME (), 
#  ORGANIZATION: 
#       CREATED: 2018年08月23日 15时32分39秒
#      REVISION:  ---
#===============================================================================

set -o nounset                              # Treat unset variables as an error

config_file="config.json"

function check_md5() {
    if [ -f $config_file ]; then
        md5sum $config_file|awk '{print $1}'
    fi

    echo "0"
}

md5="$(check_md5)"
echo $md5

opt="1100"

opt=$[2**5]

case $opt in
    1)
        echo "0000"
        ;;
    2)
        echo "0010"
        ;;
    4)
        echo "0100"
        ;;

    8)
        echo "1000"
        ;;
    16)
        echo "10000"
        ;;
    32)
        echo "100000"
        ;;
    64)
        echo "100000"
        ;;
    *)
        echo "unknow device option."
        ;;
esac

state=""

list="11001100 alabama hunan hahah"

for state in $list
do
    echo $state
done

value=""

for (( i = 1; i<=8; i++ ))
do
    value="$(echo "10010000"|cut -c $i)"
    echo $value
done

for j in {9..2};
do
    echo $j
done



