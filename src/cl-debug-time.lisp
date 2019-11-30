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

(defannotation measure-time (body)
  (:inline t)
  (with-gensyms (start end)
    `(let ((,start (now)))
       (unwind-protect (progn ,body)
         (let ((,end (now)))
           (format *trace-output*
                   "~,3f [ms]~%"
                   (* 1000.0 (timestamp-difference ,end ,start))))))))
