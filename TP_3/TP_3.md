# TP 3

## I. Service SSH

### 1. Analyse du service

🌞 S'assurer que le service sshd est démarré

```bash
systemctl status sshd
● sshd.service - OpenSSH server daemon
     Loaded: loaded (/usr/lib/systemd/system/sshd.service; enabled; preset: enabled)
     Active: active (running) since Mon 2024-01-29 10:59:46 CET; 2min 11s ago
       Docs: man:sshd(8)
             man:sshd_config(5)
   Main PID: 702 (sshd)
      Tasks: 1 (limit: 4591)
     Memory: 4.9M
        CPU: 123ms
     CGroup: /system.slice/sshd.service
             └─702 "sshd: /usr/sbin/sshd -D [listener] 0 of 10-100 startups"

Jan 29 10:59:45 node.tp3.b1 systemd[1]: Starting OpenSSH server daemon...
Jan 29 10:59:46 node.tp3.b1 sshd[702]: Server listening on 0.0.0.0 port 22.
Jan 29 10:59:46 node.tp3.b1 sshd[702]: Server listening on :: port 22.
Jan 29 10:59:46 node.tp3.b1 systemd[1]: Started OpenSSH server daemon.
Jan 29 11:00:09 node.tp3.b1 sshd[1251]: Accepted publickey for hugo from 10.2.1.1 port 52320 ssh2: RSA SHA256:aeEnQRN7xTpYTZm8a4J1SNcby79/H9w49zqWmnS6x/A
Jan 29 11:00:09 node.tp3.b1 sshd[1251]: pam_unix(sshd:session): session opened for user hugo(uid=1000) by (uid=0)
```

🌞 Analyser les processus liés au service SSH

```bash
[hugo@node ~]$ ps -ef | grep sshd
root         702       1  0 10:59 ?        00:00:00 sshd: /usr/sbin/sshd -D [listener] 0 of 10-100 startups
root        1251     702  0 11:00 ?        00:00:00 sshd: hugo [priv]
hugo        1254    1251  0 11:00 ?        00:00:00 sshd: hugo@pts/0
hugo        1302    1255  0 11:03 pts/0    00:00:00 grep --color=auto sshd
```

🌞 Déterminer le port sur lequel écoute le service SSH

```bash
[hugo@node ~]$ ss -alnpt
State                Recv-Q               Send-Q                             Local Address:Port                               Peer Address:Port               Process
LISTEN               0                    128                                      0.0.0.0:22                                      0.0.0.0:*
LISTEN               0                    128                                         [::]:22                                         [::]:*
```

🌞 Consulter les logs du service SSH

```bash
[hugo@node ~]$ sudo cat /var/log/secure | tail -n 10
Jan 29 10:59:57 node login[712]: pam_unix(login:session): session opened for user hugo(uid=1000) by LOGIN(uid=0)
Jan 29 10:59:57 node login[712]: LOGIN ON tty1 BY hugo
Jan 29 11:00:09 node sshd[1251]: Accepted publickey for hugo from 10.2.1.1 port 52320 ssh2: RSA SHA256:aeEnQRN7xTpYTZm8a4J1SNcby79/H9w49zqWmnS6x/A
Jan 29 11:00:09 node sshd[1251]: pam_unix(sshd:session): session opened for user hugo(uid=1000) by (uid=0)
Jan 29 11:17:41 node sudo[1315]:    hugo : TTY=pts/0 ; PWD=/home/hugo ; USER=root ; COMMAND=/bin/cat /var/log/secure
Jan 29 11:17:41 node sudo[1315]: pam_unix(sudo:session): session opened for user root(uid=0) by hugo(uid=1000)
Jan 29 11:17:41 node sudo[1315]: pam_unix(sudo:session): session closed for user root
Jan 29 11:18:10 node sudo[1320]:    hugo : TTY=pts/0 ; PWD=/home/hugo ; USER=root ; COMMAND=/bin/cat /var/log/secure
Jan 29 11:18:10 node sudo[1320]: pam_unix(sudo:session): session opened for user root(uid=0) by hugo(uid=1000)
Jan 29 11:18:10 node sudo[1320]: pam_unix(sudo:session): session closed for user root
```

### 2. Modification du service

🌞 Identifier le fichier de configuration du serveur SSH

```bash
[hugo@node ~]$ cat /etc/ssh/sshd_config
```

🌞 Modifier le fichier de conf

- exécutez un echo $RANDOM pour demander à votre shell de vous fournir un nombre aléatoire

```bash
[hugo@node ~]$ echo $RANDOM
5414
```

- changez le port d'écoute du serveur SSH pour qu'il écoute sur ce numéro de port

```bash
[hugo@node ~]$ sudo cat /etc/ssh/sshd_config | grep Port
#Port 22
Port 5414
```

- gérer le firewall

```bash
[hugo@node ~]$ sudo firewall-cmd --add-port=5414/tcp --permanent
success

[hugo@node ~]$ sudo firewall-cmd --remove-port=22/tcp --permanent
Warning: NOT_ENABLED: 22:tcp
success

[hugo@node ~]$ sudo firewall-cmd --reload
success

[hugo@node ~]$ sudo firewall-cmd --list-all | grep ports
  ports: 5414/tcp
```

🌞 Redémarrer le service

```bash
[hugo@node ~]$ sudo systemctl restart firewalld
```

🌞 Effectuer une connexion SSH sur le nouveau port

```bash
PS C:\Users\gogob_jaotmdf> ssh -p 5414 hugo@10.2.1.11
Last login: Mon Jan 29 11:37:53 2024 from 10.2.1.1
```

## II. Service HTTP

### 1. Mise en place

🌞 Installer le serveur NGINX

```bash
[hugo@node ~]$ sudo dnf install nginx -y
Complete!
```

🌞 Démarrer le service NGINX

```bash
[hugo@node ~]$ sudo systemctl start nginx
```

🌞 Déterminer sur quel port tourne NGINX

```bash
[hugo@node ~]$ ss -atnl
State        Recv-Q       Send-Q             Local Address:Port             Peer Address:Port       Process
LISTEN       0            128                      0.0.0.0:22                    0.0.0.0:*
LISTEN       0            511                      0.0.0.0:80                    0.0.0.0:*
LISTEN       0            128                         [::]:22                       [::]:*
LISTEN       0            511                         [::]:80                       [::]:*
```

```bash
[hugo@node ~]$ sudo firewall-cmd --add-port=80/tcp --permanent
success
[hugo@node ~]$ sudo firewall-cmd --reload
success
[hugo@node ~]$ sudo firewall-cmd --list-all | grep port
  ports: 22/tcp 80/tcp
```

🌞 Déterminer les processus liés au service NGINX

```bash
[hugo@node ~]$ ps -ef | grep nginx
root        1785       1  0 12:07 ?        00:00:00 nginx: master process /usr/sbin/nginx
nginx       1786    1785  0 12:07 ?        00:00:00 nginx: worker process
hugo        1814    1576  0 12:12 pts/0    00:00:00 grep --color=auto nginx
```

🌞 Déterminer le nom de l'utilisateur qui lance NGINX

```bash
[hugo@node ~]$ sudo cat /etc/passwd | grep nginx
[sudo] password for hugo:
nginx:x:991:991:Nginx web server:/var/lib/nginx:/sbin/nologin
```

🌞 Test !

```bash
$ curl 10.2.1.11:80 | head -n 7
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0<!doctype html>
<html>
  <head>
    <meta charset='utf-8'>
    <meta name='viewport' content='width=device-width, initial-scale=1'>
    <title>HTTP Server Test Page powered by: Rocky Linux</title>
    <style type="text/css">
100  7620  100  7620    0     0   754k      0 --:--:-- --:--:-- --:--:--  826k
```

### 2. Analyser la conf de NGINX

🌞 Déterminer le path du fichier de configuration de NGINX

```bash
[hugo@node ~]$ ls -al /etc/nginx/nginx.conf
-rw-r--r--. 1 root root 2334 Oct 16 20:00 /etc/nginx/nginx.conf
```

🌞 Trouver dans le fichier de conf

- les lignes qui permettent de faire tourner un site web d'accueil (la page moche que vous avez vu avec votre navigateur)

```bash
[hugo@node ~]$ cat /etc/nginx/nginx.conf | grep server -A 5
    server {
        listen       80;
        listen       [::]:80;
        server_name  _;
        root         /usr/share/nginx/html;

        # Load configuration files for the default server block.
        include /etc/nginx/default.d/*.conf;

        error_page 404 /404.html;
        location = /404.html {
        }
```

- une ligne qui commence par include

```bash
[hugo@node ~]$ cat /etc/nginx/nginx.conf | grep include
include /etc/nginx/conf.d/*.conf;
```

### 3. Déployer un nouveau site web

🌞 Créer un site web

```bash
[hugo@node var]$ sudo mkdir www
[sudo] password for hugo:

[hugo@node www]$ sudo mkdir tp3_linux

[hugo@node tp3_linux]$ sudo touch index.html

[hugo@node tp3_linux]$ cat index.html
<h1>MEOW mon premier serveur web</h1>

<h2>MEEEEEEOOOOOOW</h2>
```

🌞 Gérer les permissions

```bash
[hugo@node tp3_linux]$ sudo chown -R nginx:nginx /var/www/tp3_linux/index.html
```

🌞 Adapter la conf NGINX

- dans le fichier de conf principal

```bash
[hugo@node tp3_linux]$ sudo systemctl restart nginx
```

- créez un nouveau fichier de conf

```bash
[hugo@node conf.d]$ cat index.conf
server {
  # le port choisi devra être obtenu avec un 'echo $RANDOM' là encore
  listen 4017;

  root /var/www/tp3_linux;
}
```

- Gérer le firewall

```bash
[hugo@node conf.d]$ sudo firewall-cmd --add-port=4017/tcp --permanent
success
[hugo@node conf.d]$ sudo firewall-cmd --reload
success
```

🌞 Visitez votre super site web

```bash
[hugo@node conf.d]$ curl 10.2.1.11:4017
<h1>MEOW mon premier serveur web</h1>

<h2>MEEEEEEOOOOOOW</h2>
```

## III. Your own services

### 1. Au cas où vous l'auriez oublié

### 2. Analyse des services existants

🌞 Afficher le fichier de service SSH

- vous pouvez obtenir son chemin avec un systemctl status <SERVICE>

```bash
[hugo@node conf.d]$ systemctl status sshd | head -n 5
● sshd.service - OpenSSH server daemon
     Loaded: loaded (🌞/usr/lib/systemd/system/sshd.service🌞; enabled; preset: enabled)
     Active: active (running) since Tue 2024-01-30 09:47:09 CET; 1h 33min ago
       Docs: man:sshd(8)
             man:sshd_config(5)
```

- mettez en évidence la ligne qui commence par ExecStart=

```bash
[hugo@node conf.d]$ cat /usr/lib/systemd/system/sshd.service | grep ExecStar
t=
ExecStart=/usr/sbin/sshd -D $OPTIONS
```

🌞 Afficher le fichier de service NGINX

```bash
[hugo@node conf.d]$ cat /usr/lib/systemd/system/nginx.service | grep ExecSta
rt=
ExecStart=/usr/sbin/nginx
```

### 3. Création de service

🌞 Créez le fichier /etc/systemd/system/tp3_nc.service

```bash
[hugo@node system]$ sudo touch tp3_nc.service
[hugo@node system]$ echo $RANDOM
24456
[hugo@node system]$ sudo nano tp3_nc.service
[hugo@node system]$ cat tp3_nc.service
[Unit]
Description=Super netcat tout fou

[Service]
ExecStart=/usr/bin/nc -l 24456 -k
```

🌞 Indiquer au système qu'on a modifié les fichiers de service

```bash
[hugo@node system]$ sudo systemctl daemon-reload
```

🌞 Démarrer notre service de ouf

```bash
[hugo@node system]$ sudo systemctl start tp3_nc
```

🌞 Vérifier que ça fonctionne

- vérifier que le service tourne avec un systemctl status <SERVICE>

```bash
[hugo@node system]$ systemctl status tp3_nc
● tp3_nc.service - Super netcat tout fou
     Loaded: loaded (/etc/systemd/system/tp3_nc.service; static)
     Active: active (running) since Tue 2024-01-30 11:32:09 CET; 45s ago
   Main PID: 1597 (nc)
      Tasks: 1 (limit: 4591)
     Memory: 784.0K
        CPU: 13ms
     CGroup: /system.slice/tp3_nc.service
             └─1597 /usr/bin/nc -l 24456 -k

Jan 30 11:32:09 node.tp3.b1 systemd[1]: Started Super netcat tout fou.
```

- vérifier que nc écoute bien derrière un port avec un ss

```bash
[hugo@node system]$ ss -atnlp | grep 24456
LISTEN 0      10           0.0.0.0:24456      0.0.0.0:*
LISTEN 0      10              [::]:24456         [::]:*
```

- vérifer que juste ça fonctionne en vous connectant au service depuis une autre VM ou votre PC

🌞 Les logs de votre service

- sudo journalctl -xe -u tp3_nc pour visualiser les logs de votre service

```bash
[hugo@node system]$ sudo journalctl -xe -u tp3_nc
[sudo] password for hugo:
~
~
~
~
~
~
~
~
~
~
~
~
~
~
~
~
~
~
~
~
~
~
~
~
~
Jan 30 11:32:09 node.tp3.b1 systemd[1]: Started Super netcat tout fou.
░░ Subject: A start job for unit tp3_nc.service has finished successfully
░░ Defined-By: systemd
░░ Support: https://wiki.rockylinux.org/rocky/support
░░
░░ A start job for unit tp3_nc.service has finished successfully.
░░
░░ The job identifier is 1214.
Jan 30 11:36:23 node.tp3.b1 nc[1597]: test
Jan 30 11:37:42 node.tp3.b1 nc[1597]: connard
Jan 30 11:37:45 node.tp3.b1 nc[1597]: affiche
Jan 30 11:37:47 node.tp3.b1 nc[1597]: toi
Jan 30 11:37:57 node.tp3.b1 nc[1597]: pas cool :(
```

- sudo journalctl -xe -u tp3_nc -f pour visualiser en temps réel les logs de votre service

```bash
[hugo@node system]$ sudo journalctl -xe -u tp3_nc -f
Jan 30 11:32:09 node.tp3.b1 systemd[1]: Started Super netcat tout fou.
░░ Subject: A start job for unit tp3_nc.service has finished successfully
░░ Defined-By: systemd
░░ Support: https://wiki.rockylinux.org/rocky/support
░░
░░ A start job for unit tp3_nc.service has finished successfully.
░░
░░ The job identifier is 1214.
Jan 30 11:36:23 node.tp3.b1 nc[1597]: test
Jan 30 11:37:42 node.tp3.b1 nc[1597]: connard
Jan 30 11:37:45 node.tp3.b1 nc[1597]: affiche
Jan 30 11:37:47 node.tp3.b1 nc[1597]: toi
Jan 30 11:37:57 node.tp3.b1 nc[1597]: pas cool :(
Jan 30 11:41:35 node.tp3.b1 nc[1597]: test 2
```

- dans le compte-rendu je veux

- une commande journalctl filtrée avec grep qui affiche la ligne qui indique le démarrage du service

```bash
[hugo@node system]$ sudo journalctl -xe -u tp3_nc | grep Start
Jan 30 11:32:09 node.tp3.b1 systemd[1]: Started Super netcat tout fou.
```

- une commande journalctl filtrée avec grep qui affiche un message reçu qui a été envoyé par le client

```bash
[hugo@node system]$ sudo journalctl -xe -u tp3_nc | grep nc
Jan 30 11:37:45 node.tp3.b1 nc[1597]: affiche
Jan 30 11:37:47 node.tp3.b1 nc[1597]: toi
```

- une commande journalctl filtrée avec grep qui affiche la ligne qui indique l'arrêt du service

```bash
[hugo@node system]$ sudo journalctl -xe -u tp3_nc | grep finish
░░ Subject: A start job for unit tp3_nc.service has finished successfully
░░ A start job for unit tp3_nc.service has finished successfully.
```

🌞 S'amuser à kill le processus

- repérez le PID du processus nc lancé par votre service

```bash
[hugo@node system]$ ps -ef | grep nc
dbus         652       1  0 09:47 ?        00:00:00 /usr/bin/dbus-broker-lanch --scope system --audit
root        1597       1  0 11:32 ?        00:00:00 /usr/bin/nc -l 24456 -k
hugo        1653    1258  0 11:51 pts/0    00:00:00 grep --color=auto nc
```

- utilisez la commande kill pour mettre fin à ce processus nc

```bash
[hugo@node system]$ kill -15 1597
```

🌞 Affiner la définition du service

- faire en sorte que le service redémarre automatiquement s'il se termine

```bash
[hugo@node system]$ sudo nano tp3_nc.service
[hugo@node system]$ sudo systemctl daemon-reload
[hugo@node system]$ cat tp3_nc.service
[Unit]
Description=Super netcat tout fou

[Service]
ExecStart=/usr/bin/nc -l 24456 -k
Restart=always
```

- normalement, quand tu kill il est donc relancé automatiquement