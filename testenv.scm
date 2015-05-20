(include "env")
(import (only env make-env))

(define-syntax test
  (syntax-rules (=>)
    ((test a => b) (let ((result (eval a)))
		     (if (not (eq? result b))
			 (error (conc "got " result " instead of " b)))))))

(define-syntax test-exn
  (syntax-rules ()
    ((test-exn exp)
     (handle-exceptions
	 exn
	 (if (not (and (list? exn) (eq? (car exn) 'lisp)))
	     (abort exn))
       (env 'set 'foo 3)))))

(define env (make-env #f))
(env 'def 'x 2)
(test (env 'get 'x) => 2)
(env 'set 'x 3)
(test (env 'get 'x) => 3)
(test-exn (env 'set 'foo 3))

(define cenv (make-env env))
(test (cenv 'get 'x) => 3)
(cenv 'def 'x 5)
(test (cenv 'get 'x) => 5)
(test (env 'get 'x) => 3)
(env 'def 'y 1)
(cenv 'set 'y 10)
(test (env 'get 'y) => 10)

