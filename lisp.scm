(declare (uses library ports))

;; helpers
(define (first l) (car l))
(define (rest l) (cdr l))
(define (second l) (cadr l))
(define (third l) (caddr l))

(define (make-env parent)
  '())

(define (nothing? x)
  (and (symbol? x) (eq? x 'nothing)))

;; do not eval, pass
(define (lisp-eval exp env)
  exp)

;; Read Eval Print Loop
(define (repl env display-prompt)
  ;; if lisp exception print exception
  ;; else abort
  (handle-exceptions
      exn
      (cond ((and (list? exn) (eq? (first exn) 'lisp))
	     (begin (print (second exn))
		    (repl env display-prompt)))
	    (else (abort exn)))

    (begin
      (if display-prompt (display "> "))
      (let ((exp (with-input-from-port (current-input-port) read)))
	(if (eof-object? exp)
	    (print "exit")
	    (begin
	      (let ((evaluated-exp (lisp-eval exp env)))
		(if (nothing? evaluated-exp)
		    (repl env #f)
		    (begin (write evaluated-exp)
			   (newline)
			   (repl env #t))))))))))

(let ((env (make-env #f)))
  (repl env #t))
