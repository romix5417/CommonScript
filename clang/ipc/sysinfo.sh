#!/bin/bash -
#===============================================================================
#
#          FILE: sysinit.sh
#
#         USAGE: ./sysinit.sh
#
#   DESCRIPTION: Get system info and init json file.
#
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: LMin, luomin5417@gmail.com
#  ORGANIZATION:
#       CREATED: 2019-04-19 10:15:31
#      REVISION:  ---
#===============================================================================

set -o nounset                              # Treat unset variables as an error

DEVTREE="DevConfTree.json"
TMP_DEVTREE="/tmp/DevConfTree.json"
TMP_FILE="/tmp/tempfile"

function board_init() {
    HOST_NAME=$(hostname)
    MAINBOARD_CPU_ARCH=$(arch)

    cmd="cat /proc/cpuinfo | grep \"model name\" | awk -F '[:]' '{print \$2}' | head -1"
    MAINBOARD_CPU_INFO=$(eval ${cmd})

    cmd="cat /proc/cpuinfo | grep \"model name\" | awk '{print NR}' | tail -n 1"
    MAINBOARD_CPU_THREADX=$(eval ${cmd})

    MAINBOARD_SYSTEM_OS=$(uname)
    MAINBOARD_SYSTEM_KERNEL=$(uname -r)


    cmd="free | grep \"Mem\" | awk '{print \$2}'"
    MAINBOARD_MEMORY_TOTAL=$(eval ${cmd})

    cmd="free | grep \"Mem\" | awk '{print \$3}'"
    MAINBOARD_MEMORY_USED=$(eval ${cmd})

    cmd="free | grep \"Mem\" | awk '{print \$4}'"
    MAINBOARD_MEMORY_FREE=$(eval ${cmd})

    cmd="free | grep \"Mem\" | awk '{print \$6}'"
    MAINBOARD_MEMORY_CACHE=$(eval ${cmd})

    cmd="jq '.hostname=\"${HOST_NAME}\" | .mainboard.cpu.arch=\"${MAINBOARD_CPU_ARCH}\" | .mainboard.cpu.info=\"${MAINBOARD_CPU_INFO}\" | .mainboard.cpu.threadx=\"${MAINBOARD_CPU_THREADX}\" | .mainboard.system.os=\"${MAINBOARD_SYSTEM_OS}\" | .mainboard.system.kernel_ver=\"${MAINBOARD_SYSTEM_KERNEL}\" | .mainboard.memory.total=\"${MAINBOARD_MEMORY_TOTAL}\" | .mainboard.memory.used=\"${MAINBOARD_MEMORY_USED}\" | .mainboard.memory.free=\"${MAINBOARD_MEMORY_FREE}\" | .mainboard.memory.cache=\"${MAINBOARD_MEMORY_CACHE}\"' ${DEVTREE} > ${TMP_DEVTREE}"
    eval ${cmd}
}

function system_update() {
        cmd="cat /proc/uptime| awk -F. '{run_days=\$1 / 86400;run_hour=(\$1 % 86400)/3600;run_minute=(\$1 % 3600)/60;run_second=\$1 % 60;printf(\"%d天%d时%d分%d秒\",run_days,run_hour,run_minute,run_second)}'"
        MAINBOARD_SYSTEM_UPTIME=$(eval $cmd)

        cmd="free | grep \"Mem\" | awk '{print \$2}'"
        MAINBOARD_MEMORY_TOTAL=$(eval ${cmd})

        cmd="free | grep \"Mem\" | awk '{print \$3}'"
        MAINBOARD_MEMORY_USED=$(eval ${cmd})

        cmd="free | grep \"Mem\" | awk '{print \$4}'"
        MAINBOARD_MEMORY_FREE=$(eval ${cmd})

        cmd="free | grep \"Mem\" | awk '{print \$6}'"
        MAINBOARD_MEMORY_CACHE=$(eval ${cmd})

        cmd="cp ${TMP_DEVTREE} ${TMP_FILE}"
        eval $cmd

        cmd="jq '.mainboard.system.uptime=\"${MAINBOARD_SYSTEM_UPTIME}\" | .mainboard.memory.total=\"${MAINBOARD_MEMORY_TOTAL}\" | .mainboard.memory.used=\"${MAINBOARD_MEMORY_USED}\" | .mainboard.memory.free=\"${MAINBOARD_MEMORY_FREE}\" | .mainboard.memory.cache=\"${MAINBOARD_MEMORY_CACHE}\"' ${TMP_FILE} > ${TMP_DEVTREE}"
        eval $cmd

        cmd="rm ${TMP_FILE}"
        eval $cmd
}

case $1 in
    init)
        board_init
        ;;
    get)
        system_update

        cmd="jq $2 ${TMP_DEVTREE}"
        eval $cmd
        ;;
    set)
        cmd="cp ${TMP_DEVTREE} ${TMP_FILE}"
        eval $cmd

        cmd="jq '$2' ${TMP_FILE} > ${TMP_DEVTREE}"
        eval $cmd

        cmd="rm ${TMP_FILE}"
        eval $cmd
        ;;
esac
