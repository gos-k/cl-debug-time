(defpackage cl-debug-time/tests/main
  (:use :cl
        :cl-debug-time
        :rove)
  (:import-from #:cl-annot
                #:enable-annot-syntax))
(in-package :cl-debug-time/tests/main)

(enable-annot-syntax)

(deftest test-target-1
  (testing "hour"
    @measure-time :h
    (testing "should (= 1 1) to be true"
      (sleep 3.6)
      (ok (= 1 1)))
    @measure-time :hour
    (testing "should (= 1 1) to be true"
      (sleep 3.6)
      (ok (= 1 1))))

  (testing "minute"
    @measure-time :m
    (testing "should (= 1 1) to be true"
      (sleep 3)
      (ok (= 1 1)))
    @measure-time :min
    (testing "should (= 1 1) to be true"
      (sleep 3)
      (ok (= 1 1)))
    @measure-time :minute
    (testing "should (= 1 1) to be true"
      (sleep 3)
      (ok (= 1 1))))

  (testing "second"
    @measure-time :s
    (testing "should (= 1 1) to be true"
      (ok (= 1 1)))
    @measure-time :sec
    (testing "should (= 1 1) to be true"
      (ok (= 1 1)))
    @measure-time :second
    (testing "should (= 1 1) to be true"
      (ok (= 1 1))))

  (testing "millisecond"
    @measure-time :ms
    (testing "should (= 1 1) to be true"
      (ok (= 1 1)))
    @measure-time :msec
    (testing "should (= 1 1) to be true"
      (ok (= 1 1)))
    @measure-time :millisecond
    (testing "should (= 1 1) to be true"
      (ok (= 1 1))))

  (testing "microsecond"
    @measure-time :us
    (testing "should (= 1 1) to be true"
      (ok (= 1 1)))
    @measure-time :usec
    (testing "should (= 1 1) to be true"
      (ok (= 1 1)))
    @measure-time :microsecond
    (testing "should (= 1 1) to be true"
      (ok (= 1 1)))))
