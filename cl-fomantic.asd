(defsystem "cl-fomantic"
  :version "0.1.0"
  :author "Tokuya Kameshima"
  :license "LLGPL"
  :depends-on ("alexandria"
               "cl-ppcre"
               "reblocks"
               "reblocks-lass"
               "reblocks-parenscript"
               "reblocks-ui"

               "tkutil"           ; https://github.com/kametoku/tkutil
               )
  :pathname "src"
  :components ((:module "modules"
                :components ((:file "package")
                             (:file "module")
                             (:file "calendar")
                             (:file "checkbox")
                             (:file "modal")
                             (:file "dropdown")
                             (:file "selection-dropdown")
                             (:file "toast"))))
  :description "Tiny Common Lisp Wrapper for Fomantic-UI"
  :in-order-to ((test-op (test-op "cl-fomantic/test"))))

(defsystem "cl-fomantic/tests"
  :author ""
  :license ""
  :depends-on ("cl-fomantic"
               "rove")
  :components ((:module "tests"
                :components
                ((:file "cl-fomantic"))))
  :description "Test system for cl-fomantic"
  :perform (test-op (op c) (symbol-call :rove :run c)))
