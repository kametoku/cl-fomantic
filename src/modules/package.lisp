(in-package #:cl-user)

(defpackage #:fomantic.modules
  (:use #:cl)
  (:nicknames #:fui.modules)
  (:import-from #:weblocks/widget
                #:defwidget
                #:render
                #:update)
  (:import-from #:weblocks/html
                #:with-html)
  (:export #:module-widget
           #:element-id
           #:default-div-class
           #:init-method
           #:init-parameters
           #:js-get-document
           #:js-get-element-by-id
           #:js-method
           #:make-module-widget
           #:with-module-widget
   
           ;; calendar module
           #:calendar-widget
           #:make-calendar-widget

           ;; dropdown widget
           #:dropdown-widget
           #:with-dropdown-widget

           ;; selection dropdown widget
           #:selection-dropdown-widget
           #:name
           #:value
           #:dropdown-item-name
           #:dropdown-item-value
           #:render-dropdown-items
           #:make-selection-dropdown-widget
           #:with-selection-dropdown-widget

           ;; modal widget
           #:modal-widget
           #:on-show
           #:on-visible
           #:on-hidden
           #:on-approve
           #:on-deny
           #:js-show-modal
           #:js-hide-modal

           ;; toast module
           #:toast
           #:send-toast
))
