#!/bin/sh

set -e

# Set CVSROOT for sao-faq
#CVSROOT=/var/cvs
#export CVSROOT

faq=$1
sigfile=$HOME/.signature-faq
maintainer="Juha Autero"
maintainer_email="jautero+faq@iki.fi"

if [ "$NNTPSERVER" = "" ]; then
    NNTPSERVER="news-server.welho.com"
    export NNTPSERVER
fi

if [ "$faq" != "sao-faq" -a "$faq" != "saoa-faq" ]
then
    echo "Usage error. Usage $0 sao-faq | saoa-faq"
    exit 1
fi

prev_msgid=`cat $faq.msgid`

if [ ! -x random ]; then
    # Create random binary with make
    make
fi

new_msgid=\<sao-faq-`date +%s`-$$-`./random`@`cat /etc/mailname`\>

if [ ! -d sao-faq ]; then
    cvs checkout sao-faq
fi

( cd sao-faq && cvs update && make )

version=`cvs status sao-faq/$faq.sgml | awk '/Working revision:/ {print $3}'`

(
    echo "From: $maintainer <$maintainer_email>"
    echo "Newsgroups: `cat $faq.groups`"
    echo "Followup-To: `cat $faq.fup`"
    echo "Supersedes: $prev_msgid"
    echo "Message-ID: $new_msgid"
    echo "Subject: `cat $faq.subject` versio: $version"
    echo "Date: `LANG=C date -R`"
    echo "Expires: `LANG=C date -R --date='next month 6 days'`"
    echo
    cat $faq.prelude
    cat sao-faq/$faq.txt
    echo
    echo '-- '
    cat $sigfile
) | ./inews.py -h

echo "$new_msgid" > $faq.msgid
echo "posting successful."
exit 0
