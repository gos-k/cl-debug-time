(defpackage cl-debug-time
  (:use :cl)
  (:import-from #:alexandria
                #:with-gensyms)
  (:import-from #:cl-annot
                #:defannotation)
  (:import-from #:local-time
                #:now
                #:timestamp-difference)
  (:export :measure-time))
(in-package :cl-debug-time)

(defun %second-per-unit (unit)
  (ecase unit
    ((or :h :hour) (/ 1.0 3600.0))
    ((or :m :min :minute) (/ 1.0 60.0))
    ((or :s :sec :second) 1.0)
    ((or :ms :msec :millisecond) 1000.0)
    ((or :us :usec :microsecond) 1000000.0)))

(defannotation measure-time (unit body)
  (:arity 2 :inline t)
  (with-gensyms (start end)
    `(let ((,start (now)))
       (unwind-protect (progn ,body)
         (let ((,end (now)))
           (format *trace-output*
                   "~,3f [~a]~%"
                   (* ,(%second-per-unit unit)
                      (timestamp-difference ,end ,start))
                   ,(string-downcase unit)))))))
