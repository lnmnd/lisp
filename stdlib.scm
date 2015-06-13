;; standard library

(def empty? (fn* (xs) (eq? xs '())))

(def last (fn* (xs)
	       (if (empty? (rest xs))
		   (first xs)
		   (last (rest xs)))))

(def do (fn* args
	     (last args)))

(def mac (mac* args
	       `(mac* ,(first args)
		      ,(cons 'do (rest args)))))

(def defmac (mac args
		 `(def ,(first args)
		       ,(cons 'mac
			      (cons (first (rest args))
				    (rest (rest args)))))))

(defmac comment args false)

(defmac fn args
  `(fn* ,(first args)
	,(cons 'do (rest args))))

(defmac defn args
  `(def ,(first args)
	,(cons 'fn
	       (cons (first (rest args))
		     (rest (rest args))))))

;; lists

(defn list xs xs)

(defn second (xs)
  (first (rest xs)))

(defn nth (xs index)
  (if (eq? index 0)
      (first xs)
      (nth (rest xs) (- index 1))))

(defn reverse (xs)
  (defn reverse-it (acc xs)
    (if (empty? xs)
	acc
	(reverse-it (cons (first xs) acc) (rest xs))))
  (reverse-it (list) xs))

(defn append (xs x)
  (reverse (cons x (reverse xs))))

(defn take (n seq)
  (defn take-it (acc n seq)
    (if (eq? n 0)
	acc
	(if (empty? seq)
	    acc
	    (take-it (append acc (first seq)) (- n 1) (rest seq)))))
  (take-it (list) n seq))

(defn drop (n xs)
  (if (eq? n 0)
      xs
      (if (empty? xs)
	  xs
	  (drop (- n 1) (rest xs)))))

(defn filter (pred xs)
  (defn filter-it (acc pred xs)
    (if (empty? xs)
	acc
	(if (pred (first xs))
	    (filter-it (cons (first xs) acc) pred (rest xs))
	    (filter-it acc pred (rest xs)))))
  (filter-it (list) pred (reverse xs)))

(defn map (f xs)
  (defn map-it (acc f xs)
    (if (empty? xs)
	acc
	(map-it (cons (f (first xs)) acc) f (rest xs))))
  (map-it (list) f (reverse xs)))


;; files

(defn load (file)
  (eval (read-string
	 (str "(do "
	      (slurp file)
	      ")"))))
