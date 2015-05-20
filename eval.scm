(module eval
    (lisp-eval)
  (import chicken scheme)
  (import (only data-structures conc))

  (define (tagged-list? exp tag)
    (if (pair? exp)
	(eq? (car exp) tag)
	#f))

  (define (quoted? exp)
    (tagged-list? exp 'quote))

  (define (quoted-exp exp)
    (cadr exp))

  ;; do not eval, pass
  (define (lisp-eval exp env)
    (cond ((quoted? exp) (quoted-exp exp))
	  (else (abort `(lisp ,(conc "cannot evaluate " exp))))))
  
  )
