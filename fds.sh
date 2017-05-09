#!/bin/bash

#choice=`echo $1 | tr '[a-z]' '[A-Z]'`
choice=`echo ipmi | tr '[a-z]' '[A-Z]'`
vendor=`dmidecode -s bios-vendor | tr '[a-z]' '[A-Z]'| awk '{print $1}'`
model=`dmidecode -s system-product-name |  awk '{print $2" "$3}' | tr '[a-z]' '[A-Z]' | sed 's/GEN/G/' | sed 's/ /_/' | sed 's/_$//'`

function HP()
{
 wget -P /root/ http://192.168.137.181/$choice/$vendor/$model/$choice
 rpm -ivh /root/$choice
 setup=`rpm -qlp $choice | grep /hpsetup`
 $setup -s -f #-r(리붓 옵션을 사용하면 rpm을 삭제 할 수 없음)
 if [ $choice = BIOS ]
 then
  remove=`rpm -qa | grep hp-firmware-system`
 elif [ $choice = IPMI ]
 then
  remove=`rpm -qa | grep hp-firmware-ilo4`
 fi
 rpm -e $remove
 rm -rf /root/$choice
 #TEST 완료서버: HP => DL360P_G8(bios,ipmi), DL380P_G8(bios,ipmi)
 #문제점: 경로를 root해서 실행해야됨, RC패키지 파일이 설치가 안됨
 #예상 문제점: .rpm 파일이 아닌 exe 파일일 때 어떻게 되는지 test 필요 ipmi: DL360_G6, DL360_G7는 exe 파일임
}

function DELL()
{
 wget -P /root/ http://192.168.137.181/$choice/$vendor/$model/$choice
 chmod 755 /root/$choice
 /root/$choice -q -r
 rm -rf /root/$choice
 #TEST 완료서버: DELL => R510(bios,r/c), R720XD(bios,ipmi)
}

$vendor;
reboot
