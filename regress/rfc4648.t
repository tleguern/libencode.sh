#!/bin/sh

. ./t.sh
. ../encode.sh
. ../base64.sh

echo "TAP version 13"
echo "# foobar based tests for every public functions un base64.sh"
echo "1..35"

t "base64 1" base64_encode 0 "" ""
t "base64 2" base64_encode 0 "Zg==" "f"
t "base64 3" base64_encode 0 "Zm8=" "fo"
t "base64 4" base64_encode 0 "Zm9v" "foo" 
t "base64 5" base64_encode 0 "Zm9vYg==" "foob"
t "base64 6" base64_encode 0 "Zm9vYmE=" "fooba"
t "base64 7" base64_encode 0 "Zm9vYmFy" "foobar"
t "base64url 1" base64url_encode 0 "" ""
t "base64url 2" base64url_encode 0 "Zg==" "f"
t "base64url 3" base64url_encode 0 "Zm8=" "fo"
t "base64url 4" base64url_encode 0 "Zm9v" "foo"
t "base64url 5" base64url_encode 0 "Zm9vYg==" "foob"
t "base64url 6" base64url_encode 0 "Zm9vYmE=" "fooba"
t "base64url 7" base64url_encode 0 "Zm9vYmFy" "foobar"
t "base32 1" base32_encode 0 "" ""
t "base32 2" base32_encode 0 "MY======" "f"
t "base32 3" base32_encode 0 "MZXQ====" "fo"
t "base32 4" base32_encode 0 "MZXW6===" "foo"
t "base32 5" base32_encode 0 "MZXW6YQ=" "foob"
t "base32 6" base32_encode 0 "MZXW6YTB" "fooba"
t "base32 7" base32_encode 0 "MZXW6YTBOI======" "foobar"
t "base32hex 1" base32hex_encode 0 "" ""
t "base32hex 2" base32hex_encode 0 "CO======" "f"
t "base32hex 3" base32hex_encode 0 "CPNG====" "fo"
t "base32hex 4" base32hex_encode 0 "CPNMU===" "foo"
t "base32hex 5" base32hex_encode 0 "CPNMUOG=" "foob"
t "base32hex 6" base32hex_encode 0 "CPNMUOJ1" "fooba"
t "base32hex 7" base32hex_encode 0 "CPNMUOJ1E8======" "foobar"
t "base16 1" base16_encode 0 "" ""
t "base16 2" base16_encode 0 "66" "f"
t "base16 3" base16_encode 0 "666F" "fo"
t "base16 4" base16_encode 0 "666F6F" "foo"
t "base16 5" base16_encode 0 "666F6F62" "foob"
t "base16 6" base16_encode 0 "666F6F6261" "fooba"
t "base16 7" base16_encode 0 "666F6F626172" "foobar"

test_done
