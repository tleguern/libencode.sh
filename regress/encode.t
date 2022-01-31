#!/bin/sh

. ./t.sh
. ../encode.sh

echo "TAP version 13"
echo "# Basic tests for libencode public functions."
echo "1..13"

t "leftpad test 1" leftpad 0 "00000001" "1 7 0"
t "leftpad test 2" leftpad 0 "00000001" "1 7"
t "leftpad test 3" leftpad 0 "22222221" "1 7 2"
t "rightpad test 1" rightpad 0 "10000000" "1 7 0"
t "rightpad test 2" rightpad 0 "10000000" "1 7"
t "rightpad test 3" rightpad 0 "12222222" "1 7 2"
t "ord a" ord 0 "97" "a"
t "ord %" ord 0 "37" "%"
t "chr 97" chr 0 "a" "97"
t "convert a decimal to binary" dectobin 0 "00101010" "42"
t "conert a binary to decimal" bintodec 0 "42" "00101010"
t "convert a decimal to hexadecimal" dectohex 0 "0" "0"
t "convert a decimal to hexadecimal" dectohex 0 "2a" "42"
t "swap a 32 bits number" swap32 0 "00000100000000110000001000000001" "00000001000000100000001100000100"
