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

(def defmacro (mac args
		   `(def ,(first args)
			 ,(cons 'mac
				(cons (first (rest args))
				      (rest (rest args)))))))

(defmacro comment args false)

(defmacro fn args
  `(fn* ,(first args)
	,(cons 'do (rest args))))

(defmacro defn args
  `(def ,(first args)
	,(cons 'fn
	       (cons (first (rest args))
		     (rest (rest args))))))

;; lists

(defn list xs xs)

(defn second (xs)
  (first (rest xs)))

(defn reverse (xs)
  (defn reverse-it (acc xs)
    (if (empty? xs)
	acc
	(reverse-it (cons (first xs) acc) (rest xs))))
  (reverse-it (list) xs))

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
