(require 'cl-lib)
(require 'package)
(require 'lisp-mnt)
(require 'json)

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
      (setq headers (buffer-string))
      
      (with-current-buffer pelpa-buffer
        (setq-default major-mode 'text-mode)
        (set-buffer-major-mode pelpa-buffer)
        (erase-buffer)     ;; 先清空原有的内容
        (insert headers))
      )))
