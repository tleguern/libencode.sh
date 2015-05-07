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

LIBNAME="libencode_base32hex.sh"
LIBVERSION="1.0"

base32hex_encode() {
	local _fs=$(awk -v v=28 'BEGIN { printf "%c", v; exit }')
	local _gs=$(awk -v v=29 'BEGIN { printf "%c", v; exit }')
	local _blocks="$(echo "$1" | sed -E "s/.{5}/&$_fs/g")"
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
		IFS="$OLDIFS"
		local _len="$(echo -n $_binblock | wc -c | tr -d ' ')"
		case $_len in
			8) _binblock="$(rightpad $_binblock 32)"; _pad=6;;
			16) _binblock="$(rightpad $_binblock 24)"; _pad=4;;
			24) _binblock="$(rightpad $_binblock 16)"; _pad=3;;
			32) _binblock="$(rightpad $_binblock 8)"; _pad=1;;
		esac
		_instr="$_instr$_binblock"
		IFS="$_fs"
	done
	[ $_resetf -eq 1 ] && set +f

	IFS=" "
	_blocks="$(echo $_instr | sed -E "s/.{5}/&$_fs/g")"
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
		IFS="$_fs"
	done
	IFS="$OLDIFS"
	unset OLDIFS
	case $_pad in
		1) echo $_outstr | sed 's/0$/=/';;
		3) echo $_outstr | sed 's/000$/===/';;
		4) echo $_outstr | sed 's/0000$/====/';;
		6) echo $_outstr | sed 's/000000$/======/';;
		*) echo $_outstr;;
	esac
}

