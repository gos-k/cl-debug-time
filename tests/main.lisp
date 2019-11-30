(defpackage cl-debug-time/tests/main
  (:use :cl
        :cl-debug-time
        :rove))
(in-package :cl-debug-time/tests/main)

;; NOTE: To run this test file, execute `(asdf:test-system :cl-debug-time)' in your Lisp.

(deftest test-target-1
  (testing "should (= 1 1) to be true"
    (ok (= 1 1))))
