#!/bin/sh
#################################################
#
#  ET-2400G remote manager daemon script
#
#  2018/08/23
#  Author: LuoMin(luomin@etonetech.com)
#
#################################################

SERVER="192.168.1.159"
PORT="3000"
FILE_PATH="rest/api/config"
NEW_CONFIG_FILE="new_config.json"
CONFIG_FILE="config.json"
INTERVAL=10
DEV_MASK=
LAN_RECV=
LAN_SEND=
DATE=
ZERO_MASK="\"00000000\""



#
# Function that get the br_lan interface infomation.
#
function get_br_lan_info() {
    GateWay_IP_ADDR=$(ifconfig br-lan|grep "inet addr"|awk -F '[ :]' '{print $13}')
    LAN_RECV=$(ifconfig br-lan|grep "RX bytes:"|awk -F '[()]' '{print $2}')
    LAN_SEND=$(ifconfig br-lan|grep "RX bytes:"|awk -F '[()]' '{print $4}')
}

#
# Function that get the external interface infomation.
#
function get_external_info() {
    echo
}

#
# Function that get the 4g interface infomation.
#
function get_4g_info() {
    echo
}

#
# Function that get the local wifi interface infomation.
#
function get_wifi_info() {
    WIFI_IP_ADDR=$(ifconfig wlan0|grep "inet addr"|awk -F '[ :]' '{print $13}')
}

#
# Function that get the network interface infomation.
#
function get_network_info() {
    get_br_lan_info
    get_4g_info
    get_wifi_info
}

#
# Function that get the gateway infomation.
#
function get_gw_info() {
    get_network_info 
    get_date_info
}

#
# Function that get the gateway infomation.
#
function get_ups_info() {
    echo
}

#
# Function that get the gateway infomation.
#
function get_camera_info() {
    echo
}

#
# Function that get the gateway infomation.
#
function get_date_info() {
    DATE=$(date)
}

#
# Function that get the periphera infomation.
#
function get_peripheral_info() {
    get_ups_info
    get_camera_info
}

function get_conf_dev_mask() {
    jq '.DevMask' $NEW_CONFIG_FILE
}

function get_power_func_mask() {
    jq '.Power.mask' $NEW_CONFIG_FILE
}

function get_gateway_func_mask() {
    jq '.GateWay.mask' $NEW_CONFIG_FILE
}

function get_ups_func_mask() {
    jq '.UPS.mask' $NEW_CONFIG_FILE
}

function get_camera_func_mask() {
    jq '.Camera.mask' $NEW_CONFIG_FILE
}

function power_switch() {
    echo "Config power switch $1."
}

function set_power_dev() {
    local j
    local tmp_val
    local func_mask
    local switch_flag

    FUNC_MASK=$(get_power_func_mask)
    echo "FUNC MASK:${FUNC_MASK}"

    if [ -n FUNC_MASK ]; then
        for j in 9 8 7 6 5 4 3 2
        do
            echo "j=$j"
            tmp_val=$(echo $FUNC_MASK|cut -c $j)

            echo "temp val:$tmp_val"

            if [ $tmp_val == '1' ]; then
                func_mask=$((2**$((9-j))))  
                echo "func mask:${func_mask}"
            else
                continue
            fi
            
            case $func_mask in
                1)
                    echo "Config main power switch..."
                    switch_flag=$(jq '.Power.function.switch' $NEW_CONFIG_FILE)
                    echo "switch flag:${switch_flag}"
                    power_switch $switch_flag                        
                    ;;
                2)
                    echo "power voltage..."
                    ;;
                4)
                    echo "power electricity..."
                    ;;
                8)
                    echo "Config xxx device..."
                    ;;
                16)
                    echo "Config xxx device..."
                    ;;
                32)
                    echo "Config xxx device..."
                    ;;
                64)
                    echo "Config xxx device..."
                    ;;
                128)
                    echo "Config xxx device..."
                    ;;
                *)
                    echo "unknow device option."
                    ;;
            esac
        done
    fi
}

function set_gateway_ip() {
    echo "ipadd:$1"
    uci set network.lan.ipaddr=$1
    uci commit 
}

function set_gateway_mask() {
    uci set network.lan.mask=$1
    uci commit
}

function set_4g_switch() {
    uci set network.usb0=$1
    uci commit
}

function network_restart() {
    echo
    #/etc/init.d/network restart
}

function set_gateway_mac() {
    echo "$1"
    #ifconfig br-lan down
    #ifconfig br-lan hw ether $1
    #ifconfig br-lan up 
}

function switch_4g() {
    echo "switch 4g=$1"
    if [ $1=="on" ]; then
        echo 
    fi

    if [ $1=="off" ]; then
        echo 
    fi
}

function set_gateway_dev() {
    local j
    local tmp_val
    local func_mask
    local ip_addr 
    local ip_mask
    local haddr
    local Set_Network_Flag
    local switch4g_flag

    FUNC_MASK=$(get_gateway_func_mask)

    if [ -n FUNC_MASK ]; then
        Set_Network_Flag="0"
    
        for j in 9 8 7 6 5 4 3 2;
        do
            tmp_val=$(echo $FUNC_MASK|cut -c $j)
            if [ ${tmp_val} == '1' ]; then
                func_mask=$((2**$((9-j))))   
            else
                continue
            fi

            case ${func_mask} in
                1)
                    echo "Config gateway device IP address..."
                    ip_addr=$(jq '.GateWay.function.ip' $NEW_CONFIG_FILE)
                    ip_addr=$(echo $ip_addr|sed 's/\"//g')
                    set_gateway_ip ${ip_addr}
                    Set_Network_Flag="1"
                    ;;
                2)
                    echo "Conifg Gateway device IP mask..."
                    ip_mask=$(jq '.GateWay.function.mask' $NEW_CONFIG_FILE)
                    ip_mask=$(echo $ip_mask|sed 's/\"//g')
                    set_gateway_mask $ip_mask
                    Set_Network_Flag="1"
                    ;;
                4)
                    echo "Conifg Gateway device mac address..."
                    haddr=$(jq '.GateWay.function.mac' $NEW_CONFIG_FILE)
                    haddr=$(echo $haddr|sed 's/\"//g')
                    set_gateway_mac $haddr
                    Set_Network_Flag="1"
                    ;;
                8)
                    echo "Config 4g switch..."
                    switch4g_flag=$(jq '.GateWay.function.switch4g' $NEW_CONFIG_FILE)
                    switch4g_flag=$(echo $switch4g_flag|sed 's/\"//g')
                    switch_4g $switch4g_flag
                    ;;
                16)
                    echo "Config xxx switch..."
                    ;;
                32)
                    echo "Config xxx device..."
                    ;;
                64)
                    echo "Config xxx device..."
                    ;;
                128)
                    echo "Config xxx device..."
                    ;;
                *)
                    echo "unknow device option."
                    ;;
            esac
        done

        echo "test function"

        echo $Set_Network_Flag

        if [ "$Set_Network_Flag" = "1" ]; then
            echo "network restart"
            network_restart
            sleep 3
        fi
    fi 
}

function set_ups_dev() {
    local j
    local tmp_val
    local func_mask
    local switch_flag

    FUNC_MASK=$(get_ups_func_mask)

    if [ -n ${FUNC_MASK} ]; then
        for j in 9 8 7 6 5 4 3 2
        do
            tmp_val=$(echo $FUNC_MASK|cut -c $j)
            echo "tmp_val:$tmp_val"
            if [ "$tmp_val" = "1" ]; then
                func_mask=$((2**$((9-j))))
            else
                continue
            fi

            case $func_mask in
                1)
                    echo "Config ups power switch..."
                    ;;
                2)
                    echo "Conifg Gateway device..."
                    ;;
                4)
                    echo "Conifg UPS device..."
                    set_ups_dev
                    ;;
                8)
                    echo "Config camera device..."
                    set_camera_dev
                    ;;
                16)
                    echo "Config xxx device..."
                    ;;
                32)
                    echo "Config xxx device..."
                    ;;
                64)
                    echo "Config xxx device..."
                    ;;
                128)
                    echo "Config xxx device..."
                    ;;
                *)
                    echo "unknow device option."
                    ;;
            esac

        done
    fi
}

function set_camera_dev() {
    local j
    local tmp_val
    local func_mask
    local switch_flag

    FUNC_MASK=$(get_camera_func_mask)

    if [ -n FUNC_MASK ]; then
        for j in 9 8 7 6 5 4 3 2
        do
            tmp_val=$(echo $FUNC_MASK|cut -c $j)
            if [ "$tmp_val" = "1" ]; then
                func_mask=$((2**$((9-j)))) 
            else
                continue
            fi

            case $func_mask in
                1)
                    echo "Config camera..."
                    ;;
                2)
                    echo "Conifg camera device..."
                    ;;
                4)
                    echo "Conifg camera device..."
                    ;;
                8)
                    echo "Config camera device..."
                    ;;
                16)
                    echo "Config xxx device..."
                    ;;
                32)
                    echo "Config xxx device..."
                    ;;
                64)
                    echo "Config xxx device..."
                    ;;
                128)
                    echo "Config xxx device..."
                    ;;
                *)
                    echo "unknow device option."
                    ;;
            esac

        done
    fi
}

function set_dev() {
    local val
    local temp_mask 
    local i

    if [ -n $DEV_MASK ]; then
        for i in 9 8 7 6 5 4 3 2
        do
            echo "i=$i"
            val=$(echo $DEV_MASK|cut -c $i)

            if [ $val == "1" ];then
                temp_mask=$((2**$((9-$i))))
                echo "temp mask:${temp_mask}"
            else
                continue
            fi

            case ${temp_mask} in
                1)
                    echo "Config main power..."
                    set_power_dev
                    ;;
                2)
                    echo "Conifg Gateway device..."
                    set_gateway_dev
                    echo "exit set gateway dev"
                    ;;
                4)
                    echo "Conifg UPS device..."
                    set_ups_dev
                    ;;
                8)
                    echo "Config camera device..."
                    set_camera_dev
                    ;;
                16)
                    echo "Config xxx device..."
                    ;;
                32)
                    echo "Config xxx device..."
                    ;;
                64)
                    echo "Config xxx device..."
                    ;;
                128)
                    echo "Config xxx device..."
                    ;;
                *)
                    echo "unknow device option."
                    ;;
            esac
        done
    fi
}

function apply_config() {
    if [ -n ${DEV_MASK} ]; then
        echo "entry set dev funciton..."
        set_dev
    else
        echo "CONFIG FILE MASK is NULL..."
        return
    fi
}

#
# Function that analyze the config file infomation.
#
function conf_analy() {
    local md5_old
    local md5_new

    MD5_FILE=$CONFIG_FILE
    md5_old=$(check_md5)
    echo "md5_old:${md5_old}"

    MD5_FILE=$NEW_CONFIG_FILE
    md5_new=$(check_md5)
    echo "md5_new:${md5_new}"

    if [ $md5_old != $md5_new ]; then
        DEV_MASK=$(get_conf_dev_mask)

        echo "DEV MASK:${DEV_MASK}"
        echo "ZERO_MASK:${ZERO_MASK}"
        
        if [ $DEV_MASK != $ZERO_MASK ]; then
            echo "entry apply config."
            apply_config
        fi
    fi

    #if [ -f $NEW_CONFIG_FILE ]; then
    #    cp -rf ${NEW_CONFIG_FILE} ${CONFIG_FILE}
    #else
    #    echo "new config file not exist!\n"
    #fi
}

function post_data() {
    local cmd

    cmd="curl -o ${NEW_CONFIG_FILE} -l --connect-timeout 2 -H "Content-type:application/json" -X POST -d '${DATA}' http://${SERVER}:${PORT}/${FILE_PATH}/${CONFIG_FILE}"
    echo ${cmd}
    eval ${cmd} #> /tmp/demon_error.log 2>&1
    echo $?

}

function check_md5() {

    if [ -f ${MD5_FILE} ]; then
        md5sum ${MD5_FILE}|awk '{print $1}'
    else
        echo "0"
    fi
}

function update_gateway_info() {
    local cmd

    cmd="jq '.' $NEW_CONFIG_FILE > $CONFIG_FILE"
    eval ${cmd}

    rm -rf NEW_CONFIG_FILE
}

function update_post_data() {
    local cmd

    cmd="jq '.Date=\"${DATE}\" | .GateWay.function.modinfo.iprecv=\"${LAN_RECV}\" | .GateWay.function.modinfo.ipsend=\"${LAN_SEND}\"' $CONFIG_FILE"
    DATA=$(eval $cmd)
}

while true
do
    get_gw_info
    #get_peripheral_info
    update_post_data

    if [ -n ${SERVER} ];then
        if [ -n ${PORT} ];then
            post_data
            conf_analy
            update_gateway_info
            echo "main logic"
        else
            echo "The Port is Null!"
        fi
    else
        echo "The Server address is Null!"
    fi

    sleep $INTERVAL
done
