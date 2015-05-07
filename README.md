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

Demo
----

A simple script wrapping all of the baseXX.sh files is provided: demo.sh.
It is a Korn Shell script using the autoload feature, so a directory
populated with a file for every functions exported by libencode and a
correct FPATH environnement variable are mandatory :

    $ mkdir -p ~/sh
    $ cd ~/sh
    $ ln -s $LIBENCODEPATH/base16.sh base16_encode
    $ ln -s $LIBENCODEPATH/base16.sh hex_encode
    $ ln -s $LIBENCODEPATH/base32.sh base32_encode
    $ ln -s $LIBENCODEPATH/base32hex.sh base32hex_encode
    $ ln -s $LIBENCODEPATH/base64.sh base64_encode
    $ ln -s $LIBENCODEPATH/base64.sh base64url_encode
    $ grep -E '^[a-z0-9]+\(' $LIBENCODEPATH/encode.sh | while read func; do
    > func="$(echo $func | cut -d'(' -f1)";
    > ln -s $LIBENCODEPATH/encode.sh "$func";
    > done
    $ export FPATH=$FPATH:$HOME/sh

The environnement is now ready, demo.sh is usable :

    $ mksh $LIBENCODEPATH/demo.sh -e base64 -s foobar
    Zm9vYmFy
    $ echo -n foobar | base64
    Zm9vYmFy

It is also possible to use autoload in an interactive korn shell to use
base64_encode directly :

    $ autoload base64_encode
    $ base64_encode foobar
    Zm9vYmFy
