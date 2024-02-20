# TP 4

## Partie 1 : Partitionnement du serveur de stockage

🌞 Partitionner le disque à l'aide de LVM

- créer un physical volume (PV)

```bash
[hugo@storage ~]$ sudo pvcreate /dev/sdb
[sudo] password for hugo:
  Physical volume "/dev/sdb" successfully created.
[hugo@storage ~]$ sudo pvcreate /dev/sdc
  Physical volume "/dev/sdc" successfully created.
```

- créer un nouveau volume group (VG)

```bash
[hugo@storage ~]$ sudo vgcreate storage /dev/sdb
  Volume group "storage" successfully created
[hugo@storage ~]$ sudo vgextend storage /dev/sdc
  Volume group "storage" successfully extended
[hugo@storage ~]$ sudo vgs
  Devices file sys_wwid t10.ATA_VBOX_HARDDISK_VB6de65671-aa63df02 PVID Ne4Fb1eU6q4uMlheHDPsllxJJqdHtdWa last seen on /dev/sda2 not found.
  VG      #PV #LV #SN Attr   VSize VFree
  storage   2   0   0 wz--n- 3.99g 3.99g
```

- créer un nouveau logical volume (LV) : ce sera la partition utilisable

```bash
[hugo@storage ~]$ sudo lvcreate -l 100%FREE storage -n lv_storage
[sudo] password for hugo:
  Logical volume "lv_storage" created.
[hugo@storage ~]$ sudo lvs
  Devices file sys_wwid t10.ATA_VBOX_HARDDISK_VB6de65671-aa63df02 PVID Ne4Fb1eU6q4uMlheHDPsllxJJqdHtdWa last seen on /dev/sda2 not found.
  LV         VG      Attr       LSize Pool Origin Data%  Meta%  Move Log Cpy%Sync Convert
  lv_storage storage -wi-a----- 3.99g
```

🌞 Formater la partition

- vous formaterez la partition en ext4 (avec une commande mkfs)

```bash
[hugo@storage ~]$ sudo mkfs -t ext4 /dev/storage/lv_storage
[sudo] password for hugo:
mke2fs 1.46.5 (30-Dec-2021)
Creating filesystem with 1046528 4k blocks and 261632 inodes
Filesystem UUID: 8e3c172b-6397-4ee2-b007-832cdbf55383
Superblock backups stored on blocks:
        32768, 98304, 163840, 229376, 294912, 819200, 884736

Allocating group tables: done
Writing inode tables: done
Creating journal (16384 blocks): done
Writing superblocks and filesystem accounting information: done
```

🌞 Monter la partition

- montage de la partition (avec la commande mount)

```bash
[hugo@storage storage]$ sudo mount  /dev/storage/lv_storage /dev/storage/mnt_storage/
[hugo@storage storage]$ df -h | grep storage
/dev/mapper/storage-lv_storage  3.9G   24K  3.7G   1% /dev/storage/mnt_storage

[hugo@storage mnt_storage]$ sudo nano test
[sudo] password for hugo:
[hugo@storage mnt_storage]$ cat test
MEEEEEOOOOOWWWWW
```

- définir un montage automatique de la partition (fichier /etc/fstab)

```bash
[hugo@storage mnt_storage]$ sudo umount /dev/storage/mnt_storage
umount: /dev/storage/mnt_storage: target is busy.
[hugo@storage mnt_storage]$ cd /home/hugo/
[hugo@storage ~]$ sudo umount /dev/storage/mnt_storage
[hugo@storage ~]$ sudo mount -av
/                        : ignored
/boot                    : already mounted
none                     : ignored
mount: /dev/storage/mnt_storage does not contain SELinux labels.
       You just mounted a file system that supports labels which does not
       contain labels, onto an SELinux box. It is likely that confined
       applications will generate AVC messages and not be allowed access to
       this file system.  For more details see restorecon(8) and mount(8).
mount: (hint) your fstab has been modified, but systemd still uses
       the old version; use 'systemctl daemon-reload' to reload.
/dev/storage/mnt_storage : successfully mounted
[hugo@storage ~]$ sudo reboot
[hugo@storage ~]$ Connection to 10.5.1.102 closed by remote host.
Connection to 10.5.1.102 closed.
```

## Partie 2 : Serveur de partage de fichiers

🌞 Donnez les commandes réalisées sur le serveur NFS storage.tp4.linux

```bash
[hugo@storage ~]$ sudo dnf install nfs-utils

[hugo@storage storage]$ sudo mkdir site_web_1
[hugo@storage storage]$ sudo mkdir site_web_2

[hugo@storage storage]$ sudo nano /etc/exports

[hugo@storage storage]$ sudo systemctl enable nfs-server
Created symlink /etc/systemd/system/multi-user.target.wants/nfs-server.service → /usr/lib/systemd/system/nfs-server.service.
[hugo@storage storage]$ sudo systemctl start nfs-server

[hugo@storage storage]$ sudo firewall-cmd --permanent --add-service=nfs
success
[hugo@storage storage]$ sudo firewall-cmd --permanent --add-service=mountd
success
[hugo@storage storage]$ sudo firewall-cmd --permanent --add-service=rpc-bind
success
[hugo@storage storage]$ sudo firewall-cmd --reload
success

[hugo@storage storage]$ sudo firewall-cmd --permanent --list-all | grep services
  services: cockpit dhcpv6-client mountd nfs rpc-bind ssh
```
- contenu du fichier `/etc/exports` dans le compte-rendu notamment

```bash
[hugo@storage site_web_1]$ sudo cat /etc/exports
[sudo] password for hugo:
/dev/storage/site_web_1 10.5.1.101(rw,sync,no_subtree_check)
/dev/storage/site_web_2 10.5.1.101(rw,sync,no_subtree_check)
```
🌞 Donnez les commandes réalisées sur le client NFS web.tp4.linux

```bash
[hugo@web ~]$ sudo dnf install nfs-utils -y

[hugo@web ~]$ sudo mkdir -p /nfs/general
[sudo] password for hugo:
[hugo@web ~]$ sudo mkdir -p /nfs/home

[hugo@web www]$ sudo mkdir site_web_1
[hugo@web www]$ sudo mkdir site_web_2
[hugo@web www]$ sudo mount 10.5.1.102:/dev/storage/site_web_1 /var/www/site_web_1
[hugo@web www]$ sudo mount 10.5.1.102:/dev/storage/site_web_2 /var/www/site_web_2

[hugo@web www]$ df -h | grep 10.5.1.102
10.5.1.102:/dev/storage/site_web_1  4.0M     0  4.0M   0% /var/www/site_web_1
10.5.1.102:/dev/storage/site_web_2  4.0M     0  4.0M   0% /var/www/site_web_2

[hugo@web site_web_1]$ sudo touch test
[hugo@web site_web_1]$ sudo nano test
[hugo@web site_web_1]$ cat test
test 1 2 3 4 5 6 7 8 9

[hugo@web site_web_1]$ sudo nano /etc/fstab
```

- contenu du fichier `/etc/fstab` dans le compte-rendu notamment

```bash
[hugo@web site_web_1]$ cat /etc/fstab

#
# /etc/fstab
# Created by anaconda on Mon Oct 23 09:14:19 2023
#
# Accessible filesystems, by reference, are maintained under '/dev/disk/'.
# See man pages fstab(5), findfs(8), mount(8) and/or blkid(8) for more info.
#
# After editing this file, run 'systemctl daemon-reload' to update systemd
# units generated from this file.
#
/dev/mapper/rl-root     /                       xfs     defaults        0 0
UUID=c07c37d6-37d3-497c-8c28-b3f3b1966d11 /boot                   xfs     defaults        0 0
/dev/mapper/rl-swap     none                    swap    defaults        0 0
10.5.1.102:/dev/storage/site_web_1 /var/www/site_web_1 nfs auto,nofail,noatime,nolock,intr,tcp,actimeo=1800 0 0
10.5.1.102:/dev/storage/site_web_1 /var/www/site_web_1 nfs auto,nofail,noatime,nolock,intr,tcp,actimeo=1800 0 0
```

## Partie 3 : Serveur web

### 1. Intro NGINX

### 2. Install

🌞 Installez NGINX

```bash
[hugo@web site_web_1]$ sudo dnf install nginx -y
```

### 3. Analyse

🌞 Analysez le service NGINX

- avec une commande ps, déterminer sous quel utilisateur tourne le processus du service NGINX

```bash
[hugo@web ~]$ ps -ef | grep nginx
root       12276       1  0 10:17 ?        00:00:00 nginx: master process /usr/sbin/nginx
nginx      12277   12276  0 10:17 ?        00:00:00 nginx: worker process
hugo       12284    1308  0 10:18 pts/0    00:00:00 grep --color=auto nginx
```

- avec une commande ss, déterminer derrière quel port écoute actuellement le serveur web

```bash
[hugo@web ~]$ sudo ss -atnlp | grep nginx
LISTEN 0      511          0.0.0.0:80        0.0.0.0:*    users:(("nginx",pid=12277,fd=6),("nginx",pid=12276,fd=6))
LISTEN 0      511             [::]:80           [::]:*    users:(("nginx",pid=12277,fd=7),("nginx",pid=12276,fd=7))
```

- en regardant la conf, déterminer dans quel dossier se trouve la racine web

```bash
[hugo@web nginx]$ sudo cat /etc/nginx/nginx.conf | grep root
        root         /usr/share/nginx/html;
#        root         /usr/share/nginx/html;
```

- inspectez les fichiers de la racine web, et vérifier qu'ils sont bien accessibles en lecture par l'utilisateur qui lance le processus

```bash
[hugo@web nginx]$ ls -dl /usr/share/nginx/html
drwxr-xr-x. 3 root root 143 Feb 20 10:14 /usr/share/nginx/html
```

### 4. Visite du service web

🌞 Configurez le firewall pour autoriser le trafic vers le service NGINX

```
[hugo@web nginx]$ sudo firewall-cmd --add-port=80/tcp --permanent
[sudo] password for hugo:
success
[hugo@web nginx]$ sudo firewall-cmd --reload
success
```

🌞 Accéder au site web

```bash
[hugo@web nginx]$ curl http://10.5.1.101:80 | head
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0<!doctype html>
<html>
  <head>
    <meta charset='utf-8'>
    <meta name='viewport' content='width=device-width, initial-scale=1'>
    <title>HTTP Server Test Page powered by: Rocky Linux</title>
    <style type="text/css">
      /*<![CDATA[*/

      html {
100  7620  100  7620    0     0   465k      0 --:--:-- --:--:-- --:--:--  496k
curl: (23) Failed writing body
```

🌞 Vérifier les logs d'accès

```bash
[hugo@web nginx]$ sudo cat access.log | tail -3
10.5.1.1 - - [20/Feb/2024:10:49:23 +0100] "GET /icons/poweredby.png HTTP/1.1" 200 15443 "http://10.5.1.101/" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36 Edg/121.0.0.0" "-"
10.5.1.1 - - [20/Feb/2024:10:49:23 +0100] "GET /poweredby.png HTTP/1.1" 200 368 "http://10.5.1.101/" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36 Edg/121.0.0.0" "-"
10.5.1.1 - - [20/Feb/2024:10:49:23 +0100] "GET /favicon.ico HTTP/1.1" 404 3332 "http://10.5.1.101/" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36 Edg/121.0.0.0" "-"
```

### 5. Modif de la conf du serveur web

🌞 Changer le port d'écoute

- une simple ligne à modifier, vous me la montrerez dans le compte rendu

```bash
[hugo@web nginx]$ cat /etc/nginx/nginx.conf | grep 8080
        listen       8080;
        listen       [::]:8080;
```

- prouvez-moi que le changement a pris effet avec une commande ss

```bash
[hugo@web nginx]$ ss -atnlp | grep 8080
LISTEN 0      511          0.0.0.0:8080      0.0.0.0:*
LISTEN 0      511             [::]:8080         [::]:*
```

- n'oubliez pas de fermer l'ancien port dans le firewall, et d'ouvrir le nouveau

```bash
[hugo@web nginx]$ sudo firewall-cmd --remove-port=80/tcp --permanent
success
[hugo@web nginx]$ sudo firewall-cmd --add-port=8080/tcp --permanent
success
[hugo@web nginx]$ sudo firewall-cmd --reload
success
```

- prouvez avec une commande curl sur votre machine que vous pouvez désormais visiter le port 8080

```bash
[hugo@web nginx]$ curl http://10.5.1.101:8080 |  head
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0<!doctype html>
<html>
  <head>
    <meta charset='utf-8'>
    <meta name='viewport' content='width=device-width, initial-scale=1'>
    <title>HTTP Server Test Page powered by: Rocky Linux</title>
    <style type="text/css">
      /*<![CDATA[*/

      html {
100  7620  100  7620    0     0   496k      0 --:--:-- --:--:-- --:--:--  531k
curl: (23) Failed writing body
```

🌞 Changer l'utilisateur qui lance le service

- pour ça, vous créerez vous-même un nouvel utilisateur sur le système : web

```bash
[hugo@web nginx]$ sudo useradd web -m
```

- modifiez la conf de NGINX pour qu'il soit lancé avec votre nouvel utilisateur

```bash
[hugo@web ~]$ sudo cat /etc/nginx/nginx.conf | grep user
user web;
```

- vous prouverez avec une commande ps que le service tourne bien sous ce nouveau utilisateur

```bash
[hugo@web ~]$ ps -ef | grep web
web        12708   12707  0 11:29 ?        00:00:00 nginx: worker process
hugo       12716   12656  0 11:30 pts/0    00:00:00 grep --color=auto web
```

🌞 Changer l'emplacement de la racine Web

```bash
[hugo@web ~]$ sudo cat /etc/nginx/nginx.conf | grep root
        root         /var/www/site_web_1/index.html;
#        root         /usr/share/nginx/html;
```

- prouvez avec un curl depuis votre hôte que vous accédez bien au nouveau site

```bash
[hugo@web ~]$ curl http://10.5.1.101:8080
<h1>MEEEEOOOOWWWWW c'est un chat</h1>
```

### 6. Deux sites web sur un seul serveur

🌞 Repérez dans le fichier de conf

- la ligne qui inclut des fichiers additionels contenus dans un dossier nommé conf.d

```bash
[hugo@web ~]$ sudo cat /etc/nginx/nginx.conf | grep conf.d
    # Load modular configuration files from the /etc/nginx/conf.d directory.
    include /etc/nginx/conf.d/*.conf;
```

🌞 Créez le fichier de configuration pour le deuxième site

- un nouveau fichier dans le dossier conf.d

```bash
[hugo@web site_web_2]$ cat /etc/nginx/conf.d/site_web_2.conf
server {
        listen       8888;
        listen       [::]:8888;
        server_name  _;
        root         /var/www/site_web_2/;

        # Load configuration files for the default server block.
        include /etc/nginx/default.d/*.conf;

        error_page 404 /404.html;
        location = /404.html {
        }

        error_page 500 502 503 504 /50x.html;
        location = /50x.html {
        }
    }
```

- et changez le port d'écoute pour 8888

```bash
[hugo@web site_web_2]$ sudo firewall-cmd --list-all | grep ports
  ports: 8080/tcp 8888/tcp
```

🌞 Prouvez que les deux sites sont disponibles

- depuis votre PC, deux commandes curl

- site web 1

```powershell
PS C:\Users\gogob_jaotmdf> curl http://10.5.1.101:8080
Content           : <h1>MEEEEOOOOWWWWW c'est un chat</h1>
```

- site web 2

```powershell
PS C:\Users\gogob_jaotmdf> curl http://10.5.1.101:8888
Content           : <h1>iazerogfbzreoitgkyazrejfiohgtÃ©eyanu</h1>
```
