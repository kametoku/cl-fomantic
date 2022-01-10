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
                             (:file "modal")
                             (:file "dropdown")
                             (:file "selection-dropdown")
                             (:file "toast"))))
  :description "Tiny Common Lisp Wrapper for Fomantic-UI"
  :in-order-to ((test-op (test-op "cl-fomantic-test"))))

(defsystem "cl-fomantic-test"
  :defsystem-depends-on ("prove-asdf")
  :author "Tokuya Kameshima"
  :license ""
  :depends-on ("cl-fomantic"
               "prove")
  :components ((:module "tests"
                :components ((:test-file "cl-fomantic"))))
  :description "Test system for cl-fomantic"
  :perform (test-op (op c) (symbol-call :prove-asdf :run-test-system c)))
