#!/bin/bash -
#===============================================================================
#
#          FILE: hello.sh
#
#         USAGE: ./hello.sh
#
#   DESCRIPTION:
#
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: YOUR NAME (),
#  ORGANIZATION:
#       CREATED: 2018年08月23日 14时18分33秒
#      REVISION:  ---
#===============================================================================

set -o nounset                              # Treat unset variables as an error

SERVER=""
PORT=""
INTERVAL=""

function get_ip_addr() {
    ifconfig ens33 | grep -w "inet" | awk '{print $6}'
}


function hello(){
    local ip_addr=""
    local interface=""

    ip_addr="$(get_ip_addr)"



    eval $1=$ip_addr
    eval $2="5912"
    eval $3="1"
}

hello SERVER PORT INTERVAL

echo $SERVER
echo $PORT
echo $INTERVAL
