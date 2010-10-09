;;; -*- encoding:utf-8 Mode: LISP; Syntax: COMMON-LISP; Base: 10  -*-  --- 
;; 
;; Filename: utils.lisp
;; Description: utilities.
;; Author: Xu Jingtao
;; Created: 2010.10. 9 13:22:52(+0800)
;; Last-Updated: 2010.10. 9 13:26:16(+0800)
;;     Update #: 3
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(in-package :crx)

(defvar *temp-files* nil
  "A list of temporary files which should be deleted when the
image exits.")

;; make sure temp files are deleted when the image exits
#+lispworks
(lw:define-action "When quitting image" "Delete temp files"
  (lambda ()
    (loop for file in *temp-files*
       do (ignore-errors (delete-file file)))))
#+lispworks
(defun make-temp-file (&key dir prefix suffix)
  "make a temporary file name"
  (let ((path (sys:make-temp-file dir suffix)))
    (if prefix
      (make-pathname :host (pathname-host path)
                     :device (pathname-device path)
                     :directory (pathname-directory path)
                     :name (concatenate 'string prefix (pathname-name path))
                     :type (pathname-type path)
                     :version (pathname-version path))
      path)))
#+sbcl
(defun make-temp-file (&key dir prefix suffix)
  "make a temporary file name"
  (let ((path (tempnam dir prfeix)))
    (if suffix
      (make-pathname :host (pathname-host path)
                     :device (pathname-device path)
                     :directory (pathname-directory path)
                     :name (strcat (pathname-name path) "." suffix)
                     :type (pathname-type path)
                     :version (pathname-version path))
      path)))
#+ccl
(defun make-temp-file (&key dir prefix suffix)
 "make a temporary file name"
  (let ((path (ccl:temp-pathname)))
    (make-pathname :host (pathname-host path)
                   :device (pathname-device path)
                   :directory (if dir dir (pathname-directory path))
                   :name (strcat prefix (pathname-name path))
                   :type (if suffix suffix (pathname-type path))
                   :version (pathname-version path))
      path))

(defmacro with-open-temp-file ((stream-var suffix) &body body)
  "Creates a new temporary file with the suffix SUFFIX which will
be deleted when the image exits and returns the pathname of this
file.  If BODY is provided, the file is opened for writing and
BODY is executed with STREAM-VAR bound to the corresponding
output stream."
  (with-unique-names (temp-file)
    `(let ((,temp-file (make-temp-file :suffix ,suffix)))
       (push ,temp-file *temp-files*)
       ,@(and body
              `((with-open-file (,stream-var ,temp-file
                                             :direction :output
                                             :if-exists :supersede
                                             :element-type '(UNSIGNED-BYTE 8))
                 ,@body)))
       ,temp-file)))
(defun get-temp-file (&optional (suffix "tmp"))
  "Uses WITH-OPEN-TEMP-FILE to return a new temporary file with
the suffix SUFFIX."
  (with-open-temp-file (out suffix)))

(defun get-file-size (pathspec)
  (let ((file-size 0))
    (if (and pathspec
             (probe-file pathspec)
             (not (cl-fad:directory-exists-p pathspec)))
      (with-open-file (stream pathspec :direction :input 
                              :if-does-not-exist nil)
        (if stream 
          (setf file-size (file-length stream)))))
    file-size))

