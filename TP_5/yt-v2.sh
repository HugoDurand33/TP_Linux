#!/usr/bin/bash
# hugo
# 04/03/2024
while  true;
do  
    if [ ! -d /srv/yt/downloads  ]; then
        echo "Le dossier n'existe pas"
        exit
    fi

    if [ ! -e /srv/yt/liens_video ]; then
        echo "le fichier n'existe pas"
        exit
    fi

    URL=$(cat /srv/yt/liens_video | head -n 1) 
    
    if [[ $URL =~ ^https:\/\/www\.youtube\.com\/watch\?v=[A-Za-z0-9_-]{11}.*$ ]]; then
        nom_video=$(youtube-dl -e $URL)
        nom_video=${nom_video// /_}
        mkdir /srv/yt/downloads/$nom_video
        youtube-dl $URL -o /srv/yt/downloads/$nom_video/$nom_video.mp4 > /dev/null
        echo "Video $URL was downloaded."
        youtube-dl --write-description $URL -o /srv/yt/downloads/$nom_video/$nom_video > /dev/null
        echo "File path : /srv/yt/downloads/$nom_video."

        if [ ! -d /var/log/yt ]; then
            echo "Le dossier n'existe pas"
            exit
        fi

        date=$(date '+%Y/%m/%d')
    heure=$(date '+%H:%M:%S')

    echo "[$date $heure] Video $URL was downloaded. File path : /srv/yt/downloads/$nom_video" >> /var/log/yt/download.log
    fi

    
    sed -i '1d' "/srv/yt/liens_video"

done