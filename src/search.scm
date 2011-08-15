(require (lib "list.ss"))
(require (lib "pregexp.ss"))

(define find-rooms
  (lambda (building day start-time end-time)
    (let ((ht (make-hash-table 'equal))
          (lc-false (lambda () 'FALSE))
          (avail-rooms '()))
      (begin
        (for-each (lambda (y)
                    (let ((room (cadr y))
                          (start (caddr y))
                          (end (cadddr y))
                          (days (car (cddddr y))))
                      (if (and (pregexp-match day days)
                               (or (and (>= start-time start) (< start-time end))
                                   (and (> end-time start) (<= end-time end))
                                   (and (>= start-time start) (<= end-time end))
                                   (and (<= start-time start) (>= end-time end))))
                          (hash-table-put! ht room #f)
                          (if (eq? 'FALSE (hash-table-get ht room lc-false))
                              (hash-table-put! ht room #t)
                              'FALSE))))
                  (filter (lambda (x) (equal? (car x) building)) classes))
        (hash-table-for-each ht (lambda (room available?) (if available? (set! avail-rooms (cons (string-append building " " room) avail-rooms)) 'FALSE)))
        (sort avail-rooms string<?)))))