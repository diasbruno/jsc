(in-package :jsc)

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
  (find char "=-|$%^@<>,;:+*&/\\"))

(declaim (inline group-char-p))
(defun group-char-p (char)
  "Is CHAR a group char?"
  (find char "()[]{}"))

(declaim (inline string-quote-p))
(defun string-quote-p (char)
  (find char (list #\" #\')))

(declaim (inline read-until))
(defun read-until (stream type pred)
  "Read from STREAM a given TYPE until PRED terminates the reading."
  `(,type ,(concatenate 'string
                        (loop
                           :for ch := (peek-char nil stream nil)
                           :while (and ch (funcall pred ch))
                           :collect (read-char stream nil nil)))))

(defun read-string-until (stream char)
  "Read a string from STREAM until find CHAR to terminate."
  (read-char stream nil nil)
  (prog1 (read-until stream
              :str
              #'(lambda (ch) (and ch (not (char-equal ch char)))))
      (read-char stream nil nil)))

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
    ((char-equal char #\newline) (progn
                                   (read-char stream nil nil)
                                   (js-token-next stream)))
    ((string-quote-p char) (read-string-until stream char))
    ((group-char-p char) `(:grp ,(string (read-char stream nil nil))))
    ((punctuation-char-p char) (read-punct stream))
    ((char-equal char #\space) (if keep-space
                                   (read-spaces stream)
                                   (progn
                                     (read-spaces stream)
                                     (js-token-next stream))))
    ((identifier-char-p char) (read-identifier stream))
    ((numeric-char-p char) (read-number stream))
    (t nil)))

(defun js-token-expect-char (stream char)
  (let ((c (peek-char nil stream nil)))
    (if (char-equal c #\SPACE)
        (progn
          (read-spaces stream)
          (js-token-expect-char stream char))
        (and c (char-equal c char)))))

(defun js-token-next (stream &optional (keep-space nil))
  "Parse from a STREAM."
  ;;(declare (optimize (speed 3)))
  (let ((c (peek-char nil stream nil)))
    (if c
        (read-statement-by-char stream c keep-space)
        nil)))

(defun js-stop-when-char (token char)
  (and token (not (string= char (cadr token)))))

(defun js-token-skip (stream char)
  (when (js-token-expect-char stream char)
    (js-token-next stream)))
