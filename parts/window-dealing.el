;; this file provide all window dealing functions.
;; 2014-05-07   Aborn Jiang (aborn.jiang@foxmail.com)

(provide 'window-dealing)

(defun ab/get-window-at-right-botton ()
  "get the right botton window"
  (window-at (- (frame-width) 2) (- (frame-height) 6)))

(defun ab/get-window-at-right-top ()
  "get the right botton window"
  (window-at (- (frame-width) 2) 6))

(defun ab/get-window-buffer-name (window)
  "get the windows' buffer name"
  (buffer-name (window-buffer window)))

(defun ab/get-current-window-buffer-name ()
  "get the windows' buffer name"
  (interactive)
  (message (buffer-name)))

(defun ab/get-next-window-buffer-name ()
  "get next window buffer name and skill ecb window"
  (interactive)
  (setq cw (selected-window))  ;; save current window
  (setq nw (ab/get-window-buffer-name (next-window)))
  (while (or (string= nw " *ECB Directories*")
             (string= nw " *ECB Sources*")
             (string= nw " *ECB Methods*")
             (string= nw " *ECB History*")
             (string= nw "*SPEEDBAR*"))
    (setq nw (ab/get-window-buffer-name (next-window)))
    (message nw)
    (select-window (next-window)))
  (select-window cw)          ;; recover current window
  (message nw)
  )

(defun ab/ecb-activate? ()
  "return t if ecb been activate"
  (or (ab/buffer-exists " *ECB Directories*")
      (ab/buffer-exists " *ECB Sources*")
      (ab/buffer-exists " *ECB Methods*")
      (ab/buffer-exists " *ECB History*")))

(defun ab/sr-speedbar-buffer-exist? ()
  "return t if sr-speedbar buffer live"
  (ab/buffer-exists "*SPEEDBAR*"))

(defun ab/sr-speedbar-window-live? ()
  "return t if sr-speedbar window live"
  (window-valid-p (get-buffer-window "*SPEEDBAR*")))

(defun ab/get-first-content-window ()
  "get the first conten window when ecb active"
  (if (or (ab/ecb-activate?)
          (ab/sr-speedbar-window-live?))
      (window-in-direction 'right (frame-first-window))
    (frame-first-window)))

(defun ab/get-window-layout-name ()
  "get the current layout"
  (interactive)
  (setq name "one")
  (setq cw (selected-window))  ;; save current window
  (setq main-content-wind (ab/get-first-content-window))
  (setq rbwindow (ab/get-window-at-right-botton))
  (when (window-valid-p (window-in-direction 'right main-content-wind))
    (setq name "two"))
  (when (and (window-valid-p (window-in-direction 'above rbwindow))
             (window-valid-p (window-in-direction 'right main-content-wind)))
    (setq name "default"))
  (select-window cw)           ;; restore save window
  (message name))

(defun ab/window-normal ()
  "display normal window layout (default)"
  (interactive)
  (if (ab/ecb-activate?)
      (ab/window-normal-ecb)
    (ab/window-normal-speedbar))
  )

(defun ab/sr-speedbar-select-window ()
  "select sr-speedbar window if live"
  (when (ab/sr-speedbar-window-live?)
    (select-window (get-buffer-window "*SPEEDBAR*"))))

(defun ab/window-normal-speedbar ()
  "display speedbar normal layout"
  (setq cw (selected-window))
  (unless (ab/sr-speedbar-buffer-exist?)
    (sr-speedbar-open))
  (when (not (ab/sr-speedbar-buffer-exist?))
    (select-window (window-at 2 2))
    (sr-speedbar-toggle))
  (ab/sr-speedbar-select-window)
  (select-window (window-in-direction 'right nil))
  ;;  (select-window cw)
  (ab/window-normal-ecb))

(defun ab/window-normal-ecb ()
  "display ecb normal layout"
  (setq nwindname (ab/get-next-window-buffer-name))
  (setq nxbfname (buffer-name (next-buffer)))
  (previous-buffer)           ;; return previous
  (when (string= (ab/get-window-layout-name) "default") 
    (throw 'break "already default window layout."))
  (setq cw (selected-window))          ;; save current window
  (setq main-content-wind (ab/get-first-content-window))
  (select-window main-content-wind)
  (delete-other-windows)
  (if (window-valid-p main-content-wind)
      (progn (split-window main-content-wind nil 'right)
             (split-window (window-in-direction 'right main-content-wind) 
                           nil 'below)
             (if (string= (buffer-name) nwindname)
                 (set-window-buffer (next-window) nxbfname)
               (set-window-buffer (next-window) nwindname))
             (set-window-buffer (next-window (next-window))  ;; set shell
                                (ab/get-default-shell-buffer-name))
             (message "ecb main content split into default layout.")))
  (when (window-valid-p cw)      ;; restore save window
    (select-window cw)))

(defun ab/window-two-views ()
  "two windows view"
  (interactive)
  (when (string= (ab/get-window-layout-name) "default")
    (delete-window (ab/get-window-at-right-botton))
    (throw 'break "delete the right bottow window"))
  (when (or (and (string= (ab/get-window-layout-name) "two")
                 (ab/ecb-activate?)) 
            (and (string= (ab/get-window-layout-name) "two")
                 (ab/sr-speedbar-window-live?)))
    (throw 'break "already two view windows."))
  (setq nwindname (ab/get-next-window-buffer-name))
  (setq cw (selected-window))
  (setq cwname (buffer-name))
  (if (ab/sr-speedbar-window-live?)
      (progn (select-window (ab/get-first-content-window))
             (delete-other-windows))
    (progn (unless (ab/ecb-activate?)
             (select-window (ab/get-first-content-window))
             (delete-other-windows)
             (if (ab/sr-speedbar-buffer-exist?)
                 (sr-speedbar-toggle)
               (sr-speedbar-open)))))
  (select-window (ab/get-first-content-window))
  (split-window nil nil 'right)
  (set-window-buffer (next-window) nwindname)
  (when (string= (buffer-name) (ab/get-window-buffer-name 
                                (ab/get-window-at-right-botton)))
    (set-window-buffer (next-window) (ab/get-default-shell-buffer-name)))
  )

(defun ab/window-one-view()
  "one view and speedbar or ecb"
  (interactive)
  (select-window (ab/get-first-content-window))
  (when (ab/ecb-activate?)
    (throw 'break "already one window view!"))
  (delete-other-windows)
  (unless (ab/ecb-activate?)
    (if (ab/sr-speedbar-buffer-exist?)
        (progn 
          (unless (ab/sr-speedbar-window-live?)
            (sr-speedbar-toggle)))
      (progn
        (sr-speedbar-open)
        ))
    (select-window (ab/get-first-content-window))
    (message "one view and speedbar layout")))

(defun ab/ecb-sr-switch (p)
  "aborn switch between ecb and speedbar mode"
  (setq cwname (buffer-name))  ;; save current window name
  (setq cw (selected-window))  ;; save current window
  (select-window (ab/get-first-content-window))
  (setq layoutname (ab/get-window-layout-name))
  (funcall p)
  (cond ((string= layoutname "one")
         (ab/window-one-view))
        ((string= layoutname "two")
         (ab/window-two-views))
        ((string= layoutname "default")
         (ab/window-normal)))
  (if (window-valid-p (get-buffer-window cwname))
      (select-window (get-buffer-window cwname))
    (select-window cw)))   ;; recover window

(defun ab/ecb-activate ()
  "aborn ecb active and set default layout"
  (interactive)
  (when (ab/ecb-activate?)
    (throw 'break "ecb already is activated!"))
  (ab/ecb-sr-switch 'ecb-activate)
  )

(defun ab/ecb-deactivate ()
  "aborn ecb deactive and set default layout"
  (interactive)
  (when (not (ab/ecb-activate?))
    (throw 'break "ecb is not activated!"))
  (ab/ecb-sr-switch 'ecb-deactivate)
  )

;; define alias function
(defalias 'ab/window-layout-default 'ab/window-normal)
(defalias 'ab/window-layout-codeview 'ab/window-two-views)
(defalias 'ab/window-layout-bigview 'ab/window-one-view)

;; following use for testing.
(defun ab/get-test-msg ()
  "aborn only for testing "
  (interactive)
  (message (visited-file-modtime)))

(defun aborn/toggle-window-split ()
  (interactive)
  (when (= (count-windows) 2)
      (let* ((this-win-buffer (window-buffer))
             (next-win-buffer (window-buffer (next-window)))
             (this-win-edges (window-edges (selected-window)))
             (next-win-edges (window-edges (next-window)))
             (this-win-2nd (not (and (<= (car this-win-edges)
                                         (car next-win-edges))
                                     (<= (cadr this-win-edges)
                                         (cadr next-win-edges)))))
             (splitter
              (if (= (car this-win-edges)
                     (car (window-edges (next-window))))
                  'split-window-horizontally
                'split-window-vertically)))
        (delete-other-windows)
        (let ((first-win (selected-window)))
          (funcall splitter)
          (if this-win-2nd (other-window 1))
          (set-window-buffer (selected-window) this-win-buffer)
          (set-window-buffer (next-window) next-win-buffer)
          (select-window first-win)
          (if this-win-2nd (other-window 1))))))
