(in-package :jsc-ast)

(defun string-to-stream (string)
  "Parse from a STRING."
  (make-string-input-stream string
                            0
                            (length string)))

(declaim (inline identifier-char-p))
(defun identifier-char-p (char)
  "CHAR is an identifier?"
  (alpha-char-p char))

(declaim (inline numberic-char-p))
(defun numeric-char-p (char)
  (and (char-not-lessp char #\0)
       (char-not-greaterp char #\9)))

(declaim (inline punctuation-char-p))
(defun punctuation-char-p (char)
  "Is CHAR is punctuation?"
  (find char "=-|$%^@<>.,;:+*&/\\"))

(declaim (inline group-char-p))
(defun group-char-p (char)
  "Is CHAR a group char?"
  (find char "()[]{}"))

(declaim (inline string-quote-p))
(defun string-quote-p (char)
  (find char (list #\" #\')))

;(declaim (inline read-until))
(defun read-until (stream type pred)
  "Read from STREAM a given TYPE until PRED terminates the reading."

  (let ((v (loop
              :for ch := (peek-char nil stream nil)
              :while (and ch (funcall pred ch))
              :collect (read-char stream nil nil))))
    (values type (concatenate 'string v))))

(defun read-string-until (stream char)
  "Read a string from STREAM until find CHAR to terminate."
  (read-char stream nil nil)
  (multiple-value-bind (ty token)
      (read-until stream
                  :str
                  #'(lambda (ch) (and ch (not (char-equal ch char)))))
    (progn
      (read-char stream nil nil)
      (values ty token))))

(defun read-punct (stream)
  "Read punctuation from a STREAM."
  (read-until stream
              :punct
              #'(lambda (ch) (and ch (punctuation-char-p ch)))))

(defun read-spaces (stream)
  "Read spaces from STREAM."
  (read-until stream
              :spc
              #'(lambda (ch) (and ch (char-equal ch #\space)))))

(defun read-identifier (stream)
  "Read identifier from STREAM."
  (read-until stream
              :ident
              #'(lambda (ch) (and ch (or (identifier-char-p ch)
                                         (find ch "_"))))))

(defun read-number (stream)
  (read-until stream
              :num
              #'(lambda (ch) (and ch (numeric-char-p ch)))))

(defun read-statement-by-char (stream char keep-space)
  "Read a statement from a STREAM by a CHAR."
  (cond
    ((char-equal char #\newline)
     (progn
       (read-char stream nil nil)
       (token-next stream)))
    ((string-quote-p char) (read-string-until stream char))
    ((group-char-p char) (values :grp (string (read-char stream nil nil))))
    ((punctuation-char-p char) (read-punct stream))
    ((char-equal char #\space)
     (if keep-space
         (read-spaces stream)
         (progn
           (read-spaces stream)
           (token-next stream))))
    ((identifier-char-p char) (read-identifier stream))
    ((numeric-char-p char) (read-number stream))
    (t (values nil nil))))

(defun token-expect-char (stream char)
  (let ((c (peek-char nil stream nil)))
    (if (and c (char-equal c #\SPACE))
        (progn
          (read-spaces stream)
          (token-expect-char stream char))
        (and c (char-equal c char)))))

(defun token-next (stream &optional (keep-space nil))
  "Parse from a STREAM."
  (let ((c (peek-char nil stream nil)))
    (when c
      (read-statement-by-char stream c keep-space))))

(defun token-ahead (stream &optional (keep-space nil))
  "Parse from a STREAM."
  (let ((c (peek-char nil stream nil)))
    (when 
        (read-statement-by-char stream c keep-space))))

(defun stop-when-char (token ch)
  (and token (not (string= ch token))))

(defun token-skip (stream char)
  (when (token-expect-char stream char)
    (token-next stream)))
