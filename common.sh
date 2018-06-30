#!/bin/bash

#common var
SCP="scp -rp StrictHostKeyChecking -o BatchMode=yes"
SSH="ssh -n -o StrictHostKeyChecking -o BatchMode=yes"
CUR_USE=$(whoami)
ABS_DIR=$($(cd dirname $0);pwd)

#Descripttion check the ip
#parmeters ip address
function fn_validity_ip()
{
    local IP_ADDR=$1
    echo $IP_ADDR|grep -E "^([0-9]{1,3}\.){3}[0-9]{1,3}$" >/dev/null 2>&1
    if [[ "$?" -eq 0 ]]
    then
        OLDIFS=$IFS
        IFS='.'
        IP_ADDR=($IP_ADDR)
        IFS=$OLDIFS
        if [[ "${IP_ADDR[0]}" -ge "0" && "${IP_ADDR[0]}" -le 255 \
            && "${IP_ADDR[1]}" -ge "0" && "${IP_ADDR[1]}" -le 255 \
            && "${IP_ADDR[2]}" -ge "0" && "${IP_ADDR[2]}" -le 255 \
            && "${IP_ADDR[3]}" -ge "0" && "${IP_ADDR[3]}" -le 255 ]]
        then
            return 0
        fi
    fi
    return 1
}

#Descripttion dispaly color info
#parmeters 0 or not 0
function fn_check_status ()
{
    local ERR_RETURN=$1
    echo -en "\\033[65G"
    if [ "${ERR_RETURN}" -eq "0" ]
    then
        echo -en "\\033[32m[done]"
        echo -e "\\033[0;39m"
    else
        echo -en "\\033[1;31m[fail]"
        echo -e "\\033[0;39m"
    fi
}

#Descripttion commom log function
#parmeters see below for detail
function LOG()
{
    local level="2"
    local level_str="INFO"
    local is_echo="false"
    local tag=""
    local startTime=`date "+%Y-%m-%d %T"`
    local maxsize=1024
    local log_file="script.log"

    OPTIND="1"
    while getopts ":t:l:c:emsf" opt
    do
        case $opt in
        t)
            tag="${OPTARG}";;
        l)
            level="${OPTARG}";;
        c)
            comment="${OPTARG}";;
        e)
            is_echo="true";;
        f)
            result_flag="failed"
        s)
            result_flag="true"
        :)
            echo "operation type $0 -${OPTARG} is no support.";;
        *)
            echo "operation type $0 -${OPTARG} is no support.";;
        esac
    done
    shift $((OPTIND-1))

    [ -n "$*" ] && comment="${comment} $*"
    comment=$(echo "${comment}"|sed -e "s#LICENSE.*=.*#LICENSE=#g" -e "s#password#pvalue#g")
    case ${level} in
    1)
        level_str="DEBUG";;
    2)
        level_str="INFO";;
    3)
        level_str="WARN";;
    4)
        level_str="ERROR";;
    esac

    mesg="[$(date +%D\ %T)];${level_str};${tag};${CUR_FILE_DIR};${result_flag};${CUR_LOGINIP:-127.0.0.1};${comment}"

    if [ ! -f "${log_file}" ]
    then
        logfile_dir=$(dirname ${log_file})
        mkdir -p ${logfile_dir}
    else
        local file_log_size=$(du -sk "${log_file}"| awk '{print $1}')
        if [ "${file_log_size}" -gt "${maxsize}" ];then
            file_basename=${log_file%.log}
            for index in 3 2 1
            do
                [ -f ${file_basename}_${index}.log ] && mv ${file_basename}_${index}.log ${file_basename}_$((index++)).log
            done
            cp -pf ${log_file} ${file_basename}_1.log
            :>${log_file}
        fi
    fi
}

#good methmod
#flock 互斥锁
#(
#    flock -n -x 7 7>&7
#    需要执行的语句
#    ...
#)7<> /tmp/$$.lock
#互斥锁的第二种方法
function fn_lock ()
{
    [ -f "lock.flag" ] && rm -rf lock.flag
    eval $1
    echo $! >lock.flag
    #检查是否有进程在执行，防止脚本执行多次
    if [ -f "lock.flag" ]
        read pid < lock.flag
        kill -0 $pid & >/dev/null
        if [ "$?" -eq 0 ];then
            LOG -el 4 "that is same script is running please wait."
            return 1
        fi
    fi
}

#升级进度条展示脚本
function fn_display_process ()
{

}

#多进程执行脚本
function fn_multiple_processes ()
{
    trap "exec 1000>&-;exec 1000<&-;exit 0" 2
    mkfifo $tempfifo
    exec 1000<>$tempfifo
    rm -rf $tempfifo

    for ((i=1; i<=8; i++))
    do
        echo >&1000
    done

    while [ $begin_date != $end_date ]
    do
        read -u1000
        {
            echo $begin_date
            hive -f kpi_report.sql --hivevar date=$begin_date
            echo >&1000
        } &

        begin_date=`date -d "+1 day $begin_date" +"%Y-%m-%d"`
    done

    wait
    echo "done!!!!!!!!!!"
}

