(module eval
    (lisp-eval)
  (import chicken scheme)
  (import (only data-structures conc))

  (define (lboolean? exp)
    (and (symbol? exp)
	 (or (eq? 'true exp) (eq? 'false exp))))
  
  (define (self-evaluating? exp)
    (cond ((lboolean? exp) #t)
	  (else #f)))
  
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
    (let ((value (lisp-eval (caddr exp) env)))
      (env 'def (cadr exp) value)
      value))

  (define (reset? exp)
    (tagged-list? exp 'reset!))

  (define (eval-reset exp env)
    (let ((value (lisp-eval (caddr exp) env)))
      (env 'set (cadr exp) value)
      value))

  (define (if? exp)
    (tagged-list? exp 'if))

  (define (true? exp)
    (and (lboolean? exp) (eq? 'true exp)))
  
  (define (eval-if exp env)
    (let ((predicate (lisp-eval (cadr exp) env)))
      (if (lboolean? predicate)
	  (if (true? predicate)
	      (lisp-eval (caddr exp) env)
	      (lisp-eval (cadddr exp) env))
	  (abort `(lisp ,(conc "not a boolean: " predicate))))))

  (define (lisp-eval exp env)
    (cond ((self-evaluating? exp) exp)
	  ((quoted? exp) (quoted-exp exp))
	  ((definition? exp) (eval-definition exp env))
	  ((reset? exp) (eval-reset exp env))
	  ((symbol? exp) (env 'get exp))
	  ((if? exp) (eval-if exp env))
	  (else (abort `(lisp ,(conc "cannot evaluate " exp))))))
  
  )
