#lang racket

(require syntax/strip-context)

(provide (rename-out (day2-read-syntax read-syntax)
                     (day2-read read)))

(define (day2-read in)
  (syntax->datum (day2-read-syntax #f in)))

(define (day2-read-syntax src in)
  (define s-exprs (read-code-from in))
  (define module-datum `(module day2 day2/expander
                          ,@s-exprs))
  (datum->syntax #f module-datum))

(define (filter-blank-lines str-list)
  (filter (lambda (str)
            (not (eq? "" str)))
          str-list))

(define (read-code-from port)
  (let* ((input (port->lines port))
        (filtered-input (filter (lambda (line) (not (equal? line ""))) input)))
    (map line-to-sexp filtered-input)))

(define (line-to-sexp line)
  (let* ((split (string-split line '#px"\\s+"))
        (cmd (first split))
        (arg (when (= (length split) 2)
                 (string->number (second split)))))
    (case cmd
      [("forward") `(day2-forward ,arg)]
      [("down") `(day2-down ,arg)]
      [("up") `(day2-up ,arg)]
      [("print") '(day2-print)]
      [("solve") `(day2-solve ,arg)]
      [else (error (format "Invalid cmd found: ~a" cmd))])))


(module+ test
  (require rackunit)

  (check-equal? (read-code-from (open-input-string "forward 2\ndown 1\nprint"))
                '((day2-forward 2)
                  (day2-down 1)
                  (day2-print))))
