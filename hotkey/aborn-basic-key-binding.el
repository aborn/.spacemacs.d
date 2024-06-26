;; --------------------------------------------------------------------
;; provide basic key bindings
;; 最基本的按键绑定
;; common key
;; "\C-" "\M-" TAB, RET, ESC, DEL "\t" "\r" "\e"
;; --------------------------------------------------------------------

;; M-s .. is unused, used for future.
(define-key global-map "\C-x\C-g" 'goto-line)
(global-set-key "\C-x\C-p" 'previous-buffer)
(global-set-key (kbd "C-,") 'previous-buffer)       ; emacs 23
(global-set-key "\C-x\C-n" 'next-buffer)
(global-set-key (kbd "C-.") 'next-buffer)           ; emacs 23
(global-set-key "\C-x\C-j" 'erase-buffer)
;; (global-set-key "\C-xk" 'kill-buffer)            ; emacs built-in key
(global-set-key "\C-x\C-r" 'revert-buffer)
;; (global-set-key "\C-x\C-m" 'indent-region)

;; 格式化当前buffer所有内容
(defun aborn/indent-regin ()
  (interactive)
  (indent-region (point-min) (point-max)))
(global-set-key "\C-x\C-m" 'aborn/indent-regin)

(global-set-key (kbd "M-n") 'ace-jump-mode)
(global-set-key "\C-x\C-l" 'copy-one-line)
(global-set-key "\C-i" 'just-one-space)
(if (functionp 'ace-window)
    (progn
      (global-set-key "\C-o" 'ace-window)
      (setq aw-ignored-buffers `("*Calc Trail*" "*LV*" " *NeoTree*"))  ;; ,neo-buffer-name
      ;;(add-to-list 'aw-ignored-buffers " *NeoTree*")  ;; 这要加到hook里才行
      )
  (global-set-key "\C-o" 'other-window))
(global-set-key (kbd "C-h C-f") 'find-function)
(global-set-key "\C-x\C-e" 'eval-current-buffer)
(global-set-key (kbd "C-'") 'move-middle-of-line)
(global-set-key (kbd "C-;") 'move-forward-by-five)
(global-set-key (kbd "C-:") 'move-backward-by-five)
(global-set-key (kbd "<C-tab>") 'bury-buffer)         ; switch buffer C-tab

;;(global-set-key (kbd "M-m") 'ab/switch-to-shell-buffer)  ; function in switch-swift
(global-set-key "\M-m\M-m" 'get-term)
(global-set-key (kbd "M-c") 'call-last-kbd-macro)

;; (global-set-key (kbd "C-j") 'switch-to-buffer)
(global-set-key (kbd "C-j") 'helm-buffers-list)
;; (global-set-key (kbd "C-j") 'switch-to-buffer)

(global-set-key (kbd "M-j") 'ido-find-file)
(global-set-key (kbd "C-s") 'helm-swoop-from-isearch)
;; (global-set-key (kbd "M-j") 'helm-find-files)

(global-set-key "\C-c\C-k" 'start-kbd-macro)
(global-set-key "\C-c\C-l" 'end-kbd-macro)

;; comment-region and uncomment-region
(global-set-key (kbd "C-(") 'comment-region)
(global-set-key (kbd "C-)") 'uncomment-region)

(defun unpop-to-mark-command ()
  "Unpop off mark ring. Does nothing if mark ring is empty."
  (interactive)
  (when mark-ring
    (setq mark-ring (cons (copy-marker (mark-marker)) mark-ring))
    (set-marker (mark-marker) (car (last mark-ring)) (current-buffer))
    (when (null (mark t)) (ding))
    (setq mark-ring (nbutlast mark-ring))
    (goto-char (marker-position (car (last mark-ring))))))

;; 快速导航 https://stackoverflow.com/questions/3393834/how-to-move-forward-and-backward-in-emacs-mark-ring
(global-set-key (kbd "C-<") 'pop-global-mark)
(global-set-key (kbd "C->") 'unpop-to-mark-command)

;; (defun marker-is-point-p (marker)
;;   "test if marker is current point"
;;   (and (eq (marker-buffer marker) (current-buffer))
;;        (= (marker-position marker) (point))))

;; (defun push-mark-maybe ()
;;   "push mark onto `global-mark-ring' if mark head or tail is not current location"
;;   (if (not global-mark-ring) (error "global-mark-ring empty")
;;     (unless (or (marker-is-point-p (car global-mark-ring))
;;                 (marker-is-point-p (car (reverse global-mark-ring))))
;;       (push-mark))))

;; (defun backward-global-mark ()
;;   "use `pop-global-mark', pushing current point if not on ring."
;;   (interactive)
;;   (push-mark-maybe)
;;   (when (marker-is-point-p (car global-mark-ring))
;;     (call-interactively 'pop-global-mark))
;;   (call-interactively 'pop-global-mark))

;; (defun forward-global-mark ()
;;   "hack `pop-global-mark' to go in reverse, pushing current point if not on ring."
;;   (interactive)
;;   (push-mark-maybe)
;;   (setq global-mark-ring (nreverse global-mark-ring))
;;   (when (marker-is-point-p (car global-mark-ring))
;;     (call-interactively 'pop-global-mark))
;;   (call-interactively 'pop-global-mark)
;;   (setq global-mark-ring (nreverse global-mark-ring)))

;; (global-set-key [M-left] (quote backward-global-mark))
;; (global-set-key [M-right] (quote forward-global-mark))

;; 设置find-file-in-project
;; https://github.com/technomancy/find-file-in-project

(provide 'aborn-basic-key-binding)
