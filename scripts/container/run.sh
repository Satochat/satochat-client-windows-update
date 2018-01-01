#!/bin/bash

pure-pw show "$FTP_USER" -f /etc/pure-ftpd/passwd/pureftpd.passwd 2>&1 > /dev/null \
    || (echo "$FTP_PASSWORD" | python /scripts/create-ftp-user.py "$FTP_USER") \
    || exit 1
chown -R ftpuser /home/ftpusers
/run.sh -c 5 -C 5 -l puredb:/etc/pure-ftpd/pureftpd.pdb -E -j -R -P "$FTP_WAN_HOST" -p 30000:30009 || exit 1
