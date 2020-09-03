#!/bin/sh
PERCENT=$1
USER=$2
MAIL_FROM=`grep ^postmaster /etc/postfix/virtual | awk '{ print $2 }' `
cat << EOF | /usr/lib/dovecot/dovecot-lda -d $USER -o "plugin/quota=maildir:User quota:noenforcing"
From: $MAIL_FROM
Subject: Mailbox quota warning

Your mailbox is now $PERCENT% full.
Please take actions before it reaches 100% to avoid email being discarded by the server.


EOF
