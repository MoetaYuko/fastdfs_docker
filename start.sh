#!/bin/bash 
/usr/bin/fdfs_trackerd /etc/fdfs/tracker.conf restart
/usr/bin/fdfs_storaged /etc/fdfs/storage.conf restart
/usr/local/nginx/sbin/nginx -g "daemon off;"
