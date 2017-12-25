chezgo: embed chez scheme in Go
======

# use

~~~
$ make run # will build then give you a chez repl, running within golang.
...
> (+ 10 12)
22
> 
~~~

# rationale

Chez Scheme is fast, mature, incremental, optimizing native code compiler that produces very fast code very quickly. There is also its slower companion, Petite Scheme, a bytecode compiler within the same system, available for those who need extreme portability. Prior to 2016 it was only available for a commercial license fee, but it is now open source.

Chez's optimizing compiler works both incrementally (but still does some cross package optimization), as well as providing calls for whole-program compilation and optimization.

Chez is used in Robotic drug testing, Chip layout and design, multithreaded web services, and enterprise systems. Some users include Sandia National Labs, Motorola, Freescale, Beckman Coulter, Disney, University of Indiana (where Dybvig is a professor of Computer Science, specializing in programming languages and compiler design). It has been in development since 1985 (started on a VAX running BSD Unix), and saw six major commercial releases prior to going open source.

Chez has a generational garbage collector that automatically collects code and data that is no longer in use. Chez includes a debugger, and a full numeric tower.

Other schemes, like Racket, plan to move to Chez underneath, now that it is freely available. https://groups.google.com/forum/#!msg/racket-dev/2BV3ElyfF8Y/4RSd3XbECAAJ

# background

architecture talk slides

http://icfp06.cs.uchicago.edu/dybvig-talk.pdf

history of Chez Scheme

https://www.cs.indiana.edu/~dyb/pubs/hocs.pdf

# benchmarks

versus other schemes: https://ecraven.github.io/r7rs-benchmarks/

# discussion

https://news.ycombinator.com/item?id=13656943

# FFI documentation

https://www.scheme.com/csug8/binding.html

# documentation

homepage of Chez Scheme

https://www.scheme.com/

user's guide

https://www.scheme.com/csug8/


R. Kent Dybvig's classic book, The Scheme Programming Language, 4th edition.

https://www.scheme.com/tspl4/

The open source github repo. Chez is Apache2 licensed.

https://github.com/cisco/ChezScheme


notes
-----

To facilitate this experiment, only the OSX makefiles were used. However
the Chez Scheme system is portable to linux and Windows; much effort
appears to have been put into windows compatability in particular.


License: Apache 2, per the underlying Chez scheme license.
