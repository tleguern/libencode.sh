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
# to_value() converts the given ASCII char to a decimal value
#
to_value() {
	set +u
	local _value="$1"
	set -u

	printf "%d" "'$1"
}

#
# to_binary() converts the given decimal $_value to binary
#
to_binary() {
	set +u
	local _value="$1"
	set -u

	local _bc="ibase=10; obase=2; print $_value;"

	local _res=$(echo "$_bc" | bc)
	_res=$(leftpad "$_res" $((8 - $(echo -n $_res | wc -c))))
	echo $_res
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
