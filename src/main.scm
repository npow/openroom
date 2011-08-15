;(do ((i 0 (+ i 1)))
;  ((= i (vector-length argv)))
;  (display (vector-ref argv i)))

(require mzscheme)
(load "1099.scm")
(load "search.scm")

(define argv (current-command-line-arguments))
(define error_string "None")

(letrec
  ((building (vector-ref argv 0))
   (day (vector-ref argv 1))
   (start-time (string->number (vector-ref argv 2)))
   (end-time (string->number (vector-ref argv 3)))
   (results (find-rooms building day start-time end-time)))
  (if (> (length results) 0)
    (for-each
      (lambda (x)
        (begin
          (display x)
          (newline)))
      (find-rooms building day start-time end-time))
    (begin
      (display error_string)
      (newline))))

(exit 0)
