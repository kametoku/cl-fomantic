;;; Fomanti UI toast module

;; https://fomantic-ui.com/modules/toast.html
;; A toast allows users to be notified of an event

(in-package #:fomantic.modules)

(defun toast (&rest args &key message raw-p title show-progress class-progress
                           class position newest-on-top horizontal display-time
                           progress-up show-icon show-image class-image close-icon
                           compact)
  (declare (ignorable title show-progress class-progress
                      class position newest-on-top horizontal display-time
                      progress-up show-icon show-image class-image close-icon
                      compact))
  (setf (getf args :message)
        (if raw-p message (spinneret::escape-to-string message)))
  (remf args :raw-p)
  (let ((parameters (make-init-parameter args)))
;;     (log:debug parameters)
    (funcall #'js-method nil 'toast parameters)))

(defun send-toast (&rest args)
  (reblocks/response:send-script
   (apply #'toast args)))
