#!/usr/local/bin/zsh

# path to dottorrents
DTORRENT_DIR='/path/to/dottorrents/*.torrent'

# list of directories to look for torrent data
DEST_DIRS=(
           '/Volumes/HDD/Torrents/'
           '/Volumes/External/Torrents/'
           '/Volumes/SSD/Torrents/'
)

TR_AUTH=user:password
TR_URL=transmissiond_ip:9091

for FILE in ${DTORRENT_DIR}; do
    for DIR in ${DEST_DIRS}; do
        echo "----------------------------------------------------------------------"
        torrentcheck -t "${FILE}" -p "${DIR}";
        if [ $? -eq 0 ]; then
            echo "----------------------------------------------------------------------"
            echo "SUCCESS: ${FILE} found in ${DIR}";
            echo "----------------------------------------------------------------------"
            # optionally copy dottorrent to certain directory
            # cp -n "${FILE}" /Users/sam/dottorrents/.
            transmission-remote ${TR_URL} \
                                               --auth=${TR_AUTH} \
                                               --download-dir "${DIR}" \
                                               -a "${FILE}" \
                                               --start-paused \
                                               --verify;
            echo "----------------------------------------------------------------------"
            break;
        else
            echo "----------------------------------------------------------------------"
            echo "FAILED:  ${FILE} not found in ${DIR}";
            echo "----------------------------------------------------------------------"
        fi
    done
done
