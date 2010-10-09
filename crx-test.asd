;;;; -*- encoding:utf-8; Mode: Lisp; Syntax: ANSI-Common-Lisp; Base: 10 -*-
;; 
;; Filename: crx.asd
;; Description: asd definition.
;; Author: Xu Jingtao
;; Created: 2010.09.14 13:00:36(+0800)
;; Last-Updated: 2010.09.23 19:52:33(+0800)
;;     Update #: 6
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(asdf:defsystem crx-test
  :author "Xu Jingtao <jingtaozf@gmail.com>"
  :version "0.1"
  :serial t
  :description "crx test codes in common lisp "
  :components ((:module test :pathname "./"
						:components ((:file "test"))
                        :serial t))
  :properties ((version "0.1"))
  :depends-on (:crx :fiveam))

