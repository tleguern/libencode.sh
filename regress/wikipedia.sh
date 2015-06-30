#!/bin/sh

set -e

. ../encode.sh
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

t base64_encode "any carnal pleasure." 0 "YW55IGNhcm5hbCBwbGVhc3VyZS4="
t base64_encode "any carnal pleasure" 0 "YW55IGNhcm5hbCBwbGVhc3VyZQ=="
t base64_encode "any carnal pleasur" 0 "YW55IGNhcm5hbCBwbGVhc3Vy"
t base64_encode "any carnal pleasu" 0 "YW55IGNhcm5hbCBwbGVhc3U="
t base64_encode "any carnal pleas" 0 "YW55IGNhcm5hbCBwbGVhcw=="

t base64url_encode "any carnal pleasure." 0 "YW55IGNhcm5hbCBwbGVhc3VyZS4="
t base64url_encode "any carnal pleasure" 0 "YW55IGNhcm5hbCBwbGVhc3VyZQ=="
t base64url_encode "any carnal pleasur" 0 "YW55IGNhcm5hbCBwbGVhc3Vy"
t base64url_encode "any carnal pleasu" 0 "YW55IGNhcm5hbCBwbGVhc3U="
t base64url_encode "any carnal pleas" 0 "YW55IGNhcm5hbCBwbGVhcw=="

t base32_encode "any carnal pleasure." 0 "MFXHSIDDMFZG4YLMEBYGYZLBON2XEZJO"
t base32_encode "any carnal pleasure" 0 "MFXHSIDDMFZG4YLMEBYGYZLBON2XEZI="
t base32_encode "any carnal pleasur" 0 "MFXHSIDDMFZG4YLMEBYGYZLBON2XE==="
t base32_encode "any carnal pleasu" 0 "MFXHSIDDMFZG4YLMEBYGYZLBON2Q===="
t base32_encode "any carnal pleas" 0 "MFXHSIDDMFZG4YLMEBYGYZLBOM======"

t base32hex_encode "any carnal pleasure." 0 "C5N7I833C5P6SOBC41O6OPB1EDQN4P9E"
t base32hex_encode "any carnal pleasure" 0 "C5N7I833C5P6SOBC41O6OPB1EDQN4P8="
t base32hex_encode "any carnal pleasur" 0 "C5N7I833C5P6SOBC41O6OPB1EDQN4==="
t base32hex_encode "any carnal pleasu" 0 "C5N7I833C5P6SOBC41O6OPB1EDQG===="
t base32hex_encode "any carnal pleas" 0 "C5N7I833C5P6SOBC41O6OPB1EC======"

t base16_encode "any carnal pleasure." 0 "616E79206361726E616C20706C6561737572652E"
t base16_encode "any carnal pleasure" 0 "616E79206361726E616C20706C656173757265"
t base16_encode "any carnal pleasur" 0 "616E79206361726E616C20706C6561737572"
t base16_encode "any carnal pleasu" 0 "616E79206361726E616C20706C65617375"
t base16_encode "any carnal pleas" 0 "616E79206361726E616C20706C656173"

if [ $FAILED -ne 0 ]; then
	exit 1
fi
exit 0

