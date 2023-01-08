#!/bin/sh
export PATH="/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/sbin:/usr/local/bin"

is_zfs=0
zfs get all / > /dev/null 2>&1
ret=$?
[ ${ret} -eq 0 ] && is_zfs=1

# exit on error
set -o errexit

trap "set +o xtrace; echo \"ERROR\"; cat /tmp/log.log" HUP INT ABRT BUS TERM EXIT

# trace on
set -o xtrace

###
pkg update -f > /tmp/log.log 2>&1
pkg install -y reggae > /tmp/log.log 2>&1

hash -r

grep -v Commented /usr/local/etc/reggae.conf.sample | sed 's:# ::g' > /usr/local/etc/reggae.conf

if [ ${is_zfs} -eq 1 ]; then
	# for ZFS
	sysrc -qf /usr/local/etc/reggae.conf ZFS_POOL="tank" USE_ZFS="yes"
else
	# for UFS
	sysrc -qf /usr/local/etc/reggae.conf ZFS_POOL="" USE_ZFS="no"
fi

reggae network-init > /tmp/log.log 2>&1
cat /tmp/log.log
service pflog restart > /tmp/log.log 2>&1
cat /tmp/log.log
service pf restart > /tmp/log.log 2>&1
cat /tmp/log.log
reggae cbsd-init > /tmp/log.log 2>&1
cat /tmp/log.log
env NOINTER=1 reggae master-init > /tmp/log.log 2>&1
cat /tmp/log.log

# trace off
set +o xtrace

exit 0
