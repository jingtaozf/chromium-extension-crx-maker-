;;;; -*- encoding:utf-8; Mode: Lisp; Syntax: ANSI-Common-Lisp; Base: 10 -*-
;; 
;; Filename: crx.asd
;; Description: asd definition.
;; Author: Xu Jingtao
;; Created: 2010.09.14 13:00:36(+0800)
;; Last-Updated: 2010.09.23 22:50:42(+0800)
;;     Update #: 5
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(eval-when (:compile-toplevel :load-toplevel :execute)
  (unless (find-package :crx.system)
    (defpackage :crx.system
      (:use :cl))))
(in-package :crx.system)

(asdf:defsystem crx
  :author "Xu Jingtao <jingtaozf@gmail.com>"
  :version "0.1"
  :serial t
  :description "crx(chrominum extention) packer tool in common lisp "
  :components ((:module basics :pathname "./"
						:components ((:file "package")
                                     (:file "crx"))
                        :serial t))
  :properties ((version "0.1"))
  :depends-on (:arnesi :xjt-utils :zip))

