;;(defvar aborn/highlight-defined-function-face 'elixir-atom-face)

(defface aborn/highlight-defined-function-face
  '((((class color) (min-colors 88) (background light))
     :foreground "RoyalBlue4")
    (((class color) (background dark))
     (:foreground "light sky blue"))
    (t nil))
  "For use with atoms & map keys."
  :group 'font-lock-faces)

(custom-set-faces
 '(highlight-defined-function-name-face
   ((t (:inherit aborn/highlight-defined-function-face :bold nil))))
 '(highlight-defined-builtin-function-name-face
   ((((class color) (min-colors 89) (background dark))
     :foreground "#7b875b"))))

(provide 'aborn-face)
