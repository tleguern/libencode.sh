encode.sh
=========

This repository contains a series of libraries designed to perform 
binary to text encoding in shell script.

encode.sh is a general purpose library exposing various functionalities 
like conversion from decimal to binary or string padding. It is used by 
the other libraries.

base64.sh implements the Base64 encoding algorithm.

base64url.sh implements the Base64 URL encoding algorithm.

base32.sh implements the Base32 encoding algorithm.

base32hex.sh implements the Base32 "Extended hex" encoding algorithm.

base16.sh implements the Base16/Hex encoding algorithm.

Compatibility
-------------

encode.sh scripts are known to run with the following shells:

- Public Domain Korn SHell - pdksh;
- OpenBSD Korn SHell - oksh
- MirBSD Korn SHell - mksh;
- GNU Bourne-Again SHell - bash;

