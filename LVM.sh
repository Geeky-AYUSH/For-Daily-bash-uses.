#!/bin/bash
#HOW TO INCREASE LVSIZE AUTOMATICALLY WITH BASH SCRIPT???
# To check the current use % of a harddisk
output=$(df -h | grep -w "/dev/mapper/class-ayush" | awk '{print $5}' | tr -d '%,')

#Checking for the vg if available space is present to increase the lvm or we need to add some
vgsize=$(vgs |grep -w "class" | awk '{print $7}' | tr -d 'm,')
intvgsize=$(printf "%.0f\n" $vgsize)
pvsize=$(pvs |grep -w "/dev/sdb1" | awk '{print $6}' | tr -d 'm,')
intpvsize=$(printf "%.0f\n" $pvsize)
if [ $intvgsize -gt 500 ]
then
lvextend -L +500M /dev/mapper/class-ayush
elif [ $intpvsize -lt 500 ]
then
echo " PV size is less so please create a new pv"
echo " Enter the partition name to add in PV:"
read partition
pvcreate $partition
echo " Successfully PV created"
echo "Extend the VG by giving name:"
read name
vgextend $name $partition
echo " VG is sucessfully extend please run vgs and pvs to see results" 
fi
if [ $output -gt 30 ]
then 
  lvextend -L +900M /dev/mapper/class-ayush
 xfs_growfs /dev/mapper/class-ayush
fi   
