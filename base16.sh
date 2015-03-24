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

readonly BASE16VERSION='v1.0'
 
. ./encode.sh

base16_encode() {
	set +u
	local _blocks="$(printf "$1" | sed 's/./& /g')"
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
		_instr="$_instr$_binblock"
	done

	_blocks="$(echo $_instr | sed 's/..../& /g')"
	for _block in $_blocks; do
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
	done
	echo $_outstr
}

hex_encode() {
	base16_encode $*
}

