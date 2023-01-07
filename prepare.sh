#!/bin/sh
export PATH="/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/sbin:/usr/local/bin"

# exit on error
set -o errexit

# trace on
set -o xtrace

pkg update -f
pkg install -y reggae

hash -r

grep -v Commented /usr/local/etc/reggae.conf.sample | sed 's:# ::g' > /usr/local/etc/reggae.conf

reggae network-init
service pflog restart
service pf restart
reggae cbsd-init
env NOINTER=1 reggae master-init

# trace off
set +o xtrace

echo "Reggae init complete"
exit 0
