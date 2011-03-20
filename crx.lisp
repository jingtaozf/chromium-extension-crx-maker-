;;; -*- encoding:utf-8 Mode: LISP; Syntax: COMMON-LISP; Base: 10  -*-  --- 
;; 
;; Filename: crx.lisp
;; Description: crx(chrominum extention) packer tool
;; Author: Xu Jingtao
;; Created: 2010.09.23 15:47:53(+0800)
;; Last-Updated: 2011.03.20 16:55:02(+0800)
;;     Update #: 31
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(in-package :crx)
(export '(
          make-crx
          *crx-openssl*
          ) :crx)
(defvar *crx-openssl* "d:\\cygwin\\bin\\openssl.exe")

(defun write-dword (in stream)
  "write an unsigned integer(4 bytes) to stream"
  (write-byte (ldb (byte 8 0) in) stream)
  (write-byte (ldb (byte 8 8) in) stream)
  (write-byte (ldb (byte 8 16) in) stream)
  (write-byte (ldb (byte 8 24) in) stream))

(defun make-crx (root-dir files &key pem-file
                      ;;(manifest "manifest.json")
                      (dest-file (strcat root-dir ".crx")))
  (let* ((temp-zip (get-temp-file "zip"))
         (temp-zip.derkey (strcat temp-zip ".derkey"))
         (temp-zip.sign (strcat temp-zip ".sign")))
    (zip:with-output-to-zipfile (zip temp-zip :if-exists :overwrite :if-does-not-exist :create)
      (loop for file in files
         do (with-open-file (s (strcat root-dir "\\" file) :element-type '(unsigned-byte 8))
              (zip:write-zipentry zip file s))))
    (sys:call-system-showing-output (strcat *crx-openssl* " rsa -pubout -inform PEM -outform DER -in "
                                            pem-file " > \"" temp-zip.derkey "\"")
                                    :current-directory root-dir
                                    :wait t)
    (sys:call-system-showing-output (strcat *crx-openssl* " sha1 -sign " pem-file " \"" temp-zip "\""
                                            " > \"" temp-zip.sign "\"")
                                    :current-directory root-dir
                                    :wait t)
    (with-open-file (stream dest-file
                     :direction :output
                     :if-exists :supersede
                     :element-type '(unsigned-byte 8))
      (format stream "Cr24")
      (write-dword 2 stream);version
      (write-dword (get-file-size temp-zip.derkey) stream)
      (write-dword (get-file-size temp-zip.sign) stream)
      (let ((buf (make-array 8192 :element-type (stream-element-type stream))))
        (labels ((%write-file (path)
                   (with-open-file (in path
                                    :direction :input
                                    :element-type '(unsigned-byte 8))
                     (loop 
                        do (let ((pos (read-sequence buf in)))
                             (when (zerop pos)
                               (loop-finish))
                             (write-sequence buf stream :end pos))))))
          (%write-file temp-zip.derkey)
          (%write-file temp-zip.sign)
          (%write-file temp-zip))))
    (delete-file temp-zip)
    (delete-file temp-zip.derkey)
    (delete-file temp-zip.sign)))

