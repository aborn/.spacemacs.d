;;; aborn-term.el --- An extensions for term.el -*-

;; Copyright (C) 2023 Aborn Jiang


;;; Require:
(require 'term)

(defun aborn/term ()
  "Start a new term program."
  (interactive)
  (term "/bin/zsh")
  ;;(make-term "zsh" "/bin/zsh")
  ;;(term-char-mode)
  ;;(pop-to-buffer-same-window "*zsh*")
  )

(provide 'aborn-term)
