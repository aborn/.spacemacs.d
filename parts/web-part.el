(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.[agj]sp\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))
(setq web-mode-enable-current-element-highlight t)   ;; 高亮当前行
(setq web-mode-enable-current-column-highlight t)    ;; 高亮当前列
;; auto-complete 源setting
;; (setq web-mode-ac-sources-alist
;;  '(("css" . (ac-source-css-property))
;;    ("html" . (ac-source-words-in-buffer ac-source-abbrev))))
(provide 'web-part)
