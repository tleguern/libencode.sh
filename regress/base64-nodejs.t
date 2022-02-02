#!/bin/sh

. ./t.sh
. ../encode.sh
. ../base64.sh

echo "TAP version 13"
echo "# Tests taken from the node.js base64 package."
echo "1..11"

t "test 1" base64_encode 0 "cXV1eA==" "quux"
t "test 2" base64_encode 0 "ISIjJCU=" "!\"#$%"
t "test 3" base64_encode 0 "JicoKSor" "&'()*+"
t "test 4" base64_encode 0 "LC0uLzAxMg==" ",-./012"
t "test 5" base64_encode 0 "MzQ1Njc4OTo=" "3456789:"
t "test 6" base64_encode 0 "Ozw9Pj9AQUJD" ";<=>?@ABC"
t "test 7" base64_encode 0 "REVGR0hJSktMTQ==" "DEFGHIJKLM"
t "test 8" base64_encode 0 "Tk9QUVJTVFVWV1g=" "NOPQRSTUVWX"
t "test 9" base64_encode 0 "WVpbXF1eX2BhYmM=" "YZ[\\]^_\`abc"
t "test 10" base64_encode 0 "ZGVmZ2hpamtsbW5vcA==" "defghijklmnop"
t "test 11" base64_encode 0 "cXJzdHV2d3h5ent8fX4=" "qrstuvwxyz{|}~"

test_done
