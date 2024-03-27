#!/usr/bin/bash
# hugo
# 04/03/2024

if [ ! -d ./downloads  ]; then
    echo "Le dossier n'existe pas"
    exit
fi

nom_video=$(youtube-dl -e $1)
nom_video=${nom_video// /_}
mkdir ./downloads/$nom_video
youtube-dl $1 -o ./downloads/$nom_video/$nom_video.mp4  > /dev/null
echo "Video $1 was downloaded."
youtube-dl --write-description $1 -o ./downloads/$nom_video/$nom_video> /dev/null
echo "File path : ./srv/yt/downloads/$nom_video."

if [ ! -d /var/log/yt ]; then
    echo "Le dossier n'existe pas"
    exit
fi

date=$(date '+%Y/%m/%d')
heure=$(date '+%H:%M:%S')

echo "[$date $heure] Video $1 was downloaded. File path : /srv/yt/downloads/$nom_video" >> /var/log/yt/download.log