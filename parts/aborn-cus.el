;;; aborn-cus.el --- 一些对系统函数的定制

;; Copyright (C) 2017 Aborn Jiang

;;; Commentary:

;; some swift action

;;; Code:

(defun aborn/beginning-of-buffer (&optional arg)
  (interactive)
  (aborn/push-marker-stack)
  (beginning-of-buffer arg))

(defun aborn/end-of-buffer (&optional arg)
  (interactive)
  (aborn/push-marker-stack)
  (end-of-buffer))

(provide 'aborn-cus)
;;; aborn-cus.el ends here
