(defvar *DB* nil)

;print
(defun dump-db ()
  (dolist (cd *DB*)
    (format t "~{~a:~10t~a~%~}~%" cd)))

(defun make-cd (title artist rating ripped)
  (list :title title :artist artist :rating rating :ripped ripped))
(defun add-record (cd)
  (push cd *DB*))
(defun prompt-read (prompt)
  (format *query-io* "~a: " prompt)
  (force-output *query-io*)
  (read-line *query-io*))
(defun prompt-for-cd ()
  (make-cd
   (prompt-read "Title")
   (prompt-read "Artist")
   (or (parse-integer (prompt-read "Rating") :junk-allowed t) 0)
   (y-or-n-p "Ripped [y/n]: ")))
;read
(defun add-cds ()
  (loop (add-record (prompt-for-cd))
     (if (not (y-or-n-p "Another? [y/n]: ")) (return))))

(defun save-db (filename);save
  (with-open-file (out filename
		       :direction :output
		       :if-exists :supersede)
    (with-standard-io-syntax
      (print *db* out))))

(defun load-db (filename);load
  (with-open-file (in filename)
    (with-standard-io-syntax
      (setf *db* (read in)))))

(defun select (selector-fn);select
  (remove-if-not selector-fn *db*))

(defun make-comparison-expr(field value)
  `(equal (getf cd ,field) ,value))
(defun make-comparisons-list (fields)
  (loop while fields
       collecting (make-comparison-expr (pop fields) (pop fields))))
;selector
(defmacro where (&rest clauses)
  `#'(lambda (cd)
       (and ,@(make-comparisons-list clauses))))
;(defun where (&key title artist rating (ripped nil ripped-p))
;  #'(lambda (cd)
;      (and
;        (if title    (equal (getf cd :title ) title ) t)
;        (if artist   (equal (getf cd :artist) artist) t)
;        (if rating   (equal (getf cd :rating) rating) t)
;        (if ripped-p (equal (getf cd :ripped) ripped) t))))



(defun make-selector-expr(field value)
  `(setf (getf row ,field) ,value))
(defun make-selectors-list (fields)
  (loop while fields
       collecting (make-selector-expr (pop fields) (pop fields))))
;update
(defmacro update (selector-fn &rest clauses)
  `(setf *db*
	 (mapcar
	  #'(lambda (row)
	      (when (funcall ,selector-fn row)
		,@(make-selectors-list clauses))
	      row)
	  *db*)))
;(defun update (selector-fn &key title artist rating (ripped nil ripped-p))
;  (setf *db*
;	(mapcar
;	 #'(lambda (row)
;	     (when (funcall selector-fn row)
;	       (if title   (setf (getf row :title ) title ))
;	       (if artist  (setf (getf row :artist) artist))
;	       (if rating  (setf (getf row :rating) rating))
;	       (if ripped-p(setf (getf row :ripped) ripped)))
;	     row)
;	 *db*)))

(defun delete-rows (selector-fn)
  (setf *db* (remove-if selector-fn *db*)))
