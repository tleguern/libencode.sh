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

t base64_encode "" 0 ""
t base64_encode "f" 0 "Zg=="
t base64_encode "fo" 0 "Zm8="
t base64_encode "foo" 0 "Zm9v"
t base64_encode "foob" 0 "Zm9vYg=="
t base64_encode "fooba" 0 "Zm9vYmE="
t base64_encode "foobar" 0 "Zm9vYmFy"

t base64url_encode "" 0 ""
t base64url_encode "f" 0 "Zg=="
t base64url_encode "fo" 0 "Zm8="
t base64url_encode "foo" 0 "Zm9v"
t base64url_encode "foob" 0 "Zm9vYg=="
t base64url_encode "fooba" 0 "Zm9vYmE="
t base64url_encode "foobar" 0 "Zm9vYmFy"

t base32_encode "" 0 ""
t base32_encode "f" 0 "MY======"
t base32_encode "fo" 0 "MZXQ===="
t base32_encode "foo" 0 "MZXW6==="
t base32_encode "foob" 0 "MZXW6YQ="
t base32_encode "fooba" 0 "MZXW6YTB"
t base32_encode "foobar" 0 "MZXW6YTBOI======"

t base32hex_encode "" 0 ""
t base32hex_encode "f" 0 "CO======"
t base32hex_encode "fo" 0 "CPNG===="
t base32hex_encode "foo" 0 "CPNMU==="
t base32hex_encode "foob" 0 "CPNMUOG="
t base32hex_encode "fooba" 0 "CPNMUOJ1"
t base32hex_encode "foobar" 0 "CPNMUOJ1E8======"

t base16_encode "" 0 ""
t base16_encode "f" 0 "66"
t base16_encode "fo" 0 "666F"
t base16_encode "foo" 0 "666F6F"
t base16_encode "foob" 0 "666F6F62"
t base16_encode "fooba" 0 "666F6F6261"
t base16_encode "foobar" 0 "666F6F626172"

if [ $FAILED -ne 0 ]; then
	exit 1
fi
exit 0

