(defsystem "cl-debug-time"
  :version "0.1.0"
  :author "gos-k"
  :license "MIT"
  :depends-on ("local-time"
               "cl-annot")
  :components ((:module "src"
                :components
                ((:file "main"))))
  :description "time measurement library for performance bug"
  :in-order-to ((test-op (test-op "cl-debug-time/tests"))))

(defsystem "cl-debug-time/tests"
  :author "gos-k"
  :license "MIT"
  :depends-on ("cl-debug-time"
               "rove")
  :components ((:module "tests"
                :components
                ((:file "main"))))
  :description "Test system for cl-debug-time"
  :perform (test-op (op c) (symbol-call :rove :run c)))
