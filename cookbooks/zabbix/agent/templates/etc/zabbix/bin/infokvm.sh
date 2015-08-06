#!/bin/bash

LANG=C
scale=2

DOM_LIST=(`virsh list --all|grep "^ "|grep -v "^ Id"|awk '{print $2}'`)
IMG_PATH=()
for domain in "${DOM_LIST[@]}"
do
    IMG_PATH+=(`virsh domblklist ${domain} |grep "^vda"|awk '{print $2}'`)
done

disk_cap(){
    DISK_CAP='0'
    for img_path in "${IMG_PATH[@]}"
    do
        size=`virsh vol-info ${img_path}|grep "^Capacity:"|awk -F'[ .]' '{print $8}'`
        DISK_CAP=`expr ${DISK_CAP} + ${size}`
    done
    echo ${DISK_CAP}
}

disk_allo(){
    DISK_ALLO='0'
    for img_path in "${IMG_PATH[@]}"
    do
        size=`virsh vol-info ${img_path}|grep "^Allocation:"|awk '{print $2}'`
        DISK_ALLO=`echo ${DISK_ALLO}+${size}|bc`
    done
    echo ${DISK_ALLO}|awk -F. '{print $1}'
}

cpu_used(){
    CPU_USED='0'
    for domain in "${DOM_LIST[@]}"
    do
        size=`virsh dominfo ${domain}|grep "^CPU(s):"|awk '{print $2}'`
        CPU_USED=`expr ${CPU_USED} + ${size}`
    done
    echo ${CPU_USED}
}

mem_used(){
    MEM_USED='0'
    for domain in "${DOM_LIST[@]}"
    do
        size=`virsh dominfo ${domain}|grep "^Max memory:"|awk '{print $3}'`
        MEM_USED=`expr ${MEM_USED} + ${size}`
    done
    echo ${MEM_USED}
}

cpu_total(){
    virsh nodeinfo|grep "^CPU(s):"|awk '{print $2}'
}

mem_total(){
    virsh nodeinfo|grep "^Memory size:"|awk '{print $3}'
}

disk_total(){
    unit=`virsh pool-info default|grep "^Capacity:"|awk '{print $3}'`
    if [ ${unit} == 'TiB' ]; then
        echo "`virsh pool-info default|grep '^Capacity:'|awk '{print $2}'` * 1024"|bc|awk -F. '{print $1}'
    else
        virsh pool-info default|grep "^Capacity:"|awk '{print $2}'|awk -F. '{print $1}'
    fi
}

case "${1}" in
    disk_cap)
        disk_cap
        ;;
    disk_allo)
        disk_allo
        ;;
    cpu_used)
        cpu_used
        ;;
    mem_used)
        mem_used
        ;;
    cpu_total)
        cpu_total
        ;;
    mem_total)
        mem_total
        ;;
    disk_total)
        disk_total
        ;;
    *)
        disk_cap
        disk_allo
        cpu_used
        mem_used
        cpu_total
        mem_total
        disk_total
        ;;
esac

exit $RETVAL
