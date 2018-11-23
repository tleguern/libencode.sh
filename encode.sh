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

LIBNAME="libencode.sh"
LIBVERSION="2.0"

#
# enum is a portable glue for enumerating between two numbers $_first and $_last
#
enum() {
	if command -v jot > /dev/null 2>&1; then
		unset -f enum
		enum() { jot $2 $1 $2 1; }
	elif command -v seq > /dev/null 2>&1; then
		unset -f enum
		enum() { seq $1 1 $(( $2 - 1 )); }
	fi
	enum $1 $2
}

#
# leftpad will add $_num time the char $_pad on the left of the string $_value
#
leftpad() {
	local _value="$1"
	local _num="$2"
	local _pad="${3:-0}"
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
	local _value="$1"
	local _num="$2"
	local _pad="${3:-0}"
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
	local _value="$1"

	printf "%d" "'$_value"
}

#
# chr() converts the given decimal $_value to an ASCII char
#
chr() {
	local _value="$1"

	awk -v v="$_value" 'BEGIN { printf "%c", v; exit }'
}

#
# dectobin() converts the given decimal $_value to binary
#
dectobin() {
	local _value="$1"

	local _bc="ibase=10; obase=2; print $_value;"

	local _res="$(echo "$_bc" | bc)"
	local _len="${#_res}"
	local _des=$(( _len / 8 + (_len % 8 != 0) ))
	local _num=$(( _des * 8 - _len  ))

	_res="$(leftpad $_res $_num)"
	echo "$_res"
}

#
# bintodec() converts the given binary $_value to decimal
#
bintodec() {
	local _value="$1"

	local _bc="obase=10; ibase=2; print $_value;"
	echo "$_bc" | bc
}

#
# dectohex() converts the given decimal $_value to hexadecimal
#
dectohex() {
	local _value="$1"

	local _bc="obase=10; ibase=16; print $_value;"
	echo "$_bc" | bc
}

#
# swap32() reverses the byte ordering of the given 32-bits binary value
#
swap32() {
	local _value="$1"

	_value="$(echo $_value | sed -E "s/[01]{8}/& /g")"
	local _oldifs="$IFS"
	IFS=" "
	set $_value
	echo $4$3$2$1
	IFS="$_oldifs"
}

