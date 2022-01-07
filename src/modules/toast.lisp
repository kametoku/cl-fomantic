;;; Fomanti UI toast module

;; https://fomantic-ui.com/modules/toast.html
;; A toast allows users to be notified of an event

(in-package #:fomantic.modules)

(defun toast (&rest args &key message title show-progress class-progress
                           class position newest-on-top horizontal display-time
                           progress-up show-icon show-image class-image close-icon
                           compact)
  (declare (ignorable message title show-progress class-progress
                      class position newest-on-top horizontal display-time
                      progress-up show-icon show-image class-image close-icon
                      compact))
  (let ((parameters (make-init-parameter args)))
;;     (log:debug parameters)
    (funcall #'js-method nil 'toast parameters)))

(defun send-toast (&rest args)
  (weblocks/response:send-script
   (apply #'toast args)))
