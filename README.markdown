# cl-debug-time - time measurement library for performance bug

cl-debug-time is a time measurement library for Common Lisp.
If you add an annotation before a code with performance bug, you can get the execution time to *trace-output*.

## Usage

1. import cl-debug-time
2. execute enable-annotation
3. add annotation to target code

```lisp
(defpackage dummy-package
  (:use :cl)
  (:import-from #:cl-debug-time
                #:measure-time
                #:enable-annotation))
(in-package :dummy-package)

(enable-annotation)

(defun dummy-function (x y)
  @measure-time :us
  (+ x y))
```

with message.

```
(defun dummy-function2 (x y)
  @measure-time ("dummy message" :us)
  (+ x y))
```

## Installation

### Roswell

```
ros install gos-k/cl-debug-time
```

## Author

* gos-k

## Copyright

Copyright (c) 2019 gos-k

## License

Licensed under the MIT License.
