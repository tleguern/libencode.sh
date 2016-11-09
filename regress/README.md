Regression tests
================

All the tests emit [TAP](https://testanything.org/) compatible output.

Run the test with [rra/c-tap-harness](https://github.com/rra/c-tap-harness)
like this :

    $ runtests base64-nodejs.t encode.t pathexpan.t rfc4648.t

On additional test, wikipedia.t, doesn't work for now.
