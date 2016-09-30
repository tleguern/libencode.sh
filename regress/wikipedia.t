#!/bin/sh

. ./t.sh
. ../encode.sh
. ../base64.sh

echo "TAP version 13"
echo "# tests taken from the wikipedia article on base64."
echo "1..25"

t "base64 1" base64_encode 0 "any carnal pleasure." "YW55IGNhcm5hbCBwbGVhc3VyZS4="
t "base64 2" base64_encode 0 "any carnal pleasure" "YW55IGNhcm5hbCBwbGVhc3VyZQ=="
t "base64 3" base64_encode 0 "any carnal pleasur" "YW55IGNhcm5hbCBwbGVhc3Vy"
t "base64 4" base64_encode 0 "any carnal pleasu" "YW55IGNhcm5hbCBwbGVhc3U="
t "base64 5" base64_encode 0 "any carnal pleas" "YW55IGNhcm5hbCBwbGVhcw=="
t "base64url 1" base64url_encode 0 "any carnal pleasure." "YW55IGNhcm5hbCBwbGVhc3VyZS4="
t "base64url 2" base64url_encode 0 "any carnal pleasure" "YW55IGNhcm5hbCBwbGVhc3VyZQ=="
t "base64url 3" base64url_encode 0 "any carnal pleasur" "YW55IGNhcm5hbCBwbGVhc3Vy"
t "base64url 4" base64url_encode 0 "any carnal pleasu" "YW55IGNhcm5hbCBwbGVhc3U="
t "base64url 5" base64url_encode 0 "any carnal pleas" "YW55IGNhcm5hbCBwbGVhcw=="
t "base32 1" base32_encode 0 "any carnal pleasure." "MFXHSIDDMFZG4YLMEBYGYZLBON2XEZJO"
t "base32 2" base32_encode 0 "any carnal pleasure" "MFXHSIDDMFZG4YLMEBYGYZLBON2XEZI="
t "base32 3" base32_encode 0 "any carnal pleasur" "MFXHSIDDMFZG4YLMEBYGYZLBON2XE==="
t "base32 4" base32_encode 0 "any carnal pleasu" "MFXHSIDDMFZG4YLMEBYGYZLBON2Q===="
t "base32 5" base32_encode 0 "any carnal pleas" "MFXHSIDDMFZG4YLMEBYGYZLBOM======"
t "base32hex 1" base32hex_encode 0 "any carnal pleasure." "C5N7I833C5P6SOBC41O6OPB1EDQN4P9E"
t "base32hex 2" base32hex_encode 0 "any carnal pleasure" "C5N7I833C5P6SOBC41O6OPB1EDQN4P8="
t "base32hex 3" base32hex_encode 0 "any carnal pleasur" "C5N7I833C5P6SOBC41O6OPB1EDQN4==="
t "base32hex 4" base32hex_encode 0 "any carnal pleasu" "C5N7I833C5P6SOBC41O6OPB1EDQG===="
t "base32hex 5" base32hex_encode 0 "any carnal pleas" "C5N7I833C5P6SOBC41O6OPB1EC======"
t "base16 1" base16_encode 0 "any carnal pleasure." "616E79206361726E616C20706C6561737572652E"
t "base16 2" base16_encode 0 "any carnal pleasure" "616E79206361726E616C20706C656173757265"
t "base16 3" base16_encode 0 "any carnal pleasur" "616E79206361726E616C20706C6561737572"
t "base16 4" base16_encode 0 "any carnal pleasu" "616E79206361726E616C20706C65617375"
t "base16 5" base16_encode 0 "any carnal pleas" "616E79206361726E616C20706C656173"

