(defparameter *fn-db* (list))

(defun compile-body (args body)
  
  )

(defmacro fn! ((name &rest args) &body body)
  (let ((db (if (assoc name *fn-db*) (remove name *fn-db* :key #'car) *fn-db*))
        (setf *fn-db* (acons name compile-body) db))))

(defun link ())

(defun write-zeros (num s)
  (loop for i from 1 to num do (write-byte 0 s)))

(defun write-word (num s)
  (write-byte (logand num #xff) s)
  (write-byte (logand (ash num -8) #xff) s))

(defun write-dword (num s)
  (write-byte (logand num #xff) s)
  (write-byte (logand (ash num -8) #xff) s) 
  (write-byte (logand (ash num -16) #xff) s) 
  (write-byte (logand (ash num -24) #xff) s))

(defun write-chars (chars s)
  (dolist (c chars)
    (write-byte (char-code c) s)))

(defun emit-lx (name obj)
  (with-open-file (out name :element-type '(unsigned-byte 8) :direction :output :if-exists :overwrite)
    ;; MZ header
    (write-chars '(#\M #\Z) out)
    (write-zeros 22 out)
    (write-word #x40 out)
    (write-zeros 34 out)
    (write-dword #x40 out) ; LX header offset in bytes (DWORD)
    ;; LX header
    (write-chars '(#\L #\X) out)
    (write-byte 0 out) ; db - little endian byte order
    (write-byte 0 out) ; db - little endian word order
    (write-dword 0 out) ; dd - format level
    (write-word 2 out) ; dw - 386 or greater
    (write-word 3 out) ; dw - DOS 4.x or greater
    (write-dword 0 out) ; db - module version
    (write-dword #x10 out) ; dd - module flag bits (0x10 == relocations have been applied)
    (write-dword 0 out) ; TODO dd - number of pages in module
    (write-dword 0 out) ; TODO dd - EIP object #
    (write-dword 0 out) ; TODO dd - entry address of module
    (write-dword 0 out) ; TODO dd - ESP object #
    (write-dword 0 out) ; TODO dd - starting stack address of module
    (write-dword 4096 out) ; dd - page size of module in bytes
    (write-dword 12 out) ; dd - shift left for page offsets (default 12)
    (write-dword 0 out) ; TODO dd - fixup section size
    (write-dword 0 out) ; TODO dd - fixup section checksum
    (write-dword 0 out) ; TODO dd - loader section size
    (write-dword 0 out) ; TODO dd - loader section checksum
    (write-dword 0 out) ; TODO dd - object table offset (relative to beginning of LX header)
    (write-dword 0 out) ; TODO dd - number of objects in module
    (write-dword 0 out) ; TODO dd - object page table offset (relative to LX header)
    (write-dword 0 out) ; dd - object iter pages offset
    (write-dword 0 out) ; dd - resource table offset
    (write-dword 0 out) ; dd - # resource table entries
    (write-dword 0 out) ; dd - resident name table offset
    (write-dword 0 out) ; TODO dd - entry table offset
    (write-dword 0 out) ; dd - module directives offset
    (write-dword 0 out) ; dd - # module directives
    (write-dword 0 out) ; TODO dd - fixup page table offset
    (write-dword 0 out) ; TODO dd - fixup record table offset
    (write-dword 0 out) ; dd - import module table offset
    (write-dword 0 out) ; dd - # import module entries
    (write-dword 0 out) ; dd - import proc table offset
    (write-dword 0 out) ; TODO dd - per page checksum offset
    (write-dword 0 out) ; TODO dd - data pages offset
    (write-dword 0 out) ; TODO dd - # preload pages 
    (write-dword 0 out) ; TODO dd - non resident name table offset
    (write-dword 0 out) ; TODO dd - non-resident name table length
    (write-dword 0 out) ; TODO dd - auto ds object # 
    (write-dword 0 out) ; dd - debug info offset
    (write-dword 0 out) ; dd - debug info length
    (write-dword 0 out) ; TODO dd - # instance data pages in preload
    (write-dword 0 out) ; dd - # instance data pages on demand
    (write-dword 0 out) ; TODO dd - heapsize added to auto DS object
    
    ;;
    ))

(fn! (main ())
     (mov eax 1)
     (ret))

(emit-lx "test.exe" nil)
