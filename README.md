libencode.sh
============

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

libencode.sh targets shells supporting the KSH “local” extension. It is
therefore known to run with the following shells:

- Debian Almquist SHell - dash;
- GNU Bourne-Again SHell - bash;
- MirBSD Korn SHell - mksh;
- OpenBSD Korn SHell - oksh
- Public Domain Korn SHell - pdksh;
