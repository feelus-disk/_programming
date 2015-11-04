`(qwe `(rty ,,@(list 1 2 3) asf) fgh)
;eval -->
(QWE (LIST* 'RTY (LIST* 1 2 3 '(ASF))) FGH)
;=
(QWE (LIST 'RTY 1 2 3 'ASF) FGH)
;=
(QWE `(RTY ,1 ,2 ,3 ASF) FGH)
;-----
`(qwe `(rty ,,@(list '(1 2) '(3 4)) asf) fgh)
;eval -->
(QWE (LIST* 'RTY (LIST* (1 2) (3 4) '(ASF))) FGH)
;=
(QWE (LIST 'RTY (1 2) (3 4) 'ASF) FGH)
;=
(QWE `(RTY ,(1 2) ,(3 4) ASF) FGH)
;---
`(qwe `(asd ,(list ,@(list 1 2 3)) fgh) rty)
;eval -->
(QWE (LIST* 'ASD (LIST* (LIST 1 2 3) '(FGH))) RTY)
;=
(QWE (LIST 'ASD  (LIST 1 2 3) 'FGH) RTY)
;=
(QWE `(ASD ,(LIST 1 2 3) FGH) RTY)
;-------------------
;(LIST* 'DO 
;       (LIST* (LIST (LIST* VAR 
;			   (LIST* (LIST* 'NEXT-PRIME (LIST START)) 
;				  (LIST (LIST* 'NEXT-PRIME (LIST (LIST* '+ (LIST* 1 (LIST VAR))))))))) 
;	      (LIST* (LIST (LIST* '> (LIST* VAR (LIST END)))) 
;		     BODY)))

;todo после 12й главы написать ф-цию убииающую list*
;если у списка с первым аргументом list* последний аргумент list
;  то list* заменить на list, а аргументы list добавить в конец теккущего списка
;если у списка с первым аргументом list* последний аргумент list*
;  то аргументы list* добавить в конец теккущего списка
;(LIST* 'DO 
;       (LIST (LIST VAR 
;		   (LIST 'NEXT-PRIME START) 
;		   (LIST 'NEXT-PRIME (LIST '+ 1 VAR)))) 
;       (LIST (LIST '> VAR END)) 
;       BODY))
;------------------
;(once-only (start end) body)
;-->
;(LET ((#:G103 (GENSYM)) 
;      (#:G104 (GENSYM))) 
;  (LIST 'LET (LIST (LIST #:G103 STAR)
;		   (LIST #:G104 END)) 
;	(LET ((START #:G103) 
;	      (END #:G104)) 
;	  BODY)))
;=
;(LET ((#:G103 (GENSYM)) 
;      (#:G104 (GENSYM))) 
;  `(LET ((,#:G103 ,START)
;	 (,#:G104 ,END)) 
;     ,(LET ((START #:G103) 
;	    (END #:G104)) 
;	   BODY)))
;!          =`(using ,start ,end ,strt ,end)))
;-->
;(LET ((#:G103 (GENSYM)) 
;      (#:G104 (GENSYM))) 
;  (LIST* 'LET (LIST* (LIST* (LIST* #:G103 (LIST START)) 
;			    (LIST (LIST* #:G104 (LIST END))))
;		     (LIST (LET ((START #:G103) (END #:G104)) 
;			     (LIST* 'USING (LIST* START (LIST* END (LIST* STRT (LIST END))))))))))
;=
;(LET ((#:G103 (GENSYM)) 
;      (#:G104 (GENSYM))) 
;  (LIST 'LET (LIST (LIST #:G103 START) 
;		   (LIST #:G104 END))
;	(LET ((START #:G103) 
;	      (END #:G104)) 
;	  (LIST 'USING START END STRT END))))
;=
;(LET ((#:G103 (GENSYM)) 
;      (#:G104 (GENSYM))) 
;  `(LET ((,#:G103 ,START) 
;	 (,#:G104 ,END))
;     ,(LET ((START #:G103) 
;	    (END #:G104)) 
;	   `(USING ,START ,END ,STRT ,END))))

;(let ((param1 'start)
;      (param2 'end))
;  (once-only-fun (list param1 param2) 
;		 `(using ,param1 ,param2)))
;eval-->
;(LET ((#:G135 (GENSYM)) 
;      (#:G136 (GENSYM))) 
;  (LIST 'LET (LIST (LIST #:G135 START) 
;		   (LIST #:G136 END)) 
;	(LET ((START #:G135)
;	      (END #:G136)) 
;	  (USING START END))))
;=
;(LET ((#:G135 (GENSYM)) 
;      (#:G136 (GENSYM))) 
;  `(LET ((,#:G135 ,START) 
;	 (,#:G136 ,END)) 
;     ,(LET ((START #:G135)
;	    (END #:G136)) 
;	   (USING START END))))
;-------------------------------
(do-primes+1 (myvar (getstart) (getend))
  (format t "~d " myvar))
;macroexpand -->
(LET ((#:G137 (GETSTART)) (#:G138 (GETEND))) 
  (DO ((MYVAR (NEXT-PRIME #:G137) (NEXT-PRIME (+ 1 MYVAR)))) 
      ((> MYVAR #:G138)) 
    (FORMAT T "~d " MYVAR)))
;-----
(once-only ((getstart)(getend))
		    (do ((myvar (next-prime (getstart))(next-prime (+ 1 myvar))))
			((> myvar (getend)))
		      (format t "~d " myvar)))
;macroexpand -->
(LET ((#:G167 (GENSYM)) (#:G168 (GENSYM))) 
  (LIST* 'LET (LIST* (LIST (LIST* #:G167 (LIST (GETSTART))) (LIST* #:G168 (LIST (GETEND))))
		     (LIST (LET (((GETSTART) #:G167) ((GETEND) #:G168))
			     (DO ((MYVAR (NEXT-PRIME (GETSTART)) (NEXT-PRIME (+ 1 MYVAR)))) 
				 ((> MYVAR (GETEND))) 
			       (FORMAT T "~d " MYVAR)))))))
;=
(LET ((#:G167 (GENSYM)) (#:G168 (GENSYM))) 
  `(LET ((,#:G167 ,(GETSTART))) (,#:G168 ,(GETEND))
	,(LET (((GETSTART) #:G167) ((GETEND) #:G168)) 
	      (DO ((MYVAR (NEXT-PRIME (GETSTART)) (NEXT-PRIME (+ 1 MYVAR)))) 
		  ((> MYVAR (GETEND))) 
		(FORMAT T "~d " MYVAR)))))