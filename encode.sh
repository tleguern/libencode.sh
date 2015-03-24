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

fs=$(awk -v v=28 'BEGIN { printf "%c", v; exit }')
gs=$(awk -v v=29 'BEGIN { printf "%c", v; exit }')
rs=$(awk -v v=30 'BEGIN { printf "%c", v; exit }')

#
# enum is a portable glue for enumerating between two numbers $_first and $_last
#
enum() {
	set +u
	_first="$1"
	_last="$2"
	set -u

	if which jot > /dev/null 2>&1; then
		jot $_last $_first $_last 1
	else
		seq $_first 1 $(( $_last - 1 ))
	fi
}

#
# leftpad will add $_num time the char $_pad on the left of the string $_value
#
leftpad() {
	set +u
	local _value="$1"
	local _num="$2"
	local _pad="${3:-0}"
	set -u
	local _i=0
	local _res="$_value"

	if [ $_num -eq 0 ]; then
		echo "$_res"
		return 0
	fi

	for _i in $(enum 0 $_num); do
		_res="${_pad}${_res}"
	done

	echo "$_res"
}

#
# rightpad will add $_num time the char $_pad on the right of the string $_value
#
rightpad() {
	set +u
	local _value="$1"
	local _num="$2"
	local _pad="${3:-0}"
	set -u
	local _i=0
	local _res="$_value"

	for _i in $(enum 0 $_num); do
		_res="${_res}${_pad}"
	done

	echo "$_res"
}

#
# ord() converts the given ASCII char to a decimal value
#
ord() {
	set +u
	local _value="$1"
	set -u

	printf "%d" "'$1"
}

#
# chr() converts the given decimal $_value to an ASCII char
#
chr() {
	set +u
	local _value="$1"
	set -u

	awk -v v="$_value" 'BEGIN { printf "%c", v; exit }'
}

#
# to_binary() converts the given decimal $_value to binary
#
to_binary() {
	set +u
	local _value="$1"
	set -u

	local _bc="ibase=10; obase=2; print $_value;"

	local _res="$(echo "$_bc" | bc)"
	local _len="$(echo -n $_res | wc -c)"
	local _des=$(( $_len / 8 + ($_len % 8 != 0) ))
	local _num=$(( $_des * 8 - $_len  ))

	_res="$(leftpad $_res $_num)"
	echo "$_res"
}

#
# to_decimal() converts the given binary $_value to decimal
#
to_decimal() {
	set +u
	local _value="$1"
	set -u

	local _bc="obase=10; ibase=2; print $_value;"
	echo "$_bc" | bc
}

#
# to_hexadecimal() converts the given decimal $_value to hexadecimal
#
to_hexadecimal() {
	set +u
	local _value="$1"
	set -u

	local _bc="obase=10; ibase=16; print $_value;"
	echo "$_bc" | bc
}

#
# swap32() reverses the byte ordering of the given 32-bits binary value
#
swap32() {
	set +u
	local _value="$1"
	set -u

	_value="$(echo $_value | sed -E "s/[01]{8}/& /g")"
	echo "$(echo $_value|cut -d' ' -f4)$(echo $_value|cut -d' ' -f3)$(echo $_value|cut -d' ' -f2)$(echo $_value|cut -d' ' -f1)"
}

