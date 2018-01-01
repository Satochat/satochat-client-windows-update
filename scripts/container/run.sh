#!/bin/sh

pure-pw show "$FTP_USER" -f /etc/pure-ftpd/passwd/pureftpd.passwd > /dev/null \
    || echo "$FTP_PASSWORD" | python /scripts/create-ftp-user.py "$FTP_USER" \
    || exit 1

/run.sh -c 5 -C 5 -l puredb:/etc/pure-ftpd/pureftpd.pdb -E -j -R -P "$PUBLICHOST" -p 30000:30009 || exit 1
