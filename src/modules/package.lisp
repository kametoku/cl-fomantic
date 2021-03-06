(in-package #:cl-user)

(defpackage #:fomantic.modules
  (:use #:cl)
  (:nicknames #:fui.modules)
  (:import-from #:reblocks/widget
                #:defwidget
                #:render
                #:update)
  (:import-from #:reblocks/html
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

           ;; checkbox widget
           #:checkbox-widget
;;            #:name
;;            #:value
           #:make-checkbox-widget

           ;; toast module
           #:toast
           #:send-toast
))
