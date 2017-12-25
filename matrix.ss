#|
usage:

> (import (my-matrix))
> (sanity)
#t
> (run-bench)
500 x 500 matrix multiply in Chez took 2472 msec
500 x 500 matrix multiply in Chez took 2474 msec
...

|#

(library (my-matrix (1))
         (export run-bench sanity)
         (import (chezscheme))


;;; reference: https://www.scheme.com/tspl3/examples.html

;;; make-matrix creates a matrix (a vector of vectors).
(define make-matrix
  (lambda (rows columns)
    (do ((m (make-vector rows))
         (i 0 (+ i 1)))
        ((= i rows) m)
      (vector-set! m i (make-vector columns)))))

;;; matrix? checks to see if its argument is a matrix.
;;; It isn't foolproof, but it's generally good enough.
(define matrix?
  (lambda (x)
    (and (vector? x)
         (> (vector-length x) 0)
         (vector? (vector-ref x 0)))))

;; matrix-rows returns the number of rows in a matrix.
(define matrix-rows
  (lambda (x)
    (vector-length x)))

;; matrix-columns returns the number of columns in a matrix.
(define matrix-columns
  (lambda (x)
    (vector-length (vector-ref x 0))))

;;; matrix-ref returns the jth element of the ith row.
(define matrix-ref
  (lambda (m i j)
    (vector-ref (vector-ref m i) j)))

;;; matrix-set! changes the jth element of the ith row.
(define matrix-set!
  (lambda (m i j x)
    (vector-set! (vector-ref m i) j x)))

;;; mul is the generic matrix/scalar multiplication procedure
(define mul
  (lambda (x y)
    ;; mat-sca-mul multiplies a matrix by a scalar.
    (define mat-sca-mul
      (lambda (m x)
        (let* ((nr (matrix-rows m))
               (nc (matrix-columns m))
               (r  (make-matrix nr nc)))
          (do ((i 0 (+ i 1)))
              ((= i nr) r)
            (do ((j 0 (+ j 1)))
                ((= j nc))
              (matrix-set! r i j
                           (* x (matrix-ref m i j))))))))

    ;; mat-mat-mul multiplies one matrix by another, after verifying
    ;; that the first matrix has as many columns as the second
    ;; matrix has rows.
    (define mat-mat-mul
      (lambda (m1 m2)
        (let* ((nr1 (matrix-rows m1))
               (nr2 (matrix-rows m2))
               (nc2 (matrix-columns m2))
               (r   (make-matrix nr1 nc2))
               (tot 0))
          (if (not (= (matrix-columns m1) nr2))
              (match-error m1 m2))
          (do ((i 0 (+ i 1)))
              ((= i nr1) r)
            
            (do ((k 0 (+ k 1)))
                ((= k nr2))
              
              (let ((ith-input-row (vector-ref m1 i))
                    (kth-input-row (vector-ref m2 k))
                    (ith-output-row (vector-ref r i)))
                
                (do ((j 0 (+ j 1)))
                    ((= j nc2))
                  (set! tot (vector-ref ith-output-row j))
                  (set! tot (+ tot
                               (* (vector-ref ith-input-row k)
                                  (vector-ref kth-input-row j))))
                  (vector-set! ith-output-row j tot))))))))
    
    ;; type-error is called to complain when mul receives an invalid
  ;; type of argument.
    (define type-error
      (lambda (what)
        (error 'mul
               "~s is not a number or matrix"
               what)))

    ;; match-error is called to complain when mul receives a pair of
    ;; incompatible arguments.
    (define match-error
      (lambda (what1 what2)
        (error 'mul
               "~s and ~s are incompatible operands"
               what1
               what2)))

    ;; body of mul; dispatch based on input types
    (cond
     ((number? x)
      (cond
       ((number? y) (* x y))
       ((matrix? y) (mat-sca-mul y x))
       (else (type-error y))))
     ((matrix? x)
      (cond
       ((number? y) (mat-sca-mul x y))
       ((matrix? y) (mat-mat-mul x y))
       (else (type-error y))))
     (else (type-error x)))))

(define (fill-random m)
    (let* ((nr (matrix-rows m))
           (nc (matrix-columns m)))
      (do ((i 0 (+ i 1)))
          ((= i nr))
        (do ((j 0 (+ j 1)))
            ((= j nc))
          (matrix-set! m i j (/ (random 100) (+ 2.0 (random 100))))
          ))))

(define (bench a b) (mul a b))

(define (run-bench)
  (collect)
(do ((runs 0 (+ 1 runs))) ((>= runs 10))
(do ((sz 500 (+ sz 100)))
    ((>= sz 600))
  (let* ((a (make-matrix sz sz))
         (b (make-matrix sz sz)))
    (fill-random a)
    (fill-random b)
    (let*
        ((t0 (real-time))
         (blah (mul a b))
         (t1 (real-time)))
      (format #t "~s x ~s matrix multiply in Chez took ~s msec" sz sz (- t1 t0))
      (newline)
      )))))


(define (fill-sequential m start)
    (let* ((nr (matrix-rows m))
           (nc (matrix-columns m))
           (val start))
      (do ((i 0 (+ i 1)))
          ((= i nr))
        (do ((j 0 (+ j 1)))
            ((= j nc))
          (matrix-set! m i j val)
          (set! val (+ 1 val))
          ))))

(define (matrix-same m1 m2)
  (let* (
         (nr1 (matrix-rows m1))
         (nr2 (matrix-rows m2))
         (nc1 (matrix-columns m1))
         (nc2 (matrix-columns m2))
         (final #t)
         )
    (if (not (eq? nc1 nc2))
        (set! final #f)
      (if (not (eq? nr1 nr2))
          (set! final #f)
        (do ((i 0 (+ i 1)))
            ((= i nr1))
          (do ((j 0 (+ j 1)))
              ((= j nc1))
            (let*
                ((v1 (matrix-ref m1 i j))
                 (v2 (matrix-ref m2 i j))
                 )
              (if (not (eq? v1 v2))
                  (set! final #f))
              )))))
    final))

;; sanity test, is our logic right?
;; expect that #(#(1 2) #(3 4))  x #(#(5 6) #(7 8)) == #(#(19 22) #(43 50))

(define (sanity)
  (let* (
         (expect (make-matrix 2 2))
         (a (make-matrix 2 2))
         (b (make-matrix 2 2))
         )
    (matrix-set! expect 0 0 19)
    (matrix-set! expect 0 1 22)
    (matrix-set! expect 1 0 43)
    (matrix-set! expect 1 1 50)
    (fill-sequential a 1)
    (fill-sequential b 5)
    (let* (
           (obs (mul a b))
           )
      ;; verify this gives us true
      (matrix-same obs expect)
      )))


#|
chez scheme timings, on mac book pro:
(with (optimize-level 3); as we go ~ 10% faster)

 scheme --optimize-level 3 ./matrix.ss 
Chez Scheme Version 9.5.1
Copyright 1984-2017 Cisco Systems, Inc.

;; top-level bindings, without a library wrapper:
500 x 500 matrix multiply in Chez took 2606 msec
500 x 500 matrix multiply in Chez took 2605 msec
500 x 500 matrix multiply in Chez took 2571 msec
500 x 500 matrix multiply in Chez took 2634 msec
500 x 500 matrix multiply in Chez took 2597 msec
500 x 500 matrix multiply in Chez took 2603 msec
500 x 500 matrix multiply in Chez took 2565 msec
500 x 500 matrix multiply in Chez took 2535 msec
500 x 500 matrix multiply in Chez took 2587 msec
500 x 500 matrix multiply in Chez took 2547 msec

;; inside the my-matrix library:
500 x 500 matrix multiply in Chez took 2435 msec
500 x 500 matrix multiply in Chez took 2498 msec
500 x 500 matrix multiply in Chez took 2486 msec
500 x 500 matrix multiply in Chez took 2496 msec
500 x 500 matrix multiply in Chez took 2465 msec
500 x 500 matrix multiply in Chez took 2499 msec
500 x 500 matrix multiply in Chez took 2492 msec
500 x 500 matrix multiply in Chez took 2532 msec
500 x 500 matrix multiply in Chez took 2463 msec
500 x 500 matrix multiply in Chez took 2526 msec

|#

) ;; end my-matrix library
