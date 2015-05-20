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

  (define (definition? exp)
    (tagged-list? exp 'def))

  (define (eval-definition exp env)
    (env 'def (cadr exp) (lisp-eval (caddr exp) env)))

  ;; do not eval, pass
  (define (lisp-eval exp env)
    (cond ((quoted? exp) (quoted-exp exp))
	  ((definition? exp) (eval-definition exp env))
	  ((symbol? exp) (env 'get exp))
	  (else (abort `(lisp ,(conc "cannot evaluate " exp))))))
  
  )
