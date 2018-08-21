#!/bin/bash
#=============================================================================
#
# Author: zhouzhibo
#
# id : 613013
#
# Last modified: 2018-08-20 11:35
#
# Filename: common.sh
#
# Description: 
#
#=============================================================================

#common var
CUR_USE=$(whoami)
LOGIN_USE=$(who -u am i |sed "s!\s.*!!")
ABS_DIR=$(cd $(dirname -- $0);pwd)
FILE_DIR=$(basename -- $0)

#function area
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
    local comment=""

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

    mesg="[$(date +%D\ %T)];${level_str};${tag};login_user=${LOGIN_USE};${FILE_DIR};${result_flag};${CUR_LOGINIP:-127.0.0.1};${comment}"

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

}

