;;; Fomantic UI dropdown module widget

;; https://fomantic-ui.com/modules/calendar.html

(in-package #:fomantic.modules)

(defwidget calendar-widget (module-widget)
  ;; type ::= "datetime" | "date" | "time" | "month" | "year"
  ((type :initarg :type :initform "date" :reader calendar-type)
   (value :initarg :value :initform nil :accessor value)
   (required :initarg :required :initform nil :accessor required)
   (start-calendar-name :initarg :start-calendar-name
                        :initform nil
                        :reader start-calendar-name)
   (end-calendar-name :initarg :end-calendar-name
                      :initform nil
                      :reader end-calendar-name)
   (action :initarg :action :initform nil :reader action)
   (placeholder :initarg :placeholder :initform "Date" :reader placeholder)
   (icon :initarg :icon :initform "calendar icon" :reader icon)))

(defmethod default-div-class ((widget calendar-widget))
  "ui calendar")

(defmethod init-method ((widget calendar-widget))
  'calendar)

(defmethod init-parameters ((widget calendar-widget))
  ;; https://fomantic-ui.com/modules/calendar.html#/settings
  (list 'type (calendar-type widget)
        'initial-date (value widget)
        'start-calendar (js-get-element-by-id (start-calendar-name widget))
        'end-calendar (js-get-element-by-id (end-calendar-name widget))
        'formatter '(ps:create
                     date (lambda (date)
                            (let ((day (ps:chain
                                        (+ "0" (ps:chain date (get-date)))
                                        (slice -2)))
                                  (month (ps:chain
                                          (+ "0" (1+ (ps:chain date (get-month))))
                                          (slice -2)))
                                  (year (ps:chain
                                         date (get-full-year))))
                              (+ year "-" month "-" day))))))

(defmethod name ((widget calendar-widget))
  (reblocks/widgets/dom:dom-id widget))

(defmethod onchange ((widget calendar-widget) &key value)
  (setf (value widget) value))

(defmethod reblocks/widget:render ((widget calendar-widget))
  (with-html
    ;; <div class="ui calendar" ... </div>
    (:div :class "ui input left icon"
          (:i :class "calendar icon")
          (:input :type "text"
                  :name (name widget)
                  :value (value widget)
                  :required (required widget)
                  :onchange (reblocks-parenscript:make-js-handler
                             :lisp-code ((&key value &allow-other-keys)
                                         (onchange widget :value value))
                             :js-code ((event)
                                       (ps:create :value (ps:@ event target value))))
                  :autocomplete "off"
                  :placeholder (placeholder widget)))))

(defun make-calendar-widget (&rest args
                             &key name type value required start-calendar-name
                               end-calendar-name action placeholder icon)
  (declare (ignore type value required start-calendar-name
                   end-calendar-name action placeholder icon))
  (apply #'make-instance 'calendar-widget :dom-id name args))
