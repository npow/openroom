(require (lib "match.ss"))

(define in-between?
  (lambda (c1 c c2)
    (and (char-ci>=? c c1)
         (char-ci<=? c c2))))

(define isdigit?
  (lambda (c)
    (in-between? #\0 c #\9)))

(define isalpha?
  (lambda (c)
    (in-between? #\A c #\Z)))

(define demangle
  (lambda (expr)
    (letrec ((m-time
              (lambda (t prev)
                (if (or (>= prev 1200)
                        (<= t 829))
                    (+ t 1200)
                    t)))
             (fix-Th
              (lambda (x)
                (if (empty? x)
                    x
                    (call/cc
                     (lambda (k)
                       (let ((y (car x)))
                         (match y
                           (#\T (if (and (not (empty? (cdr x)))
                                         (char=? (cadr x) #\h))
                                    (k `(#\H ,@(cddr x)))
                                    (cons y (fix-Th (cdr x)))))
                           (_ (cons y (fix-Th (cdr x)))))))))))
             (seek
              (lambda (x i j)
                (if (empty? x)
                    `(,@i ,(fix-Th j))
                    (let ((y (car x)))
                      (match y
                        (#\- (seek (cdr x) `(,@i ,(m-time (string->number (list->string j)) 0)) '()))
                        (#\: (seek (cdr x) i j))
                        ((? isdigit?) (seek (cdr x) i `(,@j ,y)))
                        ((? isalpha?) (if (isdigit? (car j))
                                          (seek (cdr x) `(,@i ,(m-time (string->number (list->string j)) (car i))) `(,y))
                                          (seek (cdr x) i `(,@j ,y))))))))))
      (seek (string->list expr) '() '()))))

;(define blah "07:30-10:00TTh")
;(demangle blah)