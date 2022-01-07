;;; Fomanti UI modal widget

;; https://fomantic-ui.com/modules/modal.html

(in-package #:fomantic.modules)

(defwidget modal-widget (module-widget)
  ())

(defmethod default-div-class ((widget modal-widget))
  "ui modal")

(defmethod init-method ((widget modal-widget))
  'modal)

(defun js-hide-modal (widget)
  (check-type widget modal-widget)
  (js-method widget 'modal "hide"))

(defun %js-show-modal (widget)
  (js-method widget 'modal "show"))

(defvar *js-show-modal* nil)

(defmethod js-show-modal ((widget modal-widget) &key action)
  "Return a JavaScript code to show the modal of WIDGET.
If ACTION is non-nil (a function), the modal is shown and the entire
page is locked so that any user operation on the page is blocked until
ACTION is completed."
  (let ((*js-show-modal* (%js-show-modal widget)))
    (if action
        (weblocks-parenscript:make-js-handler
         :lisp-code ((&rest args)
                     (unwind-protect
                          (handler-bind
                              ((error
                                 (lambda (condition)
                                   (declare (ignore condition))
                                   ;; Hide the modal on server side error.
                                   (weblocks/response:send-script
                                    (js-method widget 'modal "hide")))))
                            (apply action args))
                       (weblocks/response:send-script
                        '(screen-unlock))))
         :js-code ((event)
                   (ps:lisp *js-show-modal*)     ; XXX
                   (screen-lock)))
        (ps:ps
          (ps:lisp *js-show-modal*)))))

;; $(document.getElementById('dom109')).modal('hide');
