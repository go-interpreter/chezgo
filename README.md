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

Chez is used in Robotic drug testing, Chip layout and design, multithreaded web services, and enterprise systems. Some users include Sandia National Labs, Motorola, Freescale, Beckman Coulter, Disney, University of Indiana (where Dybvig is a professor of Computer Science, specializing in programming languages and compiler design). It has been in development since 1985 (started on a VAX running BSD Unix), and saw nine major commercial releases prior to going open source (currently it is at version 9.5.8, released 2022 Apr 25; it is still being updated today; github history is [here](https://github.com/cisco/ChezScheme/releases)). Reviewing Dybvig's history paper (below) shows numerous surprising insights into producing code incrementally and online. Open source Chez development is ongoing and active today, and the last merged pull request at the time of this writing was 10 hours ago.

Chez has a generational garbage collector that automatically collects code and data that is no longer in use. Chez includes a debugger, and a full numeric tower.

Other Schemes, like Racket, [have moved to Chez underneath](https://blog.racket-lang.org/2021/02/racket-v8-0.html), now that it is freely available.

# background

architecture talk slides

http://icfp06.cs.uchicago.edu/dybvig-talk.pdf

history of Chez Scheme

https://www.cs.indiana.edu/~dyb/pubs/hocs.pdf

# benchmarks

versus other schemes: https://ecraven.github.io/r7rs-benchmarks/


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

turning on full optimization on Chez helped a little

~~~
;; after Andy Keep schooled me in optimizing
;; scheme code... see his notes https://github.com/cisco/ChezScheme/issues/248
> (run-bench)
500 x 500 matrix multiply in Chez took 643 msec
500 x 500 matrix multiply in Chez took 654 msec
500 x 500 matrix multiply in Chez took 667 msec
500 x 500 matrix multiply in Chez took 651 msec
500 x 500 matrix multiply in Chez took 662 msec
500 x 500 matrix multiply in Chez took 643 msec
500 x 500 matrix multiply in Chez took 647 msec
500 x 500 matrix multiply in Chez took 645 msec
500 x 500 matrix multiply in Chez took 651 msec
500 x 500 matrix multiply in Chez took 648 msec

old, non-optimal code, uses set! which kills performance.

scheme --optimize-level 3 ./matrix.ss 
Chez Scheme Version 9.5.1
Copyright 1984-2017 Cisco Systems, Inc.
> (import (my-matrix))
> (run-bench)
500 x 500 matrix multiply in Chez took 2075 msec
500 x 500 matrix multiply in Chez took 2040 msec
500 x 500 matrix multiply in Chez took 2054 msec
500 x 500 matrix multiply in Chez took 2059 msec
500 x 500 matrix multiply in Chez took 2066 msec
500 x 500 matrix multiply in Chez took 2048 msec
500 x 500 matrix multiply in Chez took 2053 msec
500 x 500 matrix multiply in Chez took 2112 msec
500 x 500 matrix multiply in Chez took 2064 msec
500 x 500 matrix multiply in Chez took 2060 msec
~~~


Go matrix multiplication, in cmd/matmul subdir
~~~
go run matmul.go
500 x 500 matrix multiply in Go took 362 msec
500 x 500 matrix multiply in Go took 360 msec
500 x 500 matrix multiply in Go took 372 msec
500 x 500 matrix multiply in Go took 371 msec
500 x 500 matrix multiply in Go took 382 msec
500 x 500 matrix multiply in Go took 360 msec
500 x 500 matrix multiply in Go took 364 msec
500 x 500 matrix multiply in Go took 364 msec
500 x 500 matrix multiply in Go took 363 msec
500 x 500 matrix multiply in Go took 399 msec

~~~



(Difference from the original: Reversing the inner two (k and j) loops helped some.)
(see also https://www.reddit.com/r/programming/comments/pv3k9/why_we_created_julia_a_new_programming_language/c3t28nx/)


Aside: Julia code is about 6 msec. But this is
a different matrix approach. We know vector
of vector is suboptimal, but that's what we
have ready scheme code for.
~~~
julia> function myFunc()
  A = randn(500, 500)
  B = randn(500, 500)
  tic()
  q= A*B
 return  (toc(), q)
end
julia> myFunc()
elapsed time: 0.006084477 seconds
500×500 Array{Float64,2}:[-1.7587 25.6692 … 15.5834 27.9475; -15.8463 7.09889 … -2.73291 7.42923; … ; 32.2588 16.9683 … 30.874 -12.7082; 7.07166 -35.805 … -9.39162 25.681])
~~~

For comparison, using gonum Dense matrices,
the multiplcation is about 24 msec in Golang.
See the ./gonum.go file for specifics. So Go
is about 4x slower than Julia.

Other comparison points: `Gnu octave` using OpenBLAS runs the same
multiplication in 2 msec in Windows. On OSX using the
Apple supplied default BLAS instead of OpenBLAS,
`octave` needs 4-7 msec for the multiply.

node.js v9.3.0 (javascript V8 engine), using math.js took 2174 msec.
See big.js.gz / mat.js. http://mathjs.org/docs/datatypes/matrices.html
So node.js comes in at about the same speed as Chez.


notes
-----

To facilitate this experiment, only the OSX makefiles were used. However
the Chez Scheme system is portable to linux and Windows; much effort
appears to have been put into windows compatability in particular.


License: Apache 2, per the underlying Chez scheme license.
