(require 'cl-lib)
(require 'package)
(require 'lisp-mnt)
(require 'json)

(defun ab/decode-region (arg)
  "decode current buffer"
  (interactive "P")
  (decode-coding-region (point-min) (point-max) 'utf-8))

(defun ab/ajax-build-status (arg)
  "ajax pelpa building status"
  (interactive "P")
  (let* ((pelpa-build-status-url "http://pelpa.popkit.org/elpa/build/ajaxBuildStatus.json")
         (pelpa-buffer-name "*pelpa*")
         (pelpa-buffer (get-buffer-create pelpa-buffer-name))
         (buffer (url-retrieve-synchronously pelpa-build-status-url))
         (headers nil)
         (handle nil))
    (if (not buffer)
        (error "请求%s失败，请重试!" pelpa-build-status-url))
    (with-current-buffer buffer
      (unless (= 200 url-http-response-status)
        (error "Http error %s fetching %s" url-http-response-status pelpa-build-status-url))
      (message "buffer name%s" (buffer-name))
      (setq handle (mm-dissect-buffer t))
      (setq headers (decode-coding-string (buffer-string) 'utf-8))
      
      (with-current-buffer pelpa-buffer
        (setq-default major-mode 'text-mode)  ;; 设置local mojor-mode为'text-mode
        (set-buffer-major-mode pelpa-buffer)
        (erase-buffer)     ;; 先清空原有的内容
        (insert headers))
      )))
