#!/bin/bash
#=============================================================================
#
# Author: zhouzhibo
#
# QQ : 943927833
#
# Last modified: 2018-07-02 21:09
#
# Filename: common.sh
#
# Description: commom script
#
#============================================================================*/

#common var
SCP="scp -rp StrictHostKeyChecking -o BatchMode=yes"
SSH="ssh -n -o StrictHostKeyChecking -o BatchMode=yes"
CUR_USE=$(whoami)
ABS_DIR=$(cd $(dirname -- $0);pwd)
FILE_DIR=$(basename -- $0)
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
    local l_err_return="$1"
    local l_err_comment="$2"
    [ -n "${l_err_comment}" ] && echo -n "${l_err_comment}  " || echo -en "\\033[65G"
    if [ "${l_err_return}" -eq "0" ]
    then
        echo -en "\\033[32m[done]"
        echo -e "\\033[0;39m"
    else
        echo -en "\\033[1;31m[fail]"
        echo -e "\\033[0;39m"
    fi
    return 0
}

function fn_touch_logfile ()
{
    if [ ! -f "${log_file}" ]
    then
        logfile_dir=$(dirname ${log_file})
        [ ! -d "${logfile_dir}" ] && mkdir -p --mode=750 ${logfile_dir}
        touch "${log_file}"
    fi
}

#Descripttion commom log function
#parmeters see below for detail
function LOG()
{
    local level="2"
    local level_str="INFO"
    local is_echo="false"
    local tag="${CUR_USE}"
    local startTime=`date "+%Y-%m-%d %T"`
    local maxsize=1024
    local log_file="/tmp/build_ftp.log"
    local result_flag="success"

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
            result_flag="failed";;
        s)
            result_flag="success";;
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

    mesg="[$(date +%D\ %T)];${level_str};${tag};${FILE_DIR};${result_flag};${CUR_LOGINIP:-127.0.0.1};${comment}"

    fn_touch_logfile
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
    if [ "${is_echo}" = "ture" ]
    then
        echo "${mesg}" |tee -a ${log_file}
    else
        echo "${mesg}" >> ${log_file}
    fi

#Descripttion dispaly upgrade process show 
#parmeters $1 logfile length; $2 logfile
function fn_display_process ()
{
    fn_menu
    local num_list=1
    local log_size=$1
    local log_file=$2
    MENU_COUNT=${#MENW[*]} 
    for((i=1;i<=$(expr $MENU_COUNT + 10);i++))
    do
        if [ -n "${MENW[$i]}" ];then
            MENU_list[$i]=$i
        fi
    done

    NO_NULL_PROGRAM=$(echo ${MENU_list[*]})
    LAST_PROGRAM=${MENU_list[${#MENU_list}-1]}

    for i in ${NO_NULL_PROGRAM}
    do
        if [ "${num_list}" -lt 10 ];then
            num_list=" $num_list"
        else
            num_list="$num_list"
        fi
        echo -en "$num_list.${MENW[i]}....precent:00%wating..."
        echo -en "\e[n";read -sdR pos;pos=${pos#*[};p=${pos/;/ };eval L_PG_${i}=${p%% *};eval C_PG_${i}=${p##* }
        echo
    done 

    for((i=1;i<=79;i++))
    do
        echo -n "-"
    done
    echo
    echo -en "\e[n";read -sdR pos;pos=${pos#*[};p=${pos/;/ };eval L_END=${p%% *};eval C_END=${p##* }

    fn_InstallCmd $script $log_file $log_size
    local ret=$?
    tput cup $L_END $C_END
    exit $ret
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
            #注意不要使用临时文件存储数据，可以用变量，因为不同进程间的变量是隔离的，文件是操作系统层次的。
            echo $begin_date
            hive -f kpi_report.sql --hivevar date=$begin_date
            echo >&1000
        } &

        begin_date=`date -d "+1 day $begin_date" +"%Y-%m-%d"`
    done

    wait
    echo "done!!!!!!!!!!"
}

