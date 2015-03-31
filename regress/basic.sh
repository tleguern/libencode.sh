#!/bin/sh

set -e

. ../encode.sh

FAILED=0

t() {
	# $1 -> shell function to call
	# $2 -> expected exit code
	# $3 -> expected result
	# $4 -> $test expression

	func="$1"
	ex="$2"
	res="$3"
	arg="$4"

	echo "Run \"$func $arg\", expect result \"$res\" and exit code $ex"
	tmp="$(mktemp -t encode.sh.XXXXXXXX)"
	set +e
	$func $arg > $tmp 2> /dev/null
	ret="$?"
	set -e
	if [ $ret -ne $ex ]; then
		echo "Wrong exit code for $func \"$arg\" ($ret)"
		failed
		rm -f "$tmp"
		return
	fi
	if [ "$(cat $tmp)" != "$res" ]; then
		echo "Wrong result for $func \"$arg\" $(cat $tmp)"
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

t leftpad 0 "00000001" "1 7 0"
t leftpad 0 "00000001" "1 7"
t leftpad 0 "22222221" "1 7 2"
t rightpad 0 "10000000" "1 7 0"
t rightpad 0 "10000000" "1 7"
t rightpad 0 "12222222" "1 7 2"
t ord 0 "97" "a"
t chr 0 "a" "97"
t dectobin 0 "00101010" "42"
t bintodec 0 "42" "00101010"
t dectohex 0 "66" "42"
t swap32 0 "00000100000000110000001000000001" "00000001000000100000001100000100"

if [ $FAILED -ne 0 ]; then
	exit 1
fi
exit 0

