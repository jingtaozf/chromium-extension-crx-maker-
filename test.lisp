;;; -*- encoding:utf-8 Mode: LISP; Syntax: COMMON-LISP; Base: 10  -*-  --- 
;; 
;; Filename: test.lisp
;; Description: test codes of crx.lisp
;; Author: Xu Jingtao
;; Created: 2010.09.23 19:51:02(+0800)
;; Last-Updated: 2010.09.23 23:12:50(+0800)
;;     Update #: 7
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(in-package :crx)

(5am:def-suite crx-suite :description "The test suite of crx utils.")
(5am:in-suite crx-suite)

(defun test-crx ()
  (let ((root (namestring 
               (make-pathname :name "test" :type nil :version nil
                              :defaults (asdf:component-pathname (asdf:find-system "crx"))))))
    (make-crx root '("manifest.json" "bho.js")
              :pem-file "test.pem")))

