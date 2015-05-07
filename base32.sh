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

LIBNAME="libencode_base32.sh"
LIBVERSION="1.0"

base32_encode() {
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
		IFS="$_fs"
	done
	IFS="$OLDIFS"
	unset OLDIFS
	case $_pad in
		1) echo $_outstr | sed 's/A$/=/';;
		3) echo $_outstr | sed 's/AAA$/===/';;
		4) echo $_outstr | sed 's/AAAA$/====/';;
		6) echo $_outstr | sed 's/AAAAAA$/======/';;
		*) echo $_outstr;;
	esac
}

