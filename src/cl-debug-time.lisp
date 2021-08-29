(defpackage cl-debug-time
  (:use :cl)
  (:import-from #:local-time
                #:now
                #:timestamp-difference
                #:format-timestring)
  (:export :with-measure-time
           :with-timestamp
           :debug-time-reader
           :measure-time
           :timestamp
           :enable-annotation))
(in-package :cl-debug-time)

(defun %second-per-unit (unit)
  (ecase unit
    ((:h :hour) (/ 1.0 3600.0))
    ((:m :min :minute) (/ 1.0 60.0))
    ((:s :sec :second) 1.0)
    ((:ms :msec :millisecond) 1000.0)
    ((:us :usec :microsecond) 1000000.0)))

(defmacro with-measure-time (args body)
  (let ((start (gensym))
        (end (gensym))
        (message (gensym))
        (unit (gensym)))
    `(let ((,start (now)))
       (unwind-protect ,body
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

(defmacro with-timestamp (unit message body)
  (let ((start (gensym))
        (end (gensym)))
    `(let ((,start (now)))
       (format *trace-output*
                   "~a ~a start~%"
                   (format-timestring nil ,start :format ',(%unit-format unit))
                   ,message)
       (unwind-protect ,body
         (let ((,end (now)))
           (format *trace-output*
                   "~a ~a end~%"
                   (format-timestring nil ,end :format ',(%unit-format unit))
                   ,message))))))

(defun debug-time-reader (stream char)
  (declare (ignore char))
  (let ((name (read stream t nil t)))
    (case name
      ('measure-time
       (let ((args (read stream t nil t))
             (body (read stream t nil t)))
         (macroexpand-1 `(with-measure-time ,args
                           ,(macroexpand-1 body)))))
       ('timestamp
        (let ((unit (read stream t nil t))
              (message (read stream t nil t))
              (body (read stream t nil t)))
          (macroexpand-1 `(with-timestamp ,unit ,message
                            ,(macroexpand-1 body))))))))

;(setf *readtable* (copy-readtable))
;(set-macro-character #\@ #'debug-time-reader)

(defmacro enable-annotation ()
  (eval-when (:compile-toplevel :load-toplevel :execute)
    (setf *readtable* (copy-readtable))
    (set-macro-character #\@ #'cl-debug-time:debug-time-reader)))
