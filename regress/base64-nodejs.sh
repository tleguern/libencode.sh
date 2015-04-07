#!/bin/sh

set -e

. ../encode.sh
. ../base16.sh
. ../base32.sh
. ../base32hex.sh
. ../base64.sh
. ../base64url.sh

FAILED=0

t() {
	# $1 -> shell function to call
	# $2 -> $test expression
	# $3 -> expected exit code
	# $4 -> expected result

	echo "Run $1 \"$2\", expect $4 and exit code $3"
	tmp="$(mktemp -t encode.sh.XXXXXXXX)"
	set +e
	"$1" "$2" > "$tmp" 2> /dev/null
	ret="$?"
	set -e
	if [ $ret -ne $3 ]; then
		echo "Wrong exit code for $1 \"$2\" ($ret)"
		failed
		rm -f "$tmp"
		return
	fi
	if [ "$(cat $tmp)" != "$4" ]; then
		echo "Wrong result for $1 \"$2\" $(cat $tmp)"
		failed
		rm -f "$tmp"
		return
	fi
	rm -f "$tmp"
	echo OK
}

failed() {
	echo "Failed"
	FAILED=$(expr $FAILED + 1)
}

t base64_encode "quux" 0 "cXV1eA=="
t base64_encode "!\"#$%" 0 "ISIjJCU="
t base64_encode "&'()*+" 0 "JicoKSor"
t base64_encode ",-./012" 0 "LC0uLzAxMg=="
t base64_encode "3456789:" 0 "MzQ1Njc4OTo="
t base64_encode ";<=>?@ABC" 0 "Ozw9Pj9AQUJD"
t base64_encode "DEFGHIJKLM" 0 "REVGR0hJSktMTQ=="
t base64_encode "NOPQRSTUVWX" 0 "Tk9QUVJTVFVWV1g="
t base64_encode "YZ[\\]^_\`abc" 0 "WVpbXF1eX2BhYmM="
t base64_encode "defghijklmnop" 0 "ZGVmZ2hpamtsbW5vcA=="
t base64_encode "qrstuvwxyz{|}~" 0 "cXJzdHV2d3h5ent8fX4="

if [ $FAILED -ne 0 ]; then
	exit 1
fi
exit 0

