#!/bin/sh
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

set -e

readonly BASE64VERSION='v1.0'

. ./encode.sh

base64_encode() {
	set +u
	local _blocks="$(printf "$1" | sed 's/.../& /g')"
	set -u
	local _block=""
	local _instr=""
	local _outstr=""
	local _pad=0

	for _block in $_blocks; do
		local _byte=""
		local _binblock=""
		for _byte in $(echo $_block | sed 's/./& /g'); do
			_decbyte="$(ord $_byte)"
			# Converts back \f to \n
			if [ $_decbyte -eq 12 ]; then
				_byte="00001010"
			else
				_byte="$(dectobin $_decbyte)"
			fi
			_binblock="$_binblock$_byte"
		done
		local _len="$(echo -n $_binblock | wc -c | tr -d ' ')"
		case $_len in
			8) _binblock="$(rightpad $_binblock 16)"; _pad=2;;
			16) _binblock="$(rightpad $_binblock 8)"; _pad=1;;
		esac
		_instr="$_instr$_binblock"
	done

	_blocks="$(echo $_instr | sed 's/....../& /g')"
	for _block in $_blocks; do
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
			22) _block="Z";;
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
	done
	case $_pad in
		1) echo $_outstr | sed 's/A$/=/';;
		2) echo $_outstr | sed 's/AA$/==/';;
		*) echo $_outstr;;
	esac
}

