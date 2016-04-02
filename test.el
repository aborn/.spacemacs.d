(defun test-butle (arg)  
  "only used for ws-butler-global-mode test"
  (interactive "p")
  (when ws-butler-mode
    (message "global-mode turn on")
    (ws-butler-global-mode -1)))
