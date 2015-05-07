#!/bin/sh

set -e

. ../encode.sh
. ../base16.sh
. ../base32.sh
. ../base32hex.sh
. ../base64.sh

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

t base64_encode "?" 0 "Pw=="
t base64_encode '*' 0 "Kg=="

t base64url_encode "?" 0 "Pw=="
t base64url_encode '*' 0 "Kg=="

t base32_encode "?" 0 "H4======"
t base32_encode '*' 0 "FI======"

t base32hex_encode "?" 0 "7S======"
t base32hex_encode '*' 0 "58======"

t base16_encode "?" 0 "3F"
t base16_encode '*' 0 "2A"

if [ $FAILED -ne 0 ]; then
	exit 1
fi
exit 0

