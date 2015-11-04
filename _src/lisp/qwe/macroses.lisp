(defun prime-p (number)
  "простое ли число"
  (when (> number 1)
    (loop for m from 2 to (isqrt number)
	 never (zerop (mod number m)))))

(defun next-prime (number)
  "возвращает следующее простое число"
  (loop for n from number
       when (prime-p n) return n))

(defmacro do-primes-1 ((var start end) &body body)
  "с многократным вычислением end"
  `(do ((,var (next-prime ,start) (next-prime (+ 1 ,var))))
       ((> ,var ,end))
     ,@body))

(defmacro do-primes-2 ((var start end) &body body)
  "неуникальная переменная"
  `(do ((,var (next-prime ,start) (next-prime (+ 1 ,var)))
	(ending-value ,end))
       ((> ,var ending-value))
     ,@body))

(defmacro do-primes ((var start end) &body body)
  "good"
  (let ((ending-value (gensym)))
    `(do ((,var (next-prime ,start) (next-prime (+ 1 ,var)))
	  (,ending-value ,end))
	 ((> ,var ,ending-value))
       ,@body)))
;-------------------------------------------
(defmacro with-gensyms ((&rest names)&body body)
  `(let ,(loop for n in names collect `(,n (gensym)))
     ,@body))
(defmacro do-primes+2 ((var start end) &body body)
  "good"
  (with-gensyms (ending-value)
    `(do ((,var (next-prime ,start) (next-prime (+ 1 ,var)))
	  (,ending-value ,end))
	 ((> ,var ,ending-value))
       ,@body)))
;-------------------------------------------
(defmacro once-only ((&rest names) &body body)
  (let ((gensyms (loop for n in names collect (gensym))))
    `(let (,@(loop for g in gensyms collect `(,g (gensym))))
       `(let (,,@(loop for g in gensyms for n in names collect ``(,,g ,,n)))
	  ,(let (,@(loop for n in names for g in gensyms collect `(,n ,g)))
		,@body)))))
(defmacro do-primes+1 ((var start end) &body body)
  (once-only (start end)
    `(do ((,var (next-prime ,start) (next-prime (+ 1 ,var))))
	 ((> ,var ,end))
       ,@body)))
;----------------------------------------
(defun once-only-fun (names &rest body)
  (let ((gensyms (loop for n in names collect (gensym))))
    `(let (,@(loop for g in gensyms collect `(,g (gensym))))
       `(let (,,@(loop for g in gensyms for n in names collect ``(,,g ,,n)))
	  ,(let (,@(loop for n in names for g in gensyms collect `(,n ,g)))
		,@body)))))
