((fn* (n) n) 'foo) ;; foo

;; thanks sussman
(def lcons (fn* (a b) (fn* (z) (z a b))))
(def lcar (fn* (z) (z (fn* (a b) a))))
(def lcdr (fn* (z) (z (fn* (a b) b))))

(lcar (lcons 'first 'second)) ;; first
(lcdr (lcons 'first 'second)) ;; second

(def list (fn* xs xs))
(list '1 '2 '3) ;; (1 2 3)

(def l '(1 2 3))
(first l) ;; 1
(rest l) ;; (2 3)
(cons '1 '(2 3)) ;; (1 2 3)



