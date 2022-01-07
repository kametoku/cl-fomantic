;;; Fomantic UI dropdown module widget

;; https://fomantic-ui.com/modules/calendar.html

(in-package #:fomantic.modules)

(defwidget calendar-widget (module-widget)
  ;; type ::= "datetime" | "date" | "time" | "month" | "year"
  ((type :initarg :type
         :initform "date"
         :reader calendar-type)
   (initial-date :initarg :initial-date
                 :initform nil
                 :reader initial-date)
   (start-calendar-id :initarg :start-calendar-id
                      :initform nil
                      :reader start-calendar-id)
   (end-calendar-id :initarg :end-calendar-id
                    :initform nil
                    :reader end-calendar-id)
   (action :initarg :action
           :initform nil
           :reader action)
   (placeholder :initarg :placeholder
                :initform "Date"
                :reader placeholder)
   (icon :initarg :icon
         :initform "calendar icon"
         :reader icon)))

(defmethod default-div-class ((widget calendar-widget))
  "ui calendar")

(defmethod init-method ((widget calendar-widget))
  'calendar)

(defmethod init-parameters ((widget calendar-widget))
  ;; https://fomantic-ui.com/modules/calendar.html#/settings
  (list 'type (calendar-type widget)
        'initial-date (initial-date widget)
        'start-calendar (js-get-element-by-id (start-calendar-id widget))
        'end-calendar (js-get-element-by-id (end-calendar-id widget))
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
  
(defmethod weblocks/widget:render ((widget calendar-widget))
  (with-html
    ;; <div class="ui calendar" ... </div>
    (:div :class "ui input left icon"
          (:i :class "calendar icon")
          (:input :type "text"
                  :name (weblocks/widgets/dom:dom-id widget)
                  :value (initial-date widget)
                  :autocomplete "off"
                  :placeholder (placeholder widget)))))

(defun make-calendar-widget (&rest args
                             &key id type initial-date start-calendar-id
                               end-calendar-id action placeholder icon)
  (declare (ignore type initial-date start-calendar-id
                   end-calendar-id action placeholder icon))
  (apply #'make-instance 'calendar-widget :dom-id id args))
