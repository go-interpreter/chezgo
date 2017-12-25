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

Chez is used in Robotic drug testing, Chip layout and design, multithreaded web services, and enterprise systems. Some users include Sandia National Labs, Motorola, Freescale, Beckman Coulter, Disney, University of Indiana (where Dybvig is a professor of Computer Science, specializing in programming languages and compiler design). It has been in development since 1985 (started on a VAX running BSD Unix), and saw nine major commercial releases prior to going open source (currently it is at version 9.5.1, released 2017 Oct 11; it is still being updated today; github history is here https://github.com/cisco/ChezScheme/releases). Reviewing Dybvig's history paper (below) shows numerous surprising insights into producing code incrementally and online. Open source Chez development is ongoing and active today, and the last merged pull request at the time of this writing was 10 hours ago.

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

# initial, simple matrix mulitply benchmark

Chez matrix multiplication, in matrix.ss

~~~
500 x 500 matrix multiply in Chez took 4373 msec
500 x 500 matrix multiply in Chez took 4311 msec
500 x 500 matrix multiply in Chez took 4240 msec
500 x 500 matrix multiply in Chez took 4259 msec
500 x 500 matrix multiply in Chez took 4220 msec
500 x 500 matrix multiply in Chez took 4146 msec
500 x 500 matrix multiply in Chez took 4268 msec
500 x 500 matrix multiply in Chez took 4216 msec
500 x 500 matrix multiply in Chez took 4205 msec
500 x 500 matrix multiply in Chez took 4206 msec
500 x 500 matrix multiply in Chez took 4182 msec

~~~


Go matrix multiplication, in cmd/matmul subdir
~~~
go run matmul.go
500 x 500 matrix multiply in Go took 437 msec
500 x 500 matrix multiply in Go took 428 msec
500 x 500 matrix multiply in Go took 454 msec
500 x 500 matrix multiply in Go took 428 msec
500 x 500 matrix multiply in Go took 436 msec
500 x 500 matrix multiply in Go took 451 msec
500 x 500 matrix multiply in Go took 435 msec
500 x 500 matrix multiply in Go took 435 msec
500 x 500 matrix multiply in Go took 438 msec
500 x 500 matrix multiply in Go took 435 msec
~~~


turning on full optimization on Chez only
helped a little
~~~
$ scheme  --optimize-level 3 matrix.ss
Chez Scheme Version 9.5.1
Copyright 1984-2017 Cisco Systems, Inc.

500 x 500 matrix multiply in Chez took 3798 msec
500 x 500 matrix multiply in Chez took 3824 msec
500 x 500 matrix multiply in Chez took 3855 msec
500 x 500 matrix multiply in Chez took 3997 msec
500 x 500 matrix multiply in Chez took 3829 msec
500 x 500 matrix multiply in Chez took 3869 msec
500 x 500 matrix multiply in Chez took 3886 msec
500 x 500 matrix multiply in Chez took 3936 msec
500 x 500 matrix multiply in Chez took 3931 msec
~~~

notes
-----

To facilitate this experiment, only the OSX makefiles were used. However
the Chez Scheme system is portable to linux and Windows; much effort
appears to have been put into windows compatability in particular.


License: Apache 2, per the underlying Chez scheme license.
