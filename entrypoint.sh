#!/usr/bin/dumb-init /bin/sh

set -e

#chown objectivefs:objectivefs /volume
#chown objectivefs:objectivefs -R /var/cache/objectivefs

echo "Starting objectivefs...."

ntpdate -q pool.ntp.org

#echo "/volume  0.0.0.0(rw,fsid=222,no_subtree_check,mp,async)" >> /etc/exports
#sed -i '/RPCNFSDCOUNT=/c\RPCNFSDCOUNT=64' /etc/default/nfs-kernel-server

# Start supervisord and services
exec /usr/bin/supervisord -n -c /etc/supervisord.conf
