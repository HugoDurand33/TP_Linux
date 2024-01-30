# TP 2

# Partie : Files and users

## I. Fichiers

### 1. Find me

🌞 Trouver le chemin vers le répertoire personnel de votre utilisateur

```
[hugo@localhost /]$ cd /home/hugo/
```

🌞 Trouver le chemin du fichier de logs SSH

```
[hugo@localhost log]$ sudo cat /var/log/secure
```

🌞 Trouver le chemin du fichier de configuration du serveur SSH

```
[hugo@localhost ssh]$ cat /etc/ssh/sshd_config
```

## II. Users

### 1. Nouveau user

🌞 Créer un nouvel utilisateur

- il doit s'appeler marmotte

```
[hugo@localhost /]$ sudo useradd marmotte
```

- son password doit être chocolat

```
[hugo@localhost etc]$ sudo passwd marmotte
```

- son répertoire personnel doit être le dossier /home/papier_alu/

```
[hugo@localhost home]$ sudo mv marmotte papier_alu
```

### 2. Infos enregistrées par le système

🌞 Prouver que cet utilisateur a été créé

```
[hugo@localhost etc]$ sudo cat passwd | grep marmotte
marmotte:x:1001:1001::/home/marmotte:/bin/bash
```

🌞 Déterminer le hash du password de l'utilisateur marmotte

```
[hugo@localhost etc]$ sudo cat shadow | grep marmotte
marmotte:$6$7Uem66oRCovIAD4V$2KWFX6ZeTLh41o6W77mBnQp6xD6imw69TYwfeEBvPJYS6ke.RgT2NAW8ZQ1d1SYfMWIEONnVyd7agBjksFscc1:19744:0:99999:7:::
```

### 3. Connexion sur le nouvel utilisateur

🌞 Tapez une commande pour vous déconnecter : fermer votre session utilisateur

```
[hugo@localhost etc]$ exit
```

🌞 Assurez-vous que vous pouvez vous connecter en tant que l'utilisateur marmotte

```
[marmotte@localhost /]$
```

# Partie 2 : Programmes et paquets

## I. Programmes et processus

### 1. Run then kill

🌞 Lancer un processus sleep

```
[hugo@localhost ~]$ sleep 1000

[hugo@localhost /]$ ps -ef | grep sleep
hugo        1771    1656  0 11:46 pts/0    00:00:00 sleep 1000
hugo        1776    1679  0 11:48 pts/1    00:00:00 grep --color=auto sleep
```

🌞 Terminez le processus sleep depuis le deuxième terminal

```
[hugo@localhost /]$ kill 1771
```

### 2. Tâche de fond

🌞 Lancer un nouveau processus sleep, mais en tâche de fond

```
[hugo@localhost ~]$ sleep 1000 &
```

🌞 Visualisez la commande en tâche de fond

```
[hugo@localhost ~]$ jobs -p
1784
```

### 3. Find paths

🌞 Trouver le chemin où est stocké le programme sleep

```
[hugo@localhost /]$ sudo find -name sleep
[sudo] password for hugo:
./usr/bin/sleep

[hugo@localhost /]$ ls -al /usr/bin/sleep | grep sleep
-rwxr-xr-x. 1 root root 36312 Apr 24  2023 /usr/bin/sleep
```

🌞 Tant qu'on est à chercher des chemins : trouver les chemins vers tous les fichiers qui s'appellent .bashrc

```
[hugo@localhost /]$ sudo find / -name "*.bashrc"
/etc/skel/.bashrc
/root/.bashrc
/home/hugo/.bashrc
/home/papier_alu/.bashrc
```

### 4. La variable PATH

🌞 Vérifier que

```
[hugo@localhost /]$ echo $PATH
/home/hugo/.local/bin:/home/hugo/bin:/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin

[hugo@localhost /]$ which sleep
/usr/bin/sleep

[hugo@localhost /]$ which ssh
/usr/bin/ssh

[hugo@localhost /]$ which ping
/usr/bin/ping
```

## II. Paquets

🌞 Installer le paquet git

```
[hugo@localhost ~]$ sudo dnf install git-all
```

🌞 Utiliser une commande pour lancer Firefox

```
[hugo@localhost ~]$ which git
/usr/bin/git
```

🌞 Installer le paquet nginx

```
[hugo@localhost ~]$ sudo dnf install nginx
```

🌞 Déterminer

- le chemin vers le dossier de logs de NGINX

```
[hugo@localhost /]$ cd /var/log/nginx/access.log
```

- le chemin vers le dossier qui contient la configuration de NGINX

```
[hugo@localhost /]$ sudo find -name "*nginx*"
/etc/nginx/nginx.conf
```

🌞 Mais aussi déterminer...

# Partie 3 : Poupée russe

🌞 Récupérer le fichier meow

```
[hugo@localhost /]$ sudo wget https://gitlab.com/it4lik/b1-linux-2023/-/raw/master/tp/2/meow?inline=false
```

🌞 Trouver le dossier dawa/

```
[hugo@localhost ~]$ file meow
meow: Zip archive data, at least v2.0 to extract
[hugo@localhost ~]$ unzip meow.zip
Archive:  meow.zip
  inflating: meow
```

```
[hugo@localhost ~]$ file meow
meow: XZ compressed data
[hugo@localhost ~]$ xz -d meow.xz
```

```
[hugo@localhost ~]$ file meow
meow: bzip2 compressed data, block size = 900k
[hugo@localhost ~]$ bzip2 -d moew.bz2
```

```
[hugo@localhost ~]$ file moew
moew: RAR archive data, v5
[hugo@localhost ~]$ unrar x meow.rar
```