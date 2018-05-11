#!/bin/sh

/bin/chmod 700 /data
/bin/chown -R geth /data


echo "exec command: geth $PARAMS"

exec sudo -H -u geth /usr/bin/geth $@
