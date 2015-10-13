(load "core.l")

(defn inc (n) (+ n 1))
(inc 1) ; => 2

(map inc '(1 2 3)) ; => (2 3 4)

(let (x 1
      y 2)
  (+ x y)) ; => 3
