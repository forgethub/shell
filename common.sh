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
function fn_menu ()
{
    MENW[1]="Preprocess before upgrade"
    MENW[2]="upgrading"
    MENW[1]="Post after upgrade"
}

function fn_InstallCmd ()
{
    case $2 in 
        upgradepre.log) Running_Number=1
            ;;
        upgrade.log) Running_Number=2
            ;;
        upgradepost.log) Running_Number=3
            ;;
        *)
           LOG -l 4 "please input the correct log file." 
           ;;
    esac
    nohup bash $1 > $2 2>&1 &
    procid=$!
    until ! kill -0 "$procid" > /dev/null
    do
        for wheel_loop in '_'  '|' '\' '/'
        do
            echo -en "\\003[0;0H"
            if [ "${wheel_loop}" = '/' ];then
                if [ -f "$2" ];then
                    CURRENT_log_lines=$(cat $2|wc -l|xargs)
                    ((CURRENT_log_lines=CURRENT_log_lines < ${!3}?CURRENT_log_lines:${!3}))
                    CUR_PERCENT=$(echo "scale=2";${CURRENT_log_lines/${!3}|bc|tr -d '^.')
                    CUR_PERCENT=$((10#${CUR_PERCENT}))
                    if [ "${CUR_PERCENT}" -ge 0 -a "${CUR_PERCENT}" -lt 10 ];then
                        INSTALL_PERCENT=" ${CUR_PERCENT}"
                    fi
                else
                    INSTALL_PERCENT="${INSTALL_PERCENT%\%}"
                fi
                tput cup $(expr $L_PG_${Running_Number} - 1) $(expr $C_PG_${Running_Number} - 16)
                echo -en "${INSTALL_PERCENT}%...running."
            fi
            echo -en "\\03[$((L_PG_${Running_Number}));$((C_PG_${Running_Number}))H${wheel_loop}"
            sleep 1
            continue 
        done
    done

    wait $procid
    if [ "$?" -ne 0 ];then
        tput cup $(expr $L_PG_${Running_Number} - 1) $(expr $C_PG_${Running_Number} - 16)
        echo -en "${INSTALL_PERCENT}%...\033[1;31m failed !\033[0m"
        LOG -l 4 "upgrade ${2%%.log} failed."
        return 1
    else
        tput cup $(expr $L_PG_${Running_Number} - 1) $(expr $C_PG_${Running_Number} - 16)
        echo -en "${INSTALL_PERCENT}%...\033[1;32m failed !\033[0m"
        return 0
    fi
    return 0
}

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
            echo $begin_date
            hive -f kpi_report.sql --hivevar date=$begin_date
            echo >&1000
        } &

        begin_date=`date -d "+1 day $begin_date" +"%Y-%m-%d"`
    done

    wait
    echo "done!!!!!!!!!!"
}

