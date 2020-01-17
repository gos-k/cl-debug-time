(defpackage cl-debug-time
  (:use :cl)
  (:import-from #:alexandria
                #:with-gensyms)
  (:import-from #:cl-annot
                #:defannotation)
  (:import-from #:local-time
                #:now
                #:timestamp-difference
                #:format-timestring)
  (:export :measure-time
           :timestamp))
(in-package :cl-debug-time)

(defun %second-per-unit (unit)
  (ecase unit
    ((or :h :hour) (/ 1.0 3600.0))
    ((or :m :min :minute) (/ 1.0 60.0))
    ((or :s :sec :second) 1.0)
    ((or :ms :msec :millisecond) 1000.0)
    ((or :us :usec :microsecond) 1000000.0)))

(defannotation measure-time (args body)
  (:arity 2 :inline t)
  (with-gensyms (start end message unit)
    `(let ((,start (now)))
       (unwind-protect (progn ,body)
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
    ((or :h :hour)
     '((:hour 2)))
    ((or :m :min :minute)
     '((:hour 2) #\: (:min 2)))
    ((or :s :sec :second)
     '((:hour 2) #\: (:min 2) #\: (:sec 2)))
    ((or :ms :msec :millisecond)
     '((:hour 2) #\: (:min 2) #\: (:sec 2) #\. (:msec 3)))
    ((or :us :usec :microsecond)
     '((:hour 2) #\: (:min 2) #\: (:sec 2) #\. (:usec 6)))))

(defannotation timestamp (unit message body)
  (:arity 3 :inline t)
  (with-gensyms (start end)
    `(let ((,start (now)))
       (format *trace-output*
                   "~a ~a start~%"
                   (format-timestring nil ,start :format ',(%unit-format unit))
                   ,message)
       (unwind-protect (progn ,body)
         (let ((,end (now)))
           (format *trace-output*
                   "~a ~a end~%"
                   (format-timestring nil ,end :format ',(%unit-format unit))
                   ,message))))))
