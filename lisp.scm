(declare (uses library ports))
(include "env")
(import (only env make-env))

;; helpers
(define (first l) (car l))
(define (rest l) (cdr l))
(define (second l) (cadr l))
(define (third l) (caddr l))

;; do not eval, pass
(define (lisp-eval exp env)
  exp)

;; Read Eval Print Loop
(define (repl env)
  ;; if lisp exception print exception
  ;; else abort
  (handle-exceptions
      exn
      (cond ((and (list? exn) (eq? (first exn) 'lisp))
	     (begin (print (second exn))
		    (repl env)))
	    (else (abort exn)))

    (begin
      (display "> ")
      (let ((exp (with-input-from-port (current-input-port) read)))
	(if (eof-object? exp)
	    (print "exit")
	    (begin
	      (let ((evaluated-exp (lisp-eval exp env)))
		(begin (write evaluated-exp)
		       (newline)
		       (repl env)))))))))

(let ((env (make-env #f)))
  (repl env))
