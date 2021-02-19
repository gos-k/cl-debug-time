(defpackage cl-debug-time
  (:use :cl)
  (:import-from #:cl-annot
                #:defannotation)
  (:import-from #:local-time
                #:now
                #:timestamp-difference
                #:format-timestring)
  (:export :with-measure-time
           :with-timestamp))
(in-package :cl-debug-time)

(defun %second-per-unit (unit)
  (ecase unit
    ((:h :hour) (/ 1.0 3600.0))
    ((:m :min :minute) (/ 1.0 60.0))
    ((:s :sec :second) 1.0)
    ((:ms :msec :millisecond) 1000.0)
    ((:us :usec :microsecond) 1000000.0)))

(defmacro with-measure-time (args &body body)
  (let ((start (gensym))
        (end (gensym))
        (message (gensym))
        (unit (gensym)))
    `(let ((,start (now)))
       (unwind-protect (progn ,@body)
         (let ((,end (now)))
           ,(etypecase args
              (keyword `(format *trace-output*
                                "~,3f [~a]~%"
                                (* ,(%second-per-unit args)
                                   (timestamp-difference ,end ,start))
                                ,(string-downcase args)))
              (list `(let ((,message ,(first args))
                           (,unit ,(second args)))
                       (format *trace-output*
                               "~a ~,3f [~a]~%"
                               ,message
                               (* ,`(%second-per-unit ,unit)
                                  (timestamp-difference ,end ,start))
                               ,`(string-downcase ,unit))))))))))

(defun %unit-format (unit)
  (ecase unit
    ((:h :hour)
     '((:hour 2)))
    ((:m :min :minute)
     '((:hour 2) #\: (:min 2)))
    ((:s :sec :second)
     '((:hour 2) #\: (:min 2) #\: (:sec 2)))
    ((:ms :msec :millisecond)
     '((:hour 2) #\: (:min 2) #\: (:sec 2) #\. (:msec 3)))
    ((:us :usec :microsecond)
     '((:hour 2) #\: (:min 2) #\: (:sec 2) #\. (:usec 6)))))

(defmacro with-timestamp (unit message &body body)
  (let ((start (gensym))
        (end (gensym)))
    `(let ((,start (now)))
       (format *trace-output*
                   "~a ~a start~%"
                   (format-timestring nil ,start :format ',(%unit-format unit))
                   ,message)
       (unwind-protect (progn ,@body)
         (let ((,end (now)))
           (format *trace-output*
                   "~a ~a end~%"
                   (format-timestring nil ,end :format ',(%unit-format unit))
                   ,message))))))
