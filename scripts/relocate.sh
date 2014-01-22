#!/bin/bash

export PATH=/bin:/usr/bin/:/sbin:/usr/sbin

echo "`date`: $@" >> /tmp/all.log

XNAME="$1"
XNAMESPACE="$2"
XCLASS="$3"
XPATH="$4"
XDESTINATION="$5"

echo "copying: [${XPATH}] to [${XDESTINATION}]" >> /tmp/all.log

mv -f "${XPATH}" "${XDESTINATION}"

exit 0
