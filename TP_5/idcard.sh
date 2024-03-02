#!/usr/bin/bash
# hugo
# 23/02/2024

echo "Machine Name : $(hostnamectl | grep Static | cut -d " " -f4)"
source /etc/os-release
echo "OS $(echo $NAME) and kernel version is $(uname -r)"
echo "IP : $(ip a | grep enp0s3 | tail -n 1 | cut -d " " -f6)"
echo "RAM : $(free -mh | grep Mem | tr -s " " | cut -d " " -f7) memory available on $(free -mh | grep Mem | tr -s " " | cut -d " " -f2) total memory"
echo "Disk : $(df -mh | grep root | tr -s " " | cut -d " " -f4) space left"
echo "Top 5 processes by RAM usage :"
for i in $(seq 2 6)
do
    echo "     - Le processus $(ps aux --sort=-%mem | tail -n +${i} | head -n 1 | tr -s " " | cut -d " " -f2) utilise $(ps aux --sort=-%mem | tail -n +${i} | head -n 1 | tr -s " " | cut -d " " -f4)% de la RAM"
done
echo "Listening ports :"
while read ligne ; do
    numero="$(echo $ligne | cut -d ' ' -f5 | cut -d ':' -f2)"
    protocole="$(echo $ligne |cut -d ' ' -f1)"
    nom="$(echo $ligne | cut -d '/' -f3 | cut -d "." -f1 )"
    echo "     - ${numero} ${protocole} : ${nom}"
done <<< "$(ss -4lne | grep service | tr -s " ")"
echo "PATH directories :"
while read path ; do
    echo "     - ${path}"
done <<< "$(echo $PATH | tr ':' '\n' )"
echo " "
echo "Here is your random cat (jpg file) https://th.bing.com/th/id/OIP.IbhnBcBXK5wyahXWCgklRQHaJ4?rs=1&pid=ImgDetMain"