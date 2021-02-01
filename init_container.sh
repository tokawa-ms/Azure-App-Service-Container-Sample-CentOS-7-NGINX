#!/bin/sh

# Get environment variables to show up in SSH session
eval $(printenv | awk -F= '{print "export " $1"="$2 }' >> /etc/profile)

/usr/sbin/sshd-keygen
/usr/sbin/sshd

# start nginx as Foreground
exec nginx -g 'daemon off;'
