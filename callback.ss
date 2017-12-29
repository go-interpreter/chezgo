;; this works to call from Chez Scheme into C.
(define incr (foreign-procedure "jea_add" (int) int))
(incr 1)
(incr 100)
