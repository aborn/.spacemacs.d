;;; local-config.el --- load some local config from local path.  -*- lexical-binding: t; -*-

;; Copyright (C) 2017 Aborn Jiang

;; Author: Aborn Jiang <aborn.jiang@gmail.com>
;; Version: 0.0.1    
;; Package-Requires: ((s "1.10.0") (f "0.19.0") (json "1.4"))        
;; Keywords: leanote, note, markdown
;; Homepage: https://github.com/aborn/.spacemacs.d/blob/master/parts/local-config.el
;; URL: https://github.com/aborn/leanote-emacs

;; This file is NOT part of GNU Emacs.

;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; A basic library!

;;; Code:

(require 'json)
(require 's)
(require 'f)

(defcustom local-config-file "~/.spacemacs.d/local/config.json"
  "The local config file name"
  :group 'local-config
  :type 'string)

(defun local-config-check? ()
  "check the key-value json file exists?"
  (f-exists? local-config-file))

(defun local-config-read-file-content ()
  "read json file"
  (json-read-file local-config-file))

(defun local-config-get (key &optional default-value)
  "Get local config key's value, use `default-value' when
   the key doesn't exists!"
  (let* ((json-data (local-config-read-file-content))
         (value (assoc-default (intern key) json-data)))
    (or value default-value)))

(provide 'local-config)
