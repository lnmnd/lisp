((fn* (n) n) 'foo) ;; foo

;; thanks sussman
(def cons (fn* (a b) (fn* (z) (z a b))))
(def car (fn* (z) (z (fn* (a b) a))))
(def cdr (fn* (z) (z (fn* (a b) b))))

(car (cons 'first 'second)) ;; first
(cdr (cons 'first 'second)) ;; second

(def list (fn* xs xs))
(list '1 '2 '3) ;; (1 2 3)

(def l '(1 2 3))
(first l) ;; 1
(rest l) ;; (2 3)


