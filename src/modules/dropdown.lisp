;;; Fomantic UI dropdown module widget

;; https://fomantic-ui.com/modules/dropdown.html

(in-package #:fomantic.modules)

(defwidget dropdown-widget (module-widget)
  ())

(defmethod default-div-class ((widget dropdown-widget))
  "ui dropdown")

(defmethod init-method ((widget dropdown-widget))
  'dropdown)

(defun make-dropdown-widget (&rest parameters &key (class "ui dropdown")
                             &allow-other-keys)
  (remf parameters :class)
  (make-instance 'dropdown-widget :class class :init-method 'dropdown
                 :parameters parameters))

(defmacro with-dropdown-widget ((widget &rest parameters
                                 &key (class "ui dropdown") &allow-other-keys)
                                &body body)
  "(with-dropdown-widget (widget-var :class class parameters*) body)
parameters :: {key value}"
  (remf parameters :class)
  `(with-module-widget 'dropdown-widget
       (,widget :class ,class :initialize (dropdown ,@parameters))
     ,@body))

#|
(ui.modules:with-dropdown-widget
    (widget :class "ui search selection dropdown" 'clearable t)
  (:input :type "hidden" :name "country")
  (:div :class "default text" "Select Country")
  (:i :class "dropdown icon")
  (:div :class "menu"
        (:div :class "item" :data-value "af" (:i :class "af flag") "Afghanistan")
        (:div :class "item" :data-value "ax" (:i :class "ax flag") "Aland Islands")
        (:div :class "item" :data-value "al" (:i :class "al flag") "Albania")
        (:div :class "item" :data-value "dz" (:i :class "dz flag") "Algeria")
        (:div :class "item" :data-value "as" (:i :class "as flag") "American Samoa")
        (:div :class "item" :data-value "ad" (:i :class "ad flag") "Andorra")))

(ui.modules:with-dropdown-widget
    (widget :class "ui multiple selection dropdown"
            'clearable t)
  (:input :name "gender" :type "hidden" :value "0,1")
  (:i :class "dropdown icon")
  (:div :class "default text" "Default")
  (:div :class "menu"
        (:div :class "item" :data-value "0" "Value")
        (:div :class "item" :data-value "1" "Another Value")))
|#
