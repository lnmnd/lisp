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

(eq? 'foo 'foo) ;; true
(eq? 'foo 'bar) ;; false
(def empty-list '())
(eq? empty-list '()) ;; true

`1 ;; 1
`,'foo ;; foo
`(1 2 ,(if true 'three 'four)) ;; (1 2 three)
`(1 2 ,(if true `,'foo 'no)) ;; (1 2 foo)

(def comment (mac* args false))
(comment dont evaluate this)
(def when (mac* (cond exp)
		`(if ,cond ,exp false)))
(when true 'its-true) ;; its-true
(def defn (mac* (sym params body)
		`(def ,sym (fn* ,params ,body))))
(defn id (val) val)
(id 'id!) ;; id!

;; numbers
1
2.3
-7
(+ 1 2 3) ;; 6
(- 3 2) ;; 1
(* 5 5) ;; 25
(/ 10 2) ;; 5


;; strings
"foo"
(conc "foo" " " "bar") ;; "foo bar"
(slurp "text1.txt")
(comment
 (spit "tmp.txt" "test\nfile\n"))
