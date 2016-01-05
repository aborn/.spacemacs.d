;; help message function

(defun ab/help-key (arg)
  "Switch to key binding help message"
  (interactive "p")
  (find-file "~/.emacs.d/doc/keybinding.md"))

(defun ab/help-init (arg)
  "Switch to key binding help message"
  (interactive "p")
  (find-file "~/.emacs.d/doc/keyinit.md"))

(provide 'ab-help)
