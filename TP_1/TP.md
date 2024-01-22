# TP_1

## II. Casser

### 1. Objectif

### 2. Fichier

🌞 Supprimer des fichiers

- je fais la commande ```su - root``` pour avoir tout les droits sur la VM

```
[root@localhost etc]# rm passwd

PS C:\Users\gogob_jaotmdf> ssh hugo@10.6.1.12
kex_exchange_identification: read: Connection reset
Connection reset by 10.6.1.12 port 22
```

-on ne peut plus se connecter a la VM même en ssh.

### 3. Utilisateurs

🌞 Mots de passe

```
[root@localhost ~]# nano /etc/shadow
```

- on écrit de la merde dans le fichier

```
[hugo@localhost ~]$ su - root
Password:
su: Authentication failure
```

🌞 Another way ?




