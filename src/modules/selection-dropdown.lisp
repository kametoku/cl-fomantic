;;; Fomantic UI dropdown module widget - selection dropdown

;; https://fomantic-ui.com/modules/dropdown.html

(in-package #:fomantic.modules)

(defwidget selection-dropdown-widget (dropdown-widget)
  ((name :initarg :name :initform nil :accessor name)
   (value :initarg :value :initform nil :accessor value)
   (placeholder :initarg :placeholder :initform nil :accessor placeholder)
   (dropdown-items :initform nil :accessor dropdown-items)))

(defmethod dropdown-item-name (dropdown-item)
  dropdown-item)

(defmethod dropdown-item-value (dropdown-item)
  dropdown-item)

(defun ensure-value-key (value)
  (tkutil:ensure-keyword value))

(defmethod initialize-instance :after ((widget selection-dropdown-widget)
                                       &key dropdown-items &allow-other-keys)
  (when dropdown-items
    (setf (slot-value widget 'dropdown-items)
          (loop for item in dropdown-items
                for value-key = (ensure-value-key (dropdown-item-value item))
                for name = (dropdown-item-name item)
                collect (list value-key name item)))))

(defmethod default-div-class ((widget selection-dropdown-widget))
  "ui selection dropdown")

(defmethod init-method ((widget selection-dropdown-widget))
  'dropdown)

(defmethod onchange ((widget selection-dropdown-widget) &key value)
  (let* ((value-key (ensure-value-key value))
         (dropdown-item (nth 2 (assoc value-key (dropdown-items widget)))))
    (when dropdown-item
      (setf (value widget) dropdown-item))))

(defmethod render-dropdown-items ((widget selection-dropdown-widget))
  (with-html
    (:div :class "menu"
          (loop for dropdown-item in (dropdown-items widget)
                for value-key = (nth 0 dropdown-item)
                for name = (nth 1 dropdown-item)
                do (:div :class "item" :data-value value-key name)))))

(defmethod render ((widget selection-dropdown-widget))
  (with-html
    (:input :type "hidden" :name (name widget)
            :value (ensure-value-key (dropdown-item-value (value widget)))
            :onchange (reblocks-parenscript:make-js-handler
                       :lisp-code ((&key value &allow-other-keys)
                                   (onchange widget :value value))
                       :js-code ((event)
                                 (ps:create :value (ps:@ event target value)))))
    (:div :class "default text" (placeholder widget))
    (:i :class "dropdown icon")
    (render-dropdown-items widget)))

(defun make-selection-dropdown-widget (&rest parameters
                                       &key (class "ui selection dropdown")
                                         name value placeholder dropdown-items
                                       &allow-other-keys)
  (setf parameters
        (alexandria:remove-from-plist
         parameters :class :name :value :placeholder :dropdown-items))
  (make-instance 'selection-dropdown-widget
                 :class class :init-method 'dropdown
                 :name name :value value :placeholder placeholder
                 :dropdown-items dropdown-items
                 :init-method 'dropdown
                 :init-parameters parameters))

(defmacro with-selection-dropdown-widget ((widget &rest parameters
                                           &key (class "ui selection dropdown")
                                             name value placeholder dropdown-items
                                           &allow-other-keys)
                                          &body body)
  "(with-selection-dropdown-widget (widget-var :class class parameters*) body)
parameters :: {key value}"
  (setf parameters
        (alexandria:remove-from-plist
         parameters :class :name :value :placeholder :dropdown-items))
  `(with-module-widget 'selection-dropdown-widget
       (,widget :class ,class :initialize (dropdown ,@parameters)
                :name ,name :value ,value :placeholder ,placeholder
                :dropdown-items ,dropdown-items
                :inner #'render-dropdown-items)
     ,@body))
