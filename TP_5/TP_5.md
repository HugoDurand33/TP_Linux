# TP 5

## Partie 1 : Script carte d'identité

🌞 Vous fournirez dans le compte-rendu Markdown, en plus du fichier, un exemple d'exécution avec une sortie

```bash
[hugo@tp5 idcard]$ ./idcard.sh 
Machine Name : tp5
OS Rocky Linux and kernel version is 5.14.0-284.11.1.el9_2.x86_64
IP : 10.5.1.100/24
RAM : 285Mi memory available on 771Mi total memory
Disk : 16G space left
Top 5 processes by RAM usage :
     - Le processus 1410 utilise 13.7% de la RAM
     - Le processus 1626 utilise 12.9% de la RAM
     - Le processus 1515 utilise 9.5% de la RAM
     - Le processus 1637 utilise 7.2% de la RAM
     - Le processus 660 utilise 5.3% de la RAM
Listening ports :
     - 323 udp : chronyd
     - 22 tcp : sshd
PATH directories :
     - /home/hugo/.vscode-server/bin/903b1e9d8990623e3d7da1df3d33db3e42d80eda/bin/remote-cli
     - /home/hugo/.local/bin
     - /home/hugo/bin
     - /usr/local/bin
     - /usr/bin
     - /usr/local/sbin
     - /usr/sbin
 
Here is your random cat (jpg file) https://th.bing.com/th/id/OIP.IbhnBcBXK5wyahXWCgklRQHaJ4?rs=1&pid=ImgDetMain
```

## Partie 2 : Script youtube-dl

### 1. Premier script youtube-dl

📁 Le fichier de log /var/log/yt/download.log, avec au moins quelques lignes

```
[hugo@tp5 yt]$ cat /var/log/yt/download.log 
[2024/03/04 11:58:36] Video https://www.youtube.com/watch?v=a37d1BGLpWo was downloaded. File path : /srv/yt/downloads/cat_explode
[2024/03/04 11:59:58] Video https://www.youtube.com/watch?v=a37d1BGLpWo was downloaded. File path : /srv/yt/downloads/cat_explode
[2024/03/04 12:00:34] Video https://www.youtube.com/watch?v=u0GPQpAbTyw was downloaded. File path : /srv/yt/downloads/How_to_Pick_Up_a_Blue_Chair_Off_the_Ground
[2024/03/04 12:01:15] Video https://www.youtube.com/watch?v=B6kOsxoS-_g was downloaded. File path : /srv/yt/downloads/Emo_vs_duck
[2024/03/04 12:02:59] Video https://www.youtube.com/watch?v=B6kOsxoS-_g was downloaded. File path : /srv/yt/downloads/Emo_vs_duck
```

🌞 Vous fournirez dans le compte-rendu, en plus du fichier, un exemple d'exécution avec une sortie

```bash
[hugo@tp5 yt]$ ./yt.sh https://www.youtube.com/watch?v=B6kOsxoS-_g
Video https://www.youtube.com/watch?v=B6kOsxoS-_g was downloaded.
File path : /srv/yt/downloads/Emo_vs_duck.
```

### 2. MAKE IT A SERVICE

#### C. Rendu

📁 Le script /srv/yt/yt-v2.sh

📁 Fichier /etc/systemd/system/yt.service

🌞 Vous fournirez dans le compte-rendu, en plus des fichiers :

- systemctl status yt

```bash
[hugo@tp5 srv]$ systemctl status yt
● yt.service - video telecharge dans dossier + description
     Loaded: loaded (/etc/systemd/system/yt.service; disabled; preset: disabled)
     Active: active (running) since Wed 2024-03-27 18:56:13 CET; 2min 16s ago
   Main PID: 3990 (yt-v2.sh)
      Tasks: 2 (limit: 4674)
     Memory: 912.0K
        CPU: 1min 27.116s
     CGroup: /system.slice/yt.service
             ├─ 3990 /usr/bin/bash /srv/yt/yt-v2.sh
             └─11395 sed -i 1d /srv/yt/liens_video

Mar 27 18:56:13 tp5 systemd[1]: Started video telecharge dans dossier + description.
Mar 27 18:56:27 tp5 yt-v2.sh[4026]: mkdir: cannot create directory ‘/srv/yt/downloads/Les_PIRES_ARNAQUES_de>
Mar 27 18:56:39 tp5 yt-v2.sh[3990]: Video https://www.youtube.com/watch?v=dw1qg6rHVRg was downloaded.
Mar 27 18:56:51 tp5 yt-v2.sh[4099]: ERROR: Cannot write description file /srv/yt/downloads/Les_PIRES_ARNAQU>
Mar 27 18:56:51 tp5 yt-v2.sh[3990]: File path : /srv/yt/downloads/Les_PIRES_ARNAQUES_de_STEAM_!_#2.
Mar 27 18:57:05 tp5 yt-v2.sh[4156]: mkdir: cannot create directory ‘/srv/yt/downloads/On_goûte_les_4_spécia>
Mar 27 18:57:18 tp5 yt-v2.sh[3990]: Video https://www.youtube.com/watch?v=Eu4RtkzDKzI was downloaded.
Mar 27 18:57:31 tp5 yt-v2.sh[4162]: ERROR: Cannot write description file /srv/yt/downloads/On_goûte_les_4_s>
Mar 27 18:57:32 tp5 yt-v2.sh[3990]: File path : /srv/yt/downloads/On_goûte_les_4_spécialités_culinaires_les>
```

- journalctl -xe -u yt

```bash
[hugo@tp5 srv]$ journalctl -xe -u yt
~
Mar 27 18:56:13 tp5 systemd[1]: Started video telecharge dans dossier + description.
░░ Subject: A start job for unit yt.service has finished successfully
░░ Defined-By: systemd
░░ Support: https://access.redhat.com/support
░░ 
░░ A start job for unit yt.service has finished successfully.
░░ 
░░ The job identifier is 927.
Mar 27 18:56:27 tp5 yt-v2.sh[4026]: mkdir: cannot create directory ‘/srv/yt/downloads/Les_PIRES_ARNAQUES_de_STEAM_!_#2’: File exists
Mar 27 18:56:39 tp5 yt-v2.sh[3990]: Video https://www.youtube.com/watch?v=dw1qg6rHVRg was downloaded.
Mar 27 18:56:51 tp5 yt-v2.sh[4099]: ERROR: Cannot write description file /srv/yt/downloads/Les_PIRES_ARNAQUES_de_STEAM_!_#2/Les_PIRES_ARNAQUES_de_STEAM_!_#2.description
Mar 27 18:56:51 tp5 yt-v2.sh[3990]: File path : /srv/yt/downloads/Les_PIRES_ARNAQUES_de_STEAM_!_#2.
Mar 27 18:57:05 tp5 yt-v2.sh[4156]: mkdir: cannot create directory ‘/srv/yt/downloads/On_goûte_les_4_spécialités_culinaires_les_plus_cheloues_de_la_planète_#3_(âmes_sensibles_s\’abstenir)’: File exists
Mar 27 18:57:18 tp5 yt-v2.sh[3990]: Video https://www.youtube.com/watch?v=Eu4RtkzDKzI was downloaded.
Mar 27 18:57:31 tp5 yt-v2.sh[4162]: ERROR: Cannot write description file /srv/yt/downloads/On_goûte_les_4_spécialités_culinaires_les_plus_cheloues_de_la_planète_#3_(âmes_sensibles_s’abstenir)/On_goûte_les_4_spécialités_culinair>
Mar 27 18:57:32 tp5 yt-v2.sh[3990]: File path : /srv/yt/downloads/On_goûte_les_4_spécialités_culinaires_les_plus_cheloues_de_la_planète_#3_(âmes_sensibles_s’abstenir).
```