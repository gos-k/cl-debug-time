(defpackage cl-debug-time
  (:use :cl)
  (:import-from #:cl-annot
                #:defannotation)
  (:export :measure-time
           :timestamp))
(in-package :cl-debug-time)

(defannotation measure-time (args body)
  (:arity 2 :inline t)
  `(with-measure-time ,args
     ,body))

(defannotation timestamp (unit message body)
  (:arity 3 :inline t)
  `(with-timestamp ,unit ,message
     ,body))
