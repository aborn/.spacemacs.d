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

;; activate installed packages
(package-initialize)

(provide 'init-pkg-aborn)
