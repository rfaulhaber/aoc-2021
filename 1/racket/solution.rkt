#lang errortrace racket

(define (load-input path)
  (map string->number (file->lines path)))

(define input (load-input "../input.txt"))

;; given a list, returns a list of n sized windows
;; e.g. (window 2 '(1 2 3)) -> '((1 2) (2 3))
(define (window n lst)
  (if (<= (length lst) n)
      (list lst)
      (append (list (take lst n)) (window n (cdr lst)))))

(define (find-slope depths)
  (define (find-slope-inner depths slopes)
    (cond
      [(> (length depths) 2)
            (let*-values (((right left) (apply values (take depths 2)))
                   ((slope) (- left right)))
              (find-slope-inner (drop depths 1) (cons slope slopes)))]
      [(= (length depths) 2)
       (cons (- (second depths) (first depths)) slopes)]
      [else slopes]))
  (reverse (find-slope-inner depths '())))

;; first attempt
(define (part1 input)
  (length (filter nonnegative-integer? (find-slope input))))

;; without find-slope
(define (part1-alt input)
  (length (filter nonnegative-integer? (map (lambda (p)
                                              (- (last p) (first p)))
                                            (window 2 input)))))

(define (part2 input)
  (length (filter
           (lambda (n) (< 0 n))
           (find-slope (map (lambda (triple)
                              (apply + triple))
                            (window 3 input))))))

(printf "part 1: ~a\npart 1 alt: ~a\npart 2: ~a" (part1 input) (part1-alt input) (part2 input))

(module+ test
  (require rackunit)

  (define sample-solution 7)
  (define sample (load-input "../sample.txt"))

  (check-equal? (find-slope '(1 2)) '(1))
  (check-equal? (find-slope '(1)) '())
  (check-equal? (find-slope '(199 200 208 210 200)) '(1 8 2 -10))

  (check-equal? (window 2 '(1 2 3 4)) '((1 2) (2 3) (3 4)))
  (check-equal? (window 3 '(1 2 3 4)) '((1 2 3) (2 3 4)))

  (check-equal? (part1 sample) sample-solution)
  (check-equal? (part1-alt sample) sample-solution)
  (check-equal? (part2 sample) 5))
