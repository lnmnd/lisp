(module eval
    (lisp-eval)
  (import chicken scheme)

  ;; do not eval, pass
  (define (lisp-eval exp env)
    exp)
  
  )
