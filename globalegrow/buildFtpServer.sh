#!/bin/bash

CUR_USE=$(whoami)
ABS_DIR=$(cd $(dirname $0);pwd)
FILE_BASE_NAME=$(basename $0)
common_script="${ABS_DIR}/common.sh"
root_dir="/data"
install_dir="/usr/local/services/vsftpd-3.0.3"

if [ -f "${common_script}" ]
then
    source ${common_script}
else 
    logger -t ${CUR_USE} -p local0.info "Cannot find the common script."
    echo "Cannot find the common script."
    exit 1
fi
LOG -l 1 "Start to execution ${FILE_BASE_NAME}. "

function fn_check ()
{
    [ ! -f /etc/redhat-release ] && {
        LOG -l 4 "Only centos or redhat system can use the ftp install tool."
        return 1    
    }
    [ ! -f ${ABS_DIR}/package/ftp_virtual.zip -o ! -f ${ABS_DIR}/package/ftp_centos6.zip  ] && {
        LOG -l 4 "Please upload the ftp install packages to the system."
        return 2    
    }

    local os_type=$(awk '/CentOS/{split($3,a,".");print a[1]}' /etc/redhat-release)
    dmidecode |egrep -q "Product Name.*VMware Virtual Platform" >/dev/null 2>&1
    if [ "$?" -eq 0 ]
    then
        install_type=virtual
    else
        case $os_type in
        6)
            install_type=centos6;;
        7)
            install_type=centos7;;
        *)
            LOG -l 4 "the script only support the centos6 and centos7."
            return 3;;
        esac
    fi        

    return 0
}

function fn_exit_script ()
{
    local l_result_num="$1"
    [ "${l_result_num}" -eq 0 ] && l_ret=0 || l_ret=4
    LOG -l ${l_ret} "End to execution ${FILE_BASE_NAME}"
    exit ${l_result_num}
}

function fn_read_arg ()
{
    while [ -z "${user}"  ]
    do  
        read -p "please input the value of you user name: " user
    done

    while [ -z "${usergroup}"  ]
    do  
        read -p "please input the value of you name: " usergroup
    done

    while [ -z "${project_dir}" ]
    do  
        read -p "please input the Absolute path of project: " project_dir
    done
    project_dir=$(echo ${project_dir}|sed 's!/$!!')
}

function fn_adduserdirect ()
{
    local ftp_user=""    
    local ftp_password=""

    if ! id $user 2>/dev/null
    then
        useradd ${user} -s /sbin/nologin 
    fi
       
    project_name=$(basename ${project_dir})
    project_base_dir="${root_dir}/${project_dir%%/*}"
    project_abs_dir="${root_dir}/${project_dir}"

    [ ! -d "${project_abs_dir}" ] && {
        mkdir -p ${project_abs_dir}
        chown -R ${user}:${usergroup} ${project_base_dir}
        find -L ${project_base_dir} -type d |xargs -i chmod 755 {}
    }
    
    [ ! -d "${install_dir}" ] && mkdir -p ${install_dir}
    
    case ${install_type} in
    virtual)
        unzip ${ABS_DIR}/package/ftp_virtual.zip -d ${install_dir};;
    centos6)
        unzip ${ABS_DIR}/package/ftp_centos6.zip -d ${install_dir};;
    centos7)
        unzip ${ABS_DIR}/package/ftp_centos7.zip -d ${install_dir};;
    esac
    
    #modify config file
    if [ -f ${install_dir}/etc/vsftpd.conf ] 
    then
        sed -i "s/guest_username=.*/guest_username=${user}/g" ${install_dir}/etc/vsftpd.conf
    else
        LOG -l 4 "Cannot find the ftp vsftpd.conf file." 
        return 4 
    fi
    
    #add ftpuser
    ftp_user="${project_name}"    
    ftp_password=$(echo $ftp_user |md5sum |cut -c 1-12)

    db_load=$(type db_load 2>/dev/null |sed -r 's/[^/]+//')
    test -z db_load && yum -y install db4-utils >/dev/null 2>&1
    echo -e "${ftp_user}\n${ftp_password}" |tee -a ${install_dir}/etc/users
    cd  ${install_dir}/etc
    $db_load -T -t hash -f users users.db
    cd - &>/dev/null

    if [ -f ${install_dir}/etc/vusers/demo ] 
    then
        mv ${install_dir}/etc/vusers/demo ${install_dir}/etc/vusers/${project_name}
        if grep -q 'local_root'  ${install_dir}/etc/vusers/${project_name}
        then
            sed -i "s#local_root=.*#local_root=${project_abs_dir}#g" ${install_dir}/etc/vusers/${project_name}
        else
            echo "local_root=${project_abs_dir}" >> ${install_dir}/etc/vusers/${project_name}
        fi
    else
        LOG -l 4 "Cannot find the ftp vsftpd.conf file." 
        return 4 
    fi

    return 0 
}

function fn_restart_ftp_server ()
{
   cat > /etc/pam.d/vsftpd << 'EOF'
#%PAM-1.0
auth    required /lib64/security/pam_userdb.so db=/usr/local/services/vsftpd-3.0.3/etc/users
account required /lib64/security/pam_userdb.so db=/usr/local/services/vsftpd-3.0.3/etc/users 
EOF
    db_load -T -t hash -f /usr/local/services/vsftpd-3.0.3/etc/users /usr/local/services/vsftpd-3.0.3/etc/users.db 
    iptables -A INPUT -p tcp --dport 53000 -j ACCEPT 
    chmod 750 ${install_dir}/sbin/vsftpd
    ${install_dir}/sbin/vsftpd ${install_dir}/etc/vsftpd.conf &
    return 0
}

function main ()
{
    local l_ret=0
    fn_check 
    l_ret=$? 
    [ "${l_ret}" -ne 0 ] && fn_exit_script $l_ret
    fn_read_arg
    fn_adduserdirect
    l_ret=$? 
    [ "${l_ret}" -ne 0 ] && fn_exit_script $l_ret
    fn_restart_ftp_server    
}

main 
fn_exit_script 0
