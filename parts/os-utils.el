;; 一些常用的os命令
(provide 'os-utils)

;; 获得本机的 内网ip
(defun ab/get-ip (arg)
  "Get the current buffer's file name"
  (interactive "P")
  (insert (shell-command-to-string "ifconfig |egrep \"10\\.|172\\.|192\\.\" |awk '{print $2}'")))

;; from http://pages.sachachua.com/.emacs.d/Sacha.html#orgheadline35
(defun prelude-copy-file-name-to-clipboard ()
  "Copy the current buffer file name to the clipboard."
  (interactive)
  (let ((filename (if (equal major-mode 'dired-mode)
                      default-directory
                    (buffer-file-name))))
    (when filename
      (kill-new filename)
      (message "Copied buffer file name '%s' to the clipboard." filename))))
