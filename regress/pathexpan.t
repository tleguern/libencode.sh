#!/bin/sh

. ./t.sh
. ../encode.sh
. ../base64.sh

echo "TAP version 13"
echo "# Tests that shell path expension is disabled."
echo "1..10"

t "base64 ?" base64_encode 0 "Pw==" '?'
t "base64 *" base64_encode 0 "Kg==" '*'

t "base64url ?" base64url_encode 0 "Pw==" '?'
t "base64url *" base64url_encode 0 "Kg==" '*'

t "base32 ?" base32_encode 0 "H4======" '?'
t "base32 *" base32_encode 0 "FI======" '*'

t "base32hex ?" base32hex_encode 0 "7S======" '?'
t "base32hex *" base32hex_encode 0 "58======" '*'

t "base16 ?" base16_encode 0 "3F" '?'
t "base16 *" base16_encode 0 "2A" '*'

