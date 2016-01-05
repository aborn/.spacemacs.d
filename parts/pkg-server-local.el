(require 'package)
(setq package-enable-at-startup nil)

(require 'package-x)
(defvar local-archive
  (expand-file-name "pkgserver/" user-emacs-directory)
  "Location of the package archive.")
(setq package-archive-upload-base local-archive)
(add-to-list 'package-archives `("pkgserver" . ,local-archive) t)

(package-initialize)
