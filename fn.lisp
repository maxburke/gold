(defparameter *fn-db* (list))

(defun compile-body (args body)
  
  )

(defmacro fn ((name &rest args) &body body)
  (let ((db (if (assoc name *fn-db*) (remove name *fn-db* :key #'car) *fn-db*))
        (setf *fn-db* (acons name compile-body) db)))
  )
