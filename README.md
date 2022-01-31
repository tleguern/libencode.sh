# libencode.sh

Base64 family of binary-to-text encoding algorithms implemented in shell.

## Contents

1. [Libraries](#libraries)
2. [Compatibility](#compatibility)
3. [Requirements](#requirements)
4. [Demo](#demo)
5. [License](#license)

## Libraries

* `encode.sh` is a general purpose library exposing various functionalities like conversion from decimal to binary or string padding. It exports the following functions:
  * `enum`
  * `leftpad`
  * `rightpad`
  * `ord`
  * `chr`
  * `dectobin`
  * `bintodec`
  * `dectohex`
  * `swap32`
* `base64.sh` implements the Base64, Base64 URL, Base32, Base32 Hex and Base16 encoding algorithms. The following functions are considered public:
  * `base64_encode`
  * `base64url_encode`
  * `base32_encode`
  * `base32hex_encode`
  * `base16_encode`
  * `hex_encode`

## Compatibility

libencode.sh targets shells supporting the KSH “local” extension.
It is therefore known to run with the following shells:

* Debian Almquist SHell - dash ;
* GNU Bourne-Again SHell - bash ;
* MirBSD Korn SHell - mksh ;
* OpenBSD Korn SHell - oksh.

## Requirements

The following utilities are needed by libencode:

* printf (built-in shell version is fine) ;
* bc ;
* cut ;
* grep ;
* jot or seq ;
* sed.

## Demo

A simple script wrapping all of the binary-to-text functions is provided: demo.sh.
It is a Korn Shell script using the autoload feature, so a directory populated with a file for every functions exported by libencode and a correct FPATH environnement variable are mandatory :

    $ mkdir -p ~/sh
    $ cd ~/sh
    $ ln -s $LIBENCODEPATH/base64.sh base16_encode
    $ ln -s $LIBENCODEPATH/base64.sh hex_encode
    $ ln -s $LIBENCODEPATH/base64.sh base32_encode
    $ ln -s $LIBENCODEPATH/base64.sh base32hex_encode
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

It is also possible to use autoload in an interactive korn shell to use base64_encode directly :

    $ autoload base64_encode
    $ base64_encode foobar
    Zm9vYmFy

Of course all of these awkward steps can be bypassed if you just this project as intended: as a library.

## License

All the code is licensed under the ISC License.
It's free, not GPLed !
