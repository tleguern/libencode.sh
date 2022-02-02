#!/bin/sh

. ./t.sh
. ../encode.sh
. ../base64.sh

echo "TAP version 13"
echo "# tests taken from the wikipedia article on base64."
echo "1..25"

t "base64 1" base64_encode 0 "YW55IGNhcm5hbCBwbGVhc3VyZS4=" "any carnal pleasure."
#t "base64 2" base64_encode 0 "YW55IGNhcm5hbCBwbGVhc3VyZQ==" "any carnal pleasure"
#t "base64 3" base64_encode 0 "YW55IGNhcm5hbCBwbGVhc3Vy" "any carnal pleasur"
#t "base64 4" base64_encode 0 "YW55IGNhcm5hbCBwbGVhc3U=" "any carnal pleasu"
#t "base64 5" base64_encode 0 "YW55IGNhcm5hbCBwbGVhcw==" "any carnal pleas"
#t "base64url 1" base64url_encode 0 "YW55IGNhcm5hbCBwbGVhc3VyZS4=" "any carnal pleasure."
#t "base64url 2" base64url_encode 0 "YW55IGNhcm5hbCBwbGVhc3VyZQ==" "any carnal pleasure"
#t "base64url 3" base64url_encode 0 "YW55IGNhcm5hbCBwbGVhc3Vy" "any carnal pleasur"
#t "base64url 4" base64url_encode 0 "YW55IGNhcm5hbCBwbGVhc3U=" "any carnal pleasu"
#t "base64url 5" base64url_encode 0 "YW55IGNhcm5hbCBwbGVhcw==" "any carnal pleas"
#t "base32 1" base32_encode 0 "MFXHSIDDMFZG4YLMEBYGYZLBON2XEZJO" "any carnal pleasure."
#t "base32 2" base32_encode 0 "MFXHSIDDMFZG4YLMEBYGYZLBON2XEZI=" "any carnal pleasure"
#t "base32 3" base32_encode 0 "MFXHSIDDMFZG4YLMEBYGYZLBON2XE===" "any carnal pleasur"
#t "base32 4" base32_encode 0 "MFXHSIDDMFZG4YLMEBYGYZLBON2Q====" "any carnal pleasu"
#t "base32 5" base32_encode 0 "MFXHSIDDMFZG4YLMEBYGYZLBOM======" "any carnal pleas"
#t "base32hex 1" base32hex_encode 0 "C5N7I833C5P6SOBC41O6OPB1EDQN4P9E" "any carnal pleasure."
#t "base32hex 2" base32hex_encode 0 "C5N7I833C5P6SOBC41O6OPB1EDQN4P8=" "any carnal pleasure"
#t "base32hex 3" base32hex_encode 0 "C5N7I833C5P6SOBC41O6OPB1EDQN4===" "any carnal pleasur"
#t "base32hex 4" base32hex_encode 0 "C5N7I833C5P6SOBC41O6OPB1EDQG====" "any carnal pleasu"
#t "base32hex 5" base32hex_encode 0 "C5N7I833C5P6SOBC41O6OPB1EC======" "any carnal pleas"
#t "base16 1" base16_encode 0 "616E79206361726E616C20706C6561737572652E" "any carnal pleasure."
#t "base16 2" base16_encode 0 "616E79206361726E616C20706C656173757265" "any carnal pleasure"
#t "base16 3" base16_encode 0 "616E79206361726E616C20706C6561737572" "any carnal pleasur"
#t "base16 4" base16_encode 0 "616E79206361726E616C20706C65617375" "any carnal pleasu"
#t "base16 5" base16_encode 0 "616E79206361726E616C20706C656173" "any carnal pleas"

test_done
