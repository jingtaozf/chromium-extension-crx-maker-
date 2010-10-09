;;; -*- encoding:utf-8 Mode: LISP; Syntax: COMMON-LISP; Base: 10  -*-
;; 
;; Filename: package.lisp
;; Description: package definition.
;; Author: Xu Jingtao
;; Created: 2010.09.14 23:00:36(+0800)
;; Last-Updated: 2010.09.23 16:02:47(+0800)
;;     Update #: 8
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(in-package :common-lisp-user)
(defpackage :crx 
  (:use :cl :arnesi :xjt-utils)
  (:shadow #:error #:sleep)
  (:documentation "crx(chrominum extention) packer tool in common lisp"))
