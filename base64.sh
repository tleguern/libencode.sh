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

encode_add_block() {
	local _byte=""

	local _bytes="$(echo "$1" | sed "s/./&$encode_fs/g")"
	OLDIFS="$IFS"
	IFS="$encode_fs"
	for _byte in $_bytes; do
		# ord() doesn't need a clean IFS but dectobin() does,
		# because of its use of enum().
		_byte="$(ord $_byte)"
		IFS="$OLDIFS"
		_byte="$(dectobin $_byte)"
		encode_block="${encode_block}${_byte}"
		IFS="$encode_fs"
	done
	IFS="$OLDIFS"
}

encode_add_blocks() {
	local _block_size="$1"
	local _blocks="$2"
	local _block=""

	OLDIFS="$IFS"
	IFS="$encode_fs"
	for _block in $_blocks; do
		IFS="$OLDIFS"
		if [ ${#_block} -ne $_block_size ]; then
			encode_dirty_block=$_block
		fi
		encode_add_block "$_block"
		encode_blocks="${encode_blocks}${encode_block}"
		IFS="$encode_fs"
		# Reset for next time
		encode_block=""
	done
	IFS="$OLDIFS"
}

encode_finalize() {
	local _block_size="$1"

	if [ $((${#encode_blocks} % _block_size)) -eq 0 ]; then
		encode_dirty_block=""
	fi
	if [ -n "$encode_dirty_block" ]; then
		local _blocklen="${#encode_dirty_block}"
		encode_padded=$((_block_size - _blocklen))
		encode_blocks="$(rightpad $encode_blocks $((8*encode_padded)))"
	fi
}

encode_init() {
	encode_block=""
	encode_blocks=""
	encode_dirty_block=""
	encode_fs=$(awk -v v=28 'BEGIN { printf "%c", v; exit }')
	encode_padded=0
	# Unset globing if the option is not already activated
	if ! echo $- | grep f > /dev/null 2>&1; then
		set -f
		encode_resetf=1
	else
		encode_resetf=0
	fi
}

encode_cleanup() {
	if [ $encode_resetf -eq 1 ]; then
		set +f
	fi
	unset encode_block
	unset encode_blocks
	unset encode_dirty_block
	unset encode_fs
	unset encode_padded
	unset encode_resetf
	unset OLDIFS
}

base64_encode() {
	encode_init
	local _groups=3
	local _bits=6

	local _block=""
	local _blocks="$(echo "$1"|sed -E "s/.{$_groups}/&$encode_fs/g")"
	local _outstr=""

	encode_add_blocks $_groups "$_blocks"
	encode_finalize $_groups

	OLDIFS="$IFS"
	IFS=" "
	encode_blocks=$(echo $encode_blocks|sed -E "s/.{$_bits}/&$encode_fs/g")
	IFS="$encode_fs"
	for _block in $encode_blocks; do
		IFS=" "
		_block="$(bintodec $_block)"
		case $_block in
			0) _block="A";;
			1) _block="B";;
			2) _block="C";;
			3) _block="D";;
			4) _block="E";;
			5) _block="F";;
			6) _block="G";;
			7) _block="H";;
			8) _block="I";;
			9) _block="J";;
			10) _block="K";;
			11) _block="L";;
			12) _block="M";;
			13) _block="N";;
			14) _block="O";;
			15) _block="P";;
			16) _block="Q";;
			17) _block="R";;
			18) _block="S";;
			19) _block="T";;
			20) _block="U";;
			21) _block="V";;
			22) _block="W";;
			23) _block="X";;
			24) _block="Y";;
			25) _block="Z";;
			26) _block="a";;
			27) _block="b";;
			28) _block="c";;
			29) _block="d";;
			30) _block="e";;
			31) _block="f";;
			32) _block="g";;
			33) _block="h";;
			34) _block="i";;
			35) _block="j";;
			36) _block="k";;
			37) _block="l";;
			38) _block="m";;
			39) _block="n";;
			40) _block="o";;
			41) _block="p";;
			42) _block="q";;
			43) _block="r";;
			44) _block="s";;
			45) _block="t";;
			46) _block="u";;
			47) _block="v";;
			48) _block="w";;
			49) _block="x";;
			50) _block="y";;
			51) _block="z";;
			52) _block="0";;
			53) _block="1";;
			54) _block="2";;
			55) _block="3";;
			56) _block="4";;
			57) _block="5";;
			58) _block="6";;
			59) _block="7";;
			60) _block="8";;
			61) _block="9";;
			62) _block="+";;
			63) _block="/";;
		esac
		_outstr="$_outstr$_block"
		IFS="$encode_fs"
	done
	IFS="$OLDIFS"
	case $encode_padded in
		1) echo $_outstr | sed 's/A$/=/';;
		2) echo $_outstr | sed 's/AA$/==/';;
		*) echo $_outstr;;
	esac
	encode_cleanup
}

base64url_encode() {
	base64_encode "$@" | tr '+/' '-_'
}

base32_encode() {
	encode_init
	local _groups=5
	local _bits=5

	local _block=""
	local _blocks="$(echo "$1"|sed -E "s/.{$_groups}/&$encode_fs/g")"
	local _outstr=""

	encode_add_blocks $_groups "$_blocks"
	encode_finalize $_groups

	OLDIFS="$IFS"
	IFS=" "
	encode_blocks=$(echo $encode_blocks|sed -E "s/.{$_bits}/&$encode_fs/g")
	IFS="$encode_fs"
	for _block in $encode_blocks; do
		IFS=" "
		_block="$(bintodec $_block)"
		case $_block in
			0) _block="A";;
			1) _block="B";;
			2) _block="C";;
			3) _block="D";;
			4) _block="E";;
			5) _block="F";;
			6) _block="G";;
			7) _block="H";;
			8) _block="I";;
			9) _block="J";;
			10) _block="K";;
			11) _block="L";;
			12) _block="M";;
			13) _block="N";;
			14) _block="O";;
			15) _block="P";;
			16) _block="Q";;
			17) _block="R";;
			18) _block="S";;
			19) _block="T";;
			20) _block="U";;
			21) _block="V";;
			22) _block="W";;
			23) _block="X";;
			24) _block="Y";;
			25) _block="Z";;
			26) _block="2";;
			27) _block="3";;
			28) _block="4";;
			29) _block="5";;
			30) _block="6";;
			31) _block="7";;
		esac
		_outstr="$_outstr$_block"
		IFS="$encode_fs"
	done
	IFS="$OLDIFS"
	case $encode_padded in
		1) echo $_outstr | sed 's/A$/=/';;
		2) echo $_outstr | sed 's/AAA$/===/';;
		3) echo $_outstr | sed 's/AAAA$/====/';;
		4) echo $_outstr | sed 's/AAAAAA$/======/';;
		*) echo $_outstr;;
	esac
	encode_cleanup
}

base32hex_encode() {
	encode_init
	local _groups=5
	local _bits=5

	local _block=""
	local _blocks="$(echo "$1"|sed -E "s/.{$_groups}/&$encode_fs/g")"
	local _outstr=""

	encode_add_blocks $_groups "$_blocks"
	encode_finalize $_groups

	OLDIFS="$IFS"
	IFS=" "
	encode_blocks=$(echo $encode_blocks|sed -E "s/.{$_bits}/&$encode_fs/g")
	IFS="$encode_fs"
	for _block in $encode_blocks; do
		IFS=" "
		_block="$(bintodec $_block)"
		case $_block in
			0) _block="0";;
			1) _block="1";;
			2) _block="2";;
			3) _block="3";;
			4) _block="4";;
			5) _block="5";;
			6) _block="6";;
			7) _block="7";;
			8) _block="8";;
			9) _block="9";;
			10) _block="A";;
			11) _block="B";;
			12) _block="C";;
			13) _block="D";;
			14) _block="E";;
			15) _block="F";;
			16) _block="G";;
			17) _block="H";;
			18) _block="I";;
			19) _block="J";;
			20) _block="K";;
			21) _block="L";;
			22) _block="M";;
			23) _block="N";;
			24) _block="O";;
			25) _block="P";;
			26) _block="Q";;
			27) _block="R";;
			28) _block="S";;
			29) _block="T";;
			30) _block="U";;
			31) _block="V";;
		esac
		_outstr="$_outstr$_block"
		IFS="$encode_fs"
	done
	IFS="$OLDIFS"
	case $encode_padded in
		1) echo $_outstr | sed 's/0$/=/';;
		2) echo $_outstr | sed 's/000$/===/';;
		3) echo $_outstr | sed 's/0000$/====/';;
		4) echo $_outstr | sed 's/000000$/======/';;
		*) echo $_outstr;;
	esac
	encode_cleanup
}

base16_encode() {
	encode_init
	local _groups=1
	local _bits=4

	local _block=""
	local _blocks="$(echo "$1"|sed -E "s/.{$_groups}/&$encode_fs/g")"
	local _outstr=""

	encode_add_blocks $_groups "$_blocks"
	encode_finalize $_groups

	OLDIFS="$IFS"
	IFS=" "
	encode_blocks=$(echo $encode_blocks|sed -E "s/.{$_bits}/&$encode_fs/g")
	IFS="$encode_fs"
	for _block in $encode_blocks; do
		IFS=" "
		_block="$(bintodec $_block)"
		case $_block in
			0) _block="0";;
			1) _block="1";;
			2) _block="2";;
			3) _block="3";;
			4) _block="4";;
			5) _block="5";;
			6) _block="6";;
			7) _block="7";;
			8) _block="8";;
			9) _block="9";;
			10) _block="A";;
			11) _block="B";;
			12) _block="C";;
			13) _block="D";;
			14) _block="E";;
			15) _block="F";;
		esac
		_outstr="$_outstr$_block"
		IFS="$encode_fs"
	done
	IFS="$OLDIFS"
	echo $_outstr
	encode_cleanup
}

hex_encode() {
	base16_encode $*
}
