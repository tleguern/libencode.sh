# Public domain - Tristan Le Guern <tleguern@bouledef.eu>

testcount=0

t() {
	descr="$1"	# short description for the test
	func="$2"	# shell function to call
	ex="$3"		# expected exit code
	res="$4"	# expected result
	arg="$5"	# $test expression

	testcount=$((testcount + 1))
	diag=

	if [ -n "$descr" ]; then
		descr=" - $descr"
	fi

	tmp="$(mktemp -t t.XXXXXXXX)"
	set -f
	"$func" $arg > $tmp 2> /dev/null
	ret="$?"
	set +f
	if [ $ret -ne $ex ]; then
		diag="not ok"
	fi
	if [ "$(cat $tmp)" != "$res" ]; then
		diag="not ok"
	fi
	rm -f "$tmp"
	printf "%s %d%s\n" "${diag:-"ok"}" $testcount "$descr"
}

