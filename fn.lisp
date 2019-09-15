(defparameter *fn-db* (list))

(defun compile-body (args body)
  
  )

(defmacro fn ((name &rest args) &body body)
  (let ((db (if (assoc name *fn-db*) (remove name *fn-db* :key #'car) *fn-db*))
        (setf *fn-db* (acons name compile-body) db)))
  )

(defun link ())

(defun emit-lx (name object-code)
  (with-open-file (out name :element-type '(unsigned-byte 8) :direction output)
    (write-byte (char-code #\M) out)
    (write-byte (char-code #\Z) out)))

