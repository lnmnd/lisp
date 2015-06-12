(module env
    (make-env)
  (import chicken scheme)
  (import (only data-structures conc))

  (define (make-env parent)
    (define vals '())

    (define (def-symbol! symbol val)
      (set! vals (cons (cons symbol val) vals)))

    (define (set-symbol-it! vals symbol val)
      (if (null? vals)
	  (if (not (eq? parent #f))
	      (parent 'set symbol val)
	      (abort (list 'lisp (conc "symbol " symbol " not found"))))
	  (let ((x (car vals)))
	    (if (eq? (car x) symbol)
		(set! (cdr x) val)
		(set-symbol-it! (cdr vals) symbol val)))))
    
    (define (set-symbol! symbol val)
      (set-symbol-it! vals symbol val))
    
    (define (get-symbol-it vals symbol)
      (if (null? vals)
	  (if (not (eq? parent #f))
	      (parent 'get symbol)
	      (abort (list 'lisp (conc "symbol " symbol " not found"))))
	  (let ((x (car vals)))
	    (if (eq? (car x) symbol)
		(cdr x)
		(get-symbol-it (cdr vals) symbol)))))
    
    (define (get-symbol symbol)
      (get-symbol-it vals symbol))

    (define (print-env)
      (print vals)
      (if parent
	  (parent 'print-env)))
    
    (lambda (msg . args)
      (apply (case msg
	       ((def) def-symbol!)
	       ((set) set-symbol!)
	       ((get) get-symbol)
	       ((print) print-env)
	       (else (abort (list 'lisp (conc "unknown method " msg)))))
	     args)))
  
  )
