(in-package #:fomantic.modules)

(defwidget module-widget ()
  ((init-method :initarg :init-method
                :accessor init-method)
   (init-parameters :initarg :init-parameters
                    :initform nil
                    :accessor init-parameters)
   (div-class :accessor div-class)
   (inner :initarg :inner
          :initform nil
          :accessor inner)))

(defmethod default-div-class (widget)
  nil)

(defgeneric element-id (widget)
  (:documentation "Returns the element ID that the JavaScript
initialization method for the module will be invoked on."))

(defmethod element-id ((widget module-widget))
  (weblocks/widgets/dom:dom-id widget))

(defmethod initialize-instance :after ((widget module-widget)
                                       &key (class (default-div-class widget))
                                       &allow-other-keys)
  (check-type class (or string list))
  (setf (slot-value widget 'div-class)
        (if (stringp class)
            (mapcar #'tkutil:string-to-keyword
                    (ppcre:split " +" class))
            class)))

(defun js-get-document ()
  "Returns a parenscript code equivalent to: $(document)"
  `($ document))

(defun js-get-element-by-id (element-id)
  "Returns a parenscript code equivalent to:
$(document.getElementById(ELEMENT-ID))
If ELEMENT-ID is nil, it returns nil."
  (when element-id
    `($ (ps:chain document (get-element-by-id ,element-id)))))
  
(defun js-method (widget method &optional parameters)
  "Returns a parenscript code to call METHOD on the element of WIDGET
with PARAMETERS if WIDGET is non-nil.
If METHOD is nil, it returns a parenscript code to call METHOD on the
documeant element with PARAMETERS."
  (if widget
      ;; $(document.getElementById(ID)).METHOD(PARAMETERS);
      (let ((id (element-id widget)))
        `(ps:chain ,(js-get-element-by-id id) (,method ,parameters)))
      ;; $(document).METHOD(PARAMETERS);
      `(ps:chain ,(js-get-document) (,method ,parameters))))
      
(defun make-init-parameter (plist)
  ;; '(:foo "1" 'bar "2") -> '(ps:create foo "1" bar "2")
  `(ps:create ,@(loop for (key value) on plist by #'cddr
                      collect (intern (tkutil:keyword-to-string key))
                      collect value)))

(defmethod js-initialize-module ((widget module-widget))
  "Return a parenscript code to initialize the module on WIDGET."
  (let* ((init-method (init-method widget))
         (init-parameters (make-init-parameter (init-parameters widget))))
    (js-method widget init-method init-parameters)))

(defmethod weblocks/dependencies:get-dependencies ((widget module-widget))
  ;; $(function() {
  ;;   return $(document.getElementById('dom109')).XXX({flag : true});
  ;; });
  (let ((dependency
          (weblocks-parenscript:make-dependency
            ($ (lambda () (ps:lisp (js-initialize-module widget)))))))
    (append (list dependency)
            (call-next-method))))

(defmethod weblocks/widget:render ((widget module-widget))
  (let ((inner (inner widget)))
    (cond ((null inner))
          ((functionp inner)
           (with-html
             (funcall inner widget)))
          (t (render inner)))))

(defmethod weblocks/widget:get-css-classes ((widget module-widget))
  (nconc (div-class widget) (call-next-method)))

(defun make-module-widget (class init-method &rest init-parameters)
  (make-instance 'module-widget :class class :init-method init-method
                                :init-parameters init-parameters))

(defmacro with-module-widget (widget-class (widget &rest args &key class initialize
                                            &allow-other-keys)
                              &body body)
  "(with-module-widget widget-class (widget-var class initizlize other-key*) form*)
initialize ::= (init-method init-parameters)
init-parameters ::= {key value}*"
  (declare (ignore class))
  (remf args :class)
  (remf args :initialize)
  `(let ((,widget (make-instance ,widget-class
                                 :init-method (quote ,(car initialize))
                                 :init-parameters (list ,@(cdr initialize))
                                 ,@args)))
     (setf (inner ,widget) (lambda (widget) (progn ,@body)))
     (weblocks/widget:render ,widget)))

#|
(fomantic.modules:with-module-widget 'fomantic.dropdown:dropdown-widget
    (widget :class "ui search selection module"
            :initialize (dropdown :clearable t))
  (:input :type "hidden" :name "country")
  (:i :class "module icon")
  (:div :class "default text" "Select Country")
  (:div :class "menu"
        (:div :class "item" :data-value "af" (:i :class "af flag") "Afghanistan")
        (:div :class "item" :data-value "ax" (:i :class "ax flag") "Aland Islands")
        (:div :class "item" :data-value "al" (:i :class "al flag") "Albania")
        (:div :class "item" :data-value "dz" (:i :class "dz flag") "Algeria")
        (:div :class "item" :data-value "as" (:i :class "as flag") "American Samoa")
        (:div :class "item" :data-value "ad" (:i :class "ad flag") "Andorra")))

(ui.modules:with-module-widget 'fomantic.dropdown:dropdown-widget
    (widget :class "ui multiple selection module"
            :initialize (dropdown 'clearable t))
  (:input :name "gender" :type "hidden" :value "0,1")
  (:i :class "module icon")
  (:div :class "default text" "Default")
  (:div :class "menu"
        (:div :class "item" :data-value "0" "Value")
        (:div :class "item" :data-value "1" "Another Value")))
|#
