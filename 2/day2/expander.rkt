#lang racket/base

(require (for-syntax racket/base syntax/parse))

(provide (rename-out [day2-module-begin #%module-begin])
         #%app
         #%datum
         day2-forward
         day2-down
         day2-up
         day2-print
         day2-solve)

(define-syntax (day2-module-begin stx)
  (syntax-case stx ()
    ((_ parsed-args ...)
     #'(#%module-begin
        parsed-args ...))))

(define part1-depth 0)
(define position 0)
(define part2-depth 0)
(define aim 0)

(define (day2-forward arg)
  (set! position (+ arg position))
  (set! part2-depth (+ part2-depth (* aim arg))))

(define (day2-down arg)
  (set! part1-depth (+ arg part1-depth))
  (set! aim (+ arg aim)))

(define (day2-up arg)
  (set! part1-depth (- part1-depth arg))
  (set! aim (- aim arg)))

(define (day2-print)
  (printf "depth: ~a\nposition: ~a" part1-depth position))

(define (day2-solve part)
  (printf "part ~a solution: ~a" part
          (case part
            [(1) (solve-part-1)]
            [(2) (solve-part-2)])))

(define (solve-part-1)
  (* part1-depth position))

(define (solve-part-2)
  (* part2-depth position))

