#lang racket

(require syntax/parse/define)

(provide (rename-out [day2-module-begin #%module-begin]))

(define-syntax (day2-module-begin stx)
#'(#%module-begin
     (define depth 0)
     (define position 0)

     (define (day2-forward arg)
       (set! position (+ 1 position)))

     (define (day2-down arg)
       (set! depth (+ 1 depth)))

     (define (day2-up arg)
       (set! depth (- depth 1)))

     (define (day2-print)
       (printf "depth: ~a\nposition: ~a" depth position))

     (define (day2-solve part)
       "todo")

     #,@stx))
