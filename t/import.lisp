(in-package :jsc-tests)

(def-suite :jsc-import)
(in-suite :jsc-import)

(test ast-import-name
  (let ((tst (jsc:ast-from-string "import a from \"test\";")))
    (is (equal tst `((:import ((:ident "a"))
                              (:str "test")))))))

(test ast-import-object
  (let ((tst (jsc:ast-from-string "import { a } from \"test\";")))
    (is (equal tst `((:import ((:obj (((:ident "a") :scoped-var))))
                              (:str "test")))))))

(test ast-import-mixed-name-and-object
  (let ((tst (jsc:ast-from-string "import a, { b } from \"test\";")))
    (is (equal tst `((:import ((:ident "a")
                               (:obj (((:ident "b") :scoped-var))))
                              (:str "test")))))))

(test ast-import-mixed-object-and-name
  (let ((tst (jsc:ast-from-string "import { a }, b from \"test\";")))
    (is (equal tst `((:import ((:obj (((:ident "a") :scoped-var)))
                               (:ident "b"))
                              (:str "test")))))))

(test ast-import-just-include
  (let ((tst (jsc:ast-from-string "import \"test\";")))
    (is (equal tst `((:import-file (:str "test")))))))

(test ast-import-glob
  (let ((tst (jsc:ast-from-string "import * as a from \"test\";")))
    (is (equal tst `((:import ((:glob "a")) (:str "test")))))))

(test ast-import-mixed-glob-and-default
  (let ((tst (jsc:ast-from-string "import * as a, b from \"test\";")))
    (is (equal tst `((:import ((:glob "a") (:ident "b")) (:str "test")))))))

(test ast-import-mixed-default-and-glob
  (let ((tst (jsc:ast-from-string "import  a, * as b from \"test\";")))
    (is (equal tst `((:import ((:ident "a") (:glob "b")) (:str "test")))))))
