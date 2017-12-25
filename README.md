chezgo: embed chez scheme in Go
======

#rationale

Chez is fast, mature, and produces fast native machine code. There is also Petite Scheme, a bytecode compiler within the same system, available. Prior to 2016 it was only available for a commercial license fee, but it is now open source.

Other schemes, like Racket, plan to move to it. https://groups.google.com/forum/#!msg/racket-dev/2BV3ElyfF8Y/4RSd3XbECAAJ

#benchmarks

https://ecraven.github.io/r7rs-benchmarks/

#discussion

https://news.ycombinator.com/item?id=13656943

#FFI documentation

https://www.scheme.com/csug8/binding.html

notes
-----

To facilitate this experiment, only the OSX makefiles were used. However
the Chez Scheme system is portable to linux and Windows; much effort
appears to have been put into windows compatability in particular.

homepage of Chez Scheme
https://www.scheme.com/

R. Kent Dybvig's classic book, The Scheme Programming Language, 4th edition.
https://www.scheme.com/tspl4/

The open source github repo. Chez is Apache2 licensed.
https://github.com/cisco/ChezScheme

License: Apache 2.
