;;; packages.el --- aborn Layer packages File for Spacemacs
;;
;; Copyright (c) 2012-2014 Sylvain Benner
;; Copyright (c) 2014-2015 Sylvain Benner & Contributors
;;
;; Author: Sylvain Benner <sylvain.benner@gmail.com>
;; URL: https://github.com/syl20bnr/spacemacs
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3

;; List of all packages to install and/or initialize. Built-in packages
;; which require an initialization must be listed explicitly in the list.
(setq aborn-packages
      '(
        swiper
        org-page
        expand-region
        elixir-mode
        alchemist
        ;; package names go here
        ))

;; List of packages to exclude.
(setq aborn-excluded-packages '())

(defun aborn/init-swiper ()
  "init swiper"
  (use-package swiper))

(defun aborn/init-org-page ()
  "install org-page"
  (use-package org-page)
  (message "init org-page"))

(defun aborn/init-expand-region ()
  (use-package expand-region)
  (require 'expand-region)   ;; 跟 extend-selection 类似
  (global-set-key (kbd "C-l") 'er/expand-region))

(defun aborn/init-elixir-mode ()
  (use-package elixir-mode))

(defun aborn/init-alchemist ()
  (use-package alchemist))
;; For each package, define a function aborn/init-<package-name>
;;
;; (defun aborn/init-my-package ()
;;   "Initialize my package"
;;   )
;;
;; Often the body of an initialize function uses `use-package'
;; For more info on `use-package', see readme:
;; https://github.com/jwiegley/use-package
