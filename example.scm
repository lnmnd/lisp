((fn* (n) n) 'foo) ;; foo

;; thanks sussman
(def cons (fn* (a b) (fn* (z) (z a b))))
(def car (fn* (z) (z (fn* (a b) a))))
(def cdr (fn* (z) (z (fn* (a b) b))))

(car (cons 'first 'second)) ;; first
(cdr (cons 'first 'second)) ;; second
