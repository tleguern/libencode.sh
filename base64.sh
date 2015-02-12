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

readonly BASE64PROGNAME="$(basename $0)"
readonly BASE64VERSION='v1.0'
 
usage() {
	echo "usage: $BASE64PROGNAME [-s string | file]"
}
 
. encode.sh

b64_encode() {
	set +u
	local _value="$(printf "$1" | sed 's/.../& /g')"
	set -u
	local _c=""
	local _binstr=""
	local _b64str=""
	local _pad=0

	for _c in $_value; do
		local _v=""
		for _b in $(echo $_c | sed 's/./& /g'); do
			_bval="$(to_value $_b)"
			# Converts back \f to \n
			if [ $_bval -eq 12 ]; then
				_b="00001010"
			else
				_b="$(to_binary $_bval)"
			fi
			_v="$_v$_b"
		done
		if [ $(echo -n $_v | wc -c) -eq 8 ]; then
			_v="$(rightpad $_v 16)"
			_pad=2
		elif [ $(echo -n $_v | wc -c) -eq 16 ]; then
			_v="$(rightpad $_v 8)"
			_pad=1
		fi
		_binstr="$_binstr$_v"
	done

	for _c in $(echo $_binstr | sed 's/....../& /g'); do
		_c="$(to_decimal $_c)"
		case $_c in
			0) _c="A";;
			1) _c="B";;
			2) _c="C";;
			3) _c="D";;
			4) _c="E";;
			5) _c="F";;
			6) _c="G";;
			7) _c="H";;
			8) _c="I";;
			9) _c="J";;
			10) _c="K";;
			11) _c="L";;
			12) _c="M";;
			13) _c="N";;
			14) _c="O";;
			15) _c="P";;
			16) _c="Q";;
			17) _c="R";;
			18) _c="S";;
			19) _c="T";;
			20) _c="U";;
			21) _c="V";;
			22) _c="Z";;
			23) _c="X";;
			24) _c="Y";;
			25) _c="Z";;
			26) _c="a";;
			27) _c="b";;
			28) _c="c";;
			29) _c="d";;
			30) _c="e";;
			31) _c="f";;
			32) _c="g";;
			33) _c="h";;
			34) _c="i";;
			35) _c="j";;
			36) _c="k";;
			37) _c="l";;
			38) _c="m";;
			39) _c="n";;
			40) _c="o";;
			41) _c="p";;
			42) _c="q";;
			43) _c="r";;
			44) _c="s";;
			45) _c="t";;
			46) _c="u";;
			47) _c="v";;
			48) _c="w";;
			49) _c="x";;
			50) _c="y";;
			51) _c="z";;
			52) _c="0";;
			53) _c="1";;
			54) _c="2";;
			55) _c="3";;
			56) _c="4";;
			57) _c="5";;
			58) _c="6";;
			59) _c="7";;
			60) _c="8";;
			61) _c="9";;
			62) _c="+";;
			63) _c="/";;
		esac
		_b64str="$_b64str$_c"
	done

	if [ $_pad -eq 1 ]; then
		echo $_b64str | sed 's/A$/=/'
	elif [ $_pad -eq 2 ]; then
		echo $_b64str | sed 's/AA$/==/'
	else
		echo $_b64str
	fi
}

if [ "${BASE64PROGNAME%.sh}" = "base64" ]; then
	file=""
	sflag=""

	while getopts ":s:" opt;do
		case $opt in
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
			# stripping then
			#
			OLDIFS="$IFS"
			IFS=''
			sflag="$(cat $file | tr '\n' '\f')"
			IFS="$OLDIFS"
		else
			echo "$BASE64PROGNAME: $file: No such file"
		fi
	fi

	b64_encode "$sflag"
fi

