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

(defn list xs xs)
