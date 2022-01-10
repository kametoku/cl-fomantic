(in-package #:fomantic.modules)

(defwidget checkbox-widget ()
  ((name :initarg :name :initform nil :reader name)
   (value :initarg :value :initform nil :accessor value)
   (read-only :initarg :read-only :initform nil :reader read-only)))

(defmethod toggle ((widget checkbox-widget))
  (setf (value widget) (not (value widget)))
  (update widget))

(defmethod render ((widget checkbox-widget))
  (let ((name (name widget))
        (value (value widget))
        (read-only (read-only widget)))
    (with-html
      (:div :class "ui toggle checkbox"
            (:input :type "checkbox" :name name :checked value
                    :onclick (reblocks/actions:make-js-action
                              (lambda (&key &allow-other-keys)
                                (toggle widget)))
                    :value "1" :id name :disabled read-only)
            (:label "")))))

(defun make-checkbox-widget (&rest args &key name value read-only)
  (declare (ignore name value read-only))
  (apply #'make-instance 'checkbox-widget args))
