(module eval
    (lisp-eval init-env)
  (import chicken scheme)
  (import (only data-structures conc))
  (import (only env make-env))

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

  (define (quasiquoted? exp)
    (tagged-list? exp 'quasiquote))

  (define (expand-unquote exp env)
    (if (list? exp)
	(if (eq? 'unquote (car exp))
	    (lisp-eval (cadr exp) env)
	    (map (lambda (x)
		   (expand-unquote x env))
		 exp))
	exp))

  (define (eval-quasiquoted exp env)
    (expand-unquote (cadr exp) env))

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

  (define (lambda? exp)
    (tagged-list? exp 'fn*))

  (define (make-lambda exp env)
    (let ((args (cadr exp)))
      (if (list? args)
	  (list 'fn #t args (caddr exp) env)
	  (list 'fn #f args (caddr exp) env))))

  (define (application? exp)
    (list? exp))

  (define (eval-arguments args env)
    (if (null? args)
	args
	(cons (lisp-eval (car args) env)
	      (eval-arguments (cdr args) env))))
  
  (define (extend-environment symbols vals env)
    (let ((cenv (make-env env))
	  (i 0))
      (for-each (lambda (x)
		  (cenv 'def x (list-ref vals i))
		  (set! i (+ i 1)))
		symbols)
      cenv))
  
  (define (apply-lambda fn args env)
    (let ((des-args (cadr fn))
	  (params (caddr fn))
	  (body (cadddr fn))
	  (fn-env (car (cddddr fn))))
      (if des-args
	  (lisp-eval body (extend-environment params args fn-env))
	  (lisp-eval body (extend-environment (list params) (list args) fn-env)))))

  (define (apply-primitive fn args env)
    ((cadr fn) args))
  
  (define (lisp-apply exp env)
    (let ((operator (lisp-eval (car exp) env))
	  (args (eval-arguments (cdr exp) env)))
      (if (list? operator)
	  (cond ((eq? 'fn (car operator)) (apply-lambda operator args env))
		((eq? 'primfn (car operator)) (apply-primitive operator args env))
		(abort '(list "cannot apply")))
	  (abort '(lisp "cannot apply")))))
  
  (define (lisp-eval exp env)
    (cond ((self-evaluating? exp) exp)
	  ((quoted? exp) (quoted-exp exp))
	  ((quasiquoted? exp) (eval-quasiquoted exp env))
	  ((definition? exp) (eval-definition exp env))
	  ((reset? exp) (eval-reset exp env))
	  ((symbol? exp) (env 'get exp))
	  ((if? exp) (eval-if exp env))
	  ((lambda? exp) (make-lambda exp env))
	  ((application? exp) (lisp-apply exp env))
	  (else (abort `(lisp ,(conc "cannot evaluate " exp))))))

  ;; primitive functions
  (define (prim-first args)
    (caar args))

  (define (prim-rest args)
    (cdar args))

  (define (prim-cons args)
    (let ((item (car args))
	  (xs (cadr args)))
      (cons item xs)))

  (define (prim-eq? args)
    (let ((a (car args))
	  (b (cadr args)))
      (if (eq? a b)
	  'true
	  'false)))
  
  (define (add-primitive symbol fn env)
    (env 'def symbol (list 'primfn fn)))

  (define (init-env env)
    (add-primitive 'first prim-first env)
    (add-primitive 'rest prim-rest env)
    (add-primitive 'cons prim-cons env)
    (add-primitive 'eq? prim-eq? env))
  
  )
