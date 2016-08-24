(defface aborn/highlight-defined-function-face
  '((((class color) (min-colors 88) (background light))
     :foreground "RoyalBlue4")
    (((class color) (background dark))
     (:foreground "light sky blue"))
    (t nil))
  "For use with atoms & map keys."
  :group 'font-lock-faces)

;; aborn customize highlight-defined https://github.com/Fanael/highlight-defined
(custom-set-faces
 '(highlight-defined-function-name-face
   ((((class color) (min-colors 88))
     :foreground "#997599")))
 '(highlight-defined-builtin-function-name-face
   ((((class color) (min-colors 88) (background dark))
     :foreground "#7b875b")))
 '(highlight-defined-special-form-name-face
   ((((class color) (min-colors 88))
     :foreground "#626262")))
 '(highlight-defined-variable-name-face
   ((((class color) (min-colors 88))
     :foreground "#8d5351"))))

(provide 'aborn-face)
