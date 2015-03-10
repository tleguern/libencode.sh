#!/bin/sh
#
# Copyright (c) 2015 Tristan Le Guern <tleguern@bouledef.eu>
#
# Permission to use, copy, modify, and distribute this software for any
# purpose with or without fee is hereby granted, provided that the above
# copyright notice and this permission notice appear in all copies.
#
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
# WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
# MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
# ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
# WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
# ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
# OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
#

set -e

readonly PROGNAME="$(basename $0)"
readonly VERSION='v1.0'
 
usage() {
	echo "usage: $PROGNAME [-e encoding] [-s string | file]"
}
 
file=""
eflag="base64"
sflag=""

while getopts ":e:s:" opt;do
	case $opt in
		e) eflag="$OPTARG";;
		s) sflag="$OPTARG";;
		:) echo "$PROGNAME: option requires an argument -- $OPTARG";
		   usage; exit 1;;
		?) echo "$PROGNAME: unkown option -- $OPTARG";
		   usage; exit 1;;
		*) usage; exit 1;;
	esac
done
shift $(( $OPTIND - 1 ))

if [ -n "$1" ]; then
	file="$1"
	shift
fi

if [ $# -ge 1 ]; then
	echo "$PROGNAME: invalid trailing chars -- $@"
	usage
	exit 1
fi

set -u

case "$eflag" in
	base16|hex) . ./base16.sh;;
	base32) . ./base32.sh;;
	base32hex) . ./base32hex.sh;;
	base64) . ./base64.sh;;
	base64url) . ./base64url.sh;;
	*) echo "$PROGNAME: invalid encoding algorithm -- $eflag";;
esac
if [ -n "$sflag" ] && [ -n "$file" ]; then
	usage
	exit 1
fi
if [ -z "$sflag" ] && [ -z "$file" ]; then
	usage
	exit 1
fi
if [ -n "$file" ]; then
	if [ -f "$file" ]; then
		#
		# Converts \n to \f to prevent the shell from 
		# stripping them
		#
		OLDIFS="$IFS"
		IFS=''
		sflag="$(cat $file | tr '\n' '\f')"
		IFS="$OLDIFS"
	else
		echo "$PROGNAME: $file: No such file"
	fi
fi

${eflag}_encode "$sflag"

