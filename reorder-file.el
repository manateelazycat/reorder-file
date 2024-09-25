;;; reorder-file.el --- Reorder file base on cloel   -*- lexical-binding: t; -*-

;; Filename: reorder-file.el
;; Description: Reorder file base on cloel
;; Author: Andy Stewart <lazycat.manatee@gmail.com>
;; Maintainer: Andy Stewart <lazycat.manatee@gmail.com>
;; Copyright (C) 2024, Andy Stewart, all rights reserved.
;; Created: 2024-09-22 17:01:37
;; Version: 0.1
;; Last-Updated: 2024-09-22 17:01:37
;;           By: Andy Stewart
;; URL: https://www.github.org/manateelazycat/reorder-file
;; Keywords:
;; Compatibility: GNU Emacs 31.0.50
;;
;; Features that might be required by this library:
;;
;;
;;

;;; This file is NOT part of GNU Emacs

;;; License
;;
;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 3, or (at your option)
;; any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program; see the file COPYING.  If not, write to
;; the Free Software Foundation, Inc., 51 Franklin Street, Fifth
;; Floor, Boston, MA 02110-1301, USA.

;;; Commentary:
;;
;; Reorder file base on cloel
;;

;;; Installation:
;;
;; Put reorder-file.el to your load-path.
;; The load-path is usually ~/elisp/.
;; It's set in your ~/.emacs like this:
;; (add-to-list 'load-path (expand-file-name "~/elisp"))
;;
;; And the following to your ~/.emacs startup file.
;;
;; (require 'reorder-file)
;;
;; No need more.

;;; Customize:
;;
;;
;;
;; All of the above can customize by:
;;      M-x customize-group RET reorder-file RET
;;

;;; Change log:
;;
;; 2024/09/22
;;      * First released.
;;

;;; Acknowledgements:
;;
;;
;;

;;; TODO
;;
;;
;;

;;; Require
(require 'cloel)


;;; Code:
(defvar reorder-file-clj-project (file-name-directory load-file-name))

(cloel-register-app "reorder-file" reorder-file-clj-project "run-by-cloel")

(defun reorder-file-start-process-confirm (client-id)
  "Confirm process start and send reorder request."
  (message "Reorder file process started: %s" client-id)
  (reorder-file-send-request))

(defun reorder-file-send-request ()
  "Send reorder request to Clojure process."
  (let ((buffer-content (buffer-string)))
    (cloel-reorder-file-call-async "reorderfile/reorder-buffer" buffer-content)))

;;;###autoload
(defun reorder-file ()
  "Reorder the numbered lines in the current buffer."
  (interactive)
  (let* ((app-data (cloel-get-app-data "reorder-file"))
         (server-process (plist-get app-data :server-process)))
    (if (and server-process (process-live-p server-process))
        (reorder-file-send-request)
      (message "Starting reorder-file process...")
      (cloel-reorder-file-start-process)
      (message "Waiting for process to start..."))))

(defun reorder-file-confirm-replace (reordered-content)
  "Confirm with the user whether to replace the buffer content."
  (when (yes-or-no-p "Replace buffer content with reordered text? ")
    (with-current-buffer (current-buffer)
      (erase-buffer)
      (insert reordered-content)
      (goto-char (point-min)))
    (switch-to-buffer (current-buffer))
    (message "Buffer content has been replaced with reordered text.")))

(defun reorder-file-start ()
  "Start the reorder-file process."
  (interactive)
  (cloel-reorder-file-start-process))

(provide 'reorder-file)
;;; reorder-file.el ends here
