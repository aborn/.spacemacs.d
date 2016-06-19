;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 这里放的是从 Marmalade and MELPA 安装的包
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require 'use-package)
(setq use-package-verbose t)

;; (require 'package)
;; (add-to-list 'package-archives
;;              '("popkit" . "http://elpa.popkit.org/packages/") t)
;; (package-initialize)

;; --------------------------------------------------------------------
;; exec-path-from-shell
;; https://github.com/purcell/exec-path-from-shell
;; --------------------------------------------------------------------
(when (memq window-system '(mac ns))
  (exec-path-from-shell-initialize))

;; 下面是自己写的函数，主要是多电脑时，把安装的packages保存到一个文件里去
(setq ab/save-package-activated-list-file "~/.spacemacs.d/ab-installed-packages")
(defvar ab-installed-packages nil)

(defun ab/save-package-activated-list (&optional arg)
  "Save history information to file given by `helm-adaptive-history-file'."
  (interactive "p")
  (with-temp-buffer
    (insert
     ";; -*- mode: emacs-lisp -*-\n"
     ";; Installed packages list used for multi computer env.\n")
    (prin1 `(setq ab-installed-packages ',package-activated-list)
           (current-buffer))
    (insert ?\n)
    (write-region (point-min) (point-max) ab/save-package-activated-list-file nil
                  (unless arg 'quiet))))

;; 关闭emacs的时候，保存下当前已经安装的packages
(add-hook 'kill-emacs-hook 'ab/save-package-activated-list)
;; 打开emacs的时候，load安装的packages
(add-hook 'after-init-hook
          (lambda ()
            (when (file-readable-p ab/save-package-activated-list-file)
              (load-file ab/save-package-activated-list-file))))

;;http://ergoemacs.org/emacs/elisp_printing.html
(defun ab/print-installed-packages (&optional arg)
  "print info installed packages"
  (interactive "p")
  (with-current-buffer (get-buffer-create ab-message-buffer-name)
    (dolist (pkg ab-installed-packages)
      (insert "\n")
      (princ pkg (current-buffer)))))

(defun ab/log (msg)
  (with-current-buffer (get-buffer-create ab-message-buffer-name)
    (princ msg (current-buffer))))

(defun ab/install-missed-package (&optional arg)
  "install missed package"
  (interactive "p")
  (async-start
   '(lambda ()
      ;; install the missing packages
      (dolist (package ab-installed-packages)
        (message "package %s" package)
        (unless (package-installed-p package)
          (package-install package))))))

(defun ab/get-readme-file-path (name)
  (format "%s/%s-readme.txt" package-user-dir name))

(defun ab/get-pkg-info (pkg)
  "获得包的详细说明，readme文件内容"
  (interactive)
  (let ((file-content (with-temp-buffer
                        (insert-file-contents (ab/get-readme-file-path pkg))
                        (buffer-string))))
    (format "package %s info:\n %s\n\n %s"
            pkg
            (ab/get-readme-file-path pkg)
            file-content)))

;; 这里也是使用ivy-read的一个例子
(defun ab/search-pkg-installed ()
  "搜索已经安装的包名,选择后显示包的ReadeMe内容"
  (interactive)
  (ivy-read "search installed package name: "
            (remove-duplicates (mapcar (lambda (elt)
                                         (symbol-name elt))
                                       ab-installed-packages)
                               :test 'string=)
            :action (lambda (x)
                      (with-help-window
                          (help-buffer)
                        (print (ab/get-pkg-info x))))))

;; 异步的列出packages
(defun ab/list-packages ()
  "package-install async"
  (interactive)
  (async-start
   `(lambda ()
      (setq package-archives
            '(("melpa"         . "http://melpa.org/packages/")
              ("org"         . "http://orgmode.org/elpa/")
              ("marmalade"   . "http://marmalade-repo.org/packages/")
              ("popkit" . "http://elpa.popkit.org/packages/")))
      (require 'finder-inf nil t)
      ;; Initialize the package system if necessary.
      (package-initialize t)
      (setq coding-system-for-write 'utf-8-unix)
      (let (old-archives new-packages)
        ;; Read the locally-cached archive-contents.
        (package-read-all-archive-contents)
        (setq old-archives package-archive-contents)
        ;; Fetch the remote list of packages.
        (package-refresh-contents)
        ;; Find which packages are new.
        (dolist (elt package-archive-contents)
          (unless (assq (car elt) old-archives)
            (push (car elt) new-packages)))
        (setq result-prev (list new-packages package-archive-contents))))
   `(lambda (result)
      (setq package-archive-contents (cadr result))
      (let ((new-packages (car result)))
        ;; Generate the Package Menu.
        (let ((buf (get-buffer-create "*Packages*")))
          (with-current-buffer buf
            (package-menu-mode)
            (set (make-local-variable 'package-menu--new-package-list)
                 new-packages)
            (package-menu--generate nil t))
          ;; The package menu buffer has keybindings.  If the user types
          ;; `M-x ab/list-packages', that suggests it should become current.
          (switch-to-buffer buf))

        (let ((upgrades (package-menu--find-upgrades)))
          (if upgrades
              (message "%d package%s can be upgraded; type `%s' to mark %s for upgrading."
                       (length upgrades)
                       (if (= (length upgrades) 1) "" "s")
                       (substitute-command-keys "\\[package-menu-mark-upgrades]")
                       (if (= (length upgrades) 1) "it" "them"))))))))

;; 确实包被安装，如果没安装，刚安装之
(defun ensure-package-installed (&rest packages)
  "Assure every package is installed, ask for installation if it’s not.
Return a list of installed packages or nil for every skipped package."
  (mapcar
   (lambda (package)
     ;; (package-installed-p 'evil)
     (if (package-installed-p package)
         nil
       (if (y-or-n-p (format "Package %s is missing. Install it? " package))
           (package-install package)
         package)))
   packages))

;; make sure to have downloaded archive description.
;; Or use package-archive-contents as suggested by Nicolas Dudebout
(or (file-exists-p package-user-dir)
    (package-refresh-contents))

;;(ensure-package-installed 'find-file-in-project 'swiper);
(when (boundp ab-installed-packages)
  (message "ab-installed-packages exists!")
  (dolist (pkg ab-installed-packages)
    (message "%s\n" pkg)))

(ensure-package-installed 'find-file-in-project 'swiper);
(global-set-key (kbd "C-x f") 'find-file-in-project)
;; (ab/install-missed-package)
;; activate installed packages
(package-initialize)

(provide 'package-part)


