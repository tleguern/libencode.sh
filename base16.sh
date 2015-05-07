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

LIBNAME="libencode_base16.sh"
LIBVERSION="1.0"

base16_encode() {
	local _fs=$(awk -v v=28 'BEGIN { printf "%c", v; exit }')
	local _gs=$(awk -v v=29 'BEGIN { printf "%c", v; exit }')
	local _blocks="$(echo "$1" | sed "s/./&$_fs/g")"
	local _block=""
	local _instr=""
	local _outstr=""
	local _pad=0
	local _resetf=0

	# Unset globing if the option is not already activated
	if ! echo $- | grep f > /dev/null 2>&1; then
		set -f
		_resetf=1
	fi

	OLDIFS="$IFS"
	IFS="$_fs"
	for _block in $_blocks; do
		local _byte=""
		local _binblock=""
		local _bytes="$(echo $_block | sed "s/./&$_gs/g")"
		IFS="$_gs"
		for _byte in $_bytes; do
			# ord() doesn't need a clean IFS but dectobin() does,
			# because of its use of enum().
			_byte="$(ord $_byte)"
			IFS="$OLDIFS"
			_byte="$(dectobin $_byte)"
			_binblock="$_binblock$_byte"
			IFS="$_gs"
		done
		_instr="$_instr$_binblock"
		IFS="$_fs"
	done
	[ $_resetf -eq 1 ] && set +f

	IFS=" "
	_blocks="$(echo $_instr | sed -E "s/.{4}/&$_fs/g")"
	IFS="$_fs"
	for _block in $_blocks; do
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
		IFS="$_fs"
	done
	IFS="$OLDIFS"
	unset OLDIFS
	echo $_outstr
}

hex_encode() {
	base16_encode $*
}

