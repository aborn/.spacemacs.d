
;; --------------------------------------------------------------------
;; init-helm-thierry.el --- My startup file for helm. -*- lexical-binding: t -*- 
;; fork 于https://github.com/thierryvolpiatto/emacs-tv-config/blob/master/init-helm-thierry.el
;; helm https://github.com/emacs-helm/helm
;; install first:
;; git clone https://github.com/emacs-helm/helm.git ~/.emacs.d/site-lisp
;; git clone https://github.com/jwiegley/emacs-async.git ~/.emacs.d/site-lisp
;; --------------------------------------------------------------------
(require 'helm-config)
(require 'helm-ls-git)

;; Enable Modes (This is loading nearly everything).
(helm-mode 1)
;; (helm-adaptative-mode 1)
(helm-autoresize-mode 1)
;; (helm-push-mark-mode 1) ;; is removed ?

;;;; Extensions
;;
;;(load "/home/thierry/elisp/helm-extensions/helm-extensions-autoloads.el")

;;;; Test Sources or new helm code. 
;;   !!!WARNING EXPERIMENTAL!!!
(defun helm-version ()
  (with-temp-buffer
    (insert-file-contents (find-library-name "helm-pkg"))
    (goto-char (point-min))
    (when (re-search-forward
           "\\([0-9]+?\\)\\.\\([0-9]+?\\)\\.\\([0-9]+?\\)\\.?[0-9]*" nil t)
      (match-string-no-properties 0))))

(defun helm-git-version ()
  (shell-command-to-string
   "git log --pretty='format:%H' -1"))

(unless (fboundp 'helm-hide-minibuffer-maybe)
  (defun helm-hide-minibuffer-maybe ()
    (when (with-helm-buffer helm-echo-input-in-header-line)
      (let ((ov (make-overlay (point-min) (point-max) nil nil t)))
        (overlay-put ov 'window (selected-window))
        (overlay-put ov 'face (let ((bg-color (face-background 'default nil)))
                                `(:background ,bg-color :foreground ,bg-color)))
        (setq-local cursor-type nil)))))

(defun helm/turn-on-header-line ()
  (interactive)
  (setq helm-echo-input-in-header-line t)
  (helm-autoresize-mode -1)
  (add-hook 'helm-minibuffer-set-up-hook 'helm-hide-minibuffer-maybe)
  )

(defun helm/turn-off-header-line ()
  (interactive)
  (setq helm-echo-input-in-header-line nil)
  (helm-autoresize-mode 1)
  (remove-hook 'helm-minibuffer-set-up-hook 'helm-hide-minibuffer-maybe)
  )

;;; Helm-command-map
(define-key helm-command-map (kbd "g")   'helm-apt)
(define-key helm-command-map (kbd "w")   'helm-psession)
(define-key helm-command-map (kbd "z")   'helm-complex-command-history)
(define-key helm-command-map (kbd "w")   'helm-w3m-bookmarks)
(define-key helm-command-map (kbd "x")   'helm-firefox-bookmarks)
(define-key helm-command-map (kbd "#")   'helm-emms)
(define-key helm-command-map (kbd "I")   'helm-imenu-in-all-buffers)

;;; Global-map
(global-set-key (kbd "M-x")                          'undefined)
(global-set-key (kbd "M-x")                          'helm-M-x)
(global-set-key (kbd "M-y")                          'helm-show-kill-ring)
(global-set-key (kbd "C-c f")                        'helm-recentf)
(global-set-key (kbd "C-x C-f")                      'helm-find-files)
(global-set-key (kbd "C-c <SPC>")                    'helm-all-mark-rings)
(global-set-key (kbd "C-x r b")                      'helm-filtered-bookmarks)
(global-set-key (kbd "C-h r")                        'helm-info-emacs)
;;(global-set-key (kbd "C-:")                          'helm-eval-expression-with-eldoc)
(global-set-key (kbd "C-,")                          'helm-calcul-expression)
(global-set-key (kbd "C-h i")                        'helm-info-at-point)
(global-set-key (kbd "C-x C-d")                      'helm-browse-project)
(global-set-key (kbd "<f1>")                         'helm-resume)
(global-set-key (kbd "C-h C-f")                      'helm-apropos)
(global-set-key (kbd "<f5> s")                       'helm-find)
(global-set-key (kbd "<f2>")                         'helm-execute-kmacro)
;;(global-set-key (kbd "C-c g")                        'helm-gid)
(global-set-key (kbd "C-c g")                        'helm-ls-git-ls)

(global-set-key (kbd "C-c i")                        'helm-imenu-in-all-buffers)
(define-key global-map [remap jump-to-register]      'helm-register)
(define-key global-map [remap list-buffers]          'helm-buffers-list)
(define-key global-map [remap dabbrev-expand]        'helm-dabbrev)
(define-key global-map [remap find-tag]              'helm-etags-select)
(define-key global-map [remap xref-find-definitions] 'helm-etags-select)
(define-key shell-mode-map (kbd "M-p")               'helm-comint-input-ring) ; shell history.

;;; Lisp complete or indent. (Rebind <tab>)
;;
;; Use `completion-at-point' with `helm-mode' if available
;; otherwise fallback to helm implementation.

;; Set to `complete' will use `completion-at-point'.
;; (and (boundp 'tab-always-indent)
;;      (setq tab-always-indent 'complete))

(helm-multi-key-defun helm-multi-lisp-complete-at-point
    "Multi key function for completion in emacs lisp buffers.
First call indent, second complete symbol, third complete fname."
  '(helm-lisp-indent
    helm-lisp-completion-at-point
    helm-complete-file-name-at-point)
  0.3)

(if (and (boundp 'tab-always-indent)
         (eq tab-always-indent 'complete)
         (boundp 'completion-in-region-function))
    (progn
      (define-key lisp-interaction-mode-map [remap indent-for-tab-command] 'helm-multi-lisp-complete-at-point)
      (define-key emacs-lisp-mode-map [remap indent-for-tab-command] 'helm-multi-lisp-complete-at-point)
      
      ;; lisp complete. (Rebind M-<tab>)
      (define-key lisp-interaction-mode-map [remap completion-at-point] 'helm-lisp-completion-at-point)
      (define-key emacs-lisp-mode-map       [remap completion-at-point] 'helm-lisp-completion-at-point))
  
  (define-key lisp-interaction-mode-map [remap indent-for-tab-command] 'helm-multi-lisp-complete-at-point)
  (define-key emacs-lisp-mode-map [remap indent-for-tab-command] 'helm-multi-lisp-complete-at-point)
  
  ;; lisp complete. (Rebind M-<tab>)
  (define-key lisp-interaction-mode-map [remap completion-at-point] 'helm-lisp-completion-at-point)
  (define-key emacs-lisp-mode-map       [remap completion-at-point] 'helm-lisp-completion-at-point))

(unless (boundp 'completion-in-region-function)
  (add-hook 'ielm-mode-hook
            #'(lambda ()
                (define-key ielm-map    [remap completion-at-point] 'helm-lisp-completion-at-point))))

;;; helm completion in minibuffer
;;
;; (define-key minibuffer-local-map [remap completion-at-point] 'helm-lisp-completion-at-point)  ; >24.3
;; (define-key minibuffer-local-map [remap lisp-complete-symbol] 'helm-lisp-completion-at-point) ; <=24.3

;;; helm find files
(define-key helm-find-files-map (kbd "C-d") 'helm-ff-persistent-delete)
(define-key helm-buffer-map (kbd "C-d")     'helm-buffer-run-kill-persistent)

;; Use default-as-input in grep
(add-to-list 'helm-sources-using-default-as-input 'helm-source-grep)

;;; Describe key-bindings
;;
;;
;; (helm-descbinds-install)            ; C-h b, C-x C-h

;;; Helm-variables
(setq helm-google-suggest-use-curl-p             t
                                        ;helm-kill-ring-threshold                   1
      helm-raise-command                         "wmctrl -xa %s"
      helm-scroll-amount                         4
                                        ;helm-quick-update                          t
      helm-idle-delay                            0.01
      helm-input-idle-delay                      0.01
                                        ;helm-completion-window-scroll-margin       0
                                        ;helm-display-source-at-screen-top          nil
      helm-ff-search-library-in-sexp             t
                                        ;helm-kill-ring-max-lines-number            5
      helm-default-external-file-browser         "thunar"
      helm-pdfgrep-default-read-command          "evince --page-label=%p '%f'"
                                        ;helm-ff-transformer-show-only-basename     t
      helm-ff-auto-update-initial-value          t
      helm-grep-default-command                  "ack -Hn --smart-case --no-group %e %p %f"
      helm-grep-default-recurse-command          "ack -H --smart-case --no-group %e %p %f"
      ;; Allow skipping unwanted files specified in ~/.gitignore_global
      ;; Added in my .gitconfig with "git config --global core.excludesfile ~/.gitignore_global"
      helm-ls-git-grep-command                   "git grep -n%cH --color=always --exclude-standard --no-index --full-name -e %p %f"
      helm-default-zgrep-command                 "zgrep --color=always -a -n%cH -e %p %f"
                                        ;helm-pdfgrep-default-command               "pdfgrep --color always -niH %s %s"
      helm-reuse-last-window-split-state         t
                                        ;helm-split-window-default-side             'below
                                        ;helm-split-window-in-side-p                t
                                        ;helm-echo-input-in-header-line             t
      helm-always-two-windows                    t
                                        ;helm-persistent-action-use-special-display t
      helm-buffers-favorite-modes                (append helm-buffers-favorite-modes
                                                         '(picture-mode artist-mode))
      helm-ls-git-status-command                 'magit-status
                                        ;helm-never-delay-on-input                  nil
                                        ;helm-candidate-number-limit                200
      helm-M-x-requires-pattern                  0
      helm-dabbrev-cycle-threshold                5
      helm-surfraw-duckduckgo-url                "https://duckduckgo.com/?q=%s&ke=-1&kf=fw&kl=fr-fr&kr=b&k1=-1&k4=-1"
                                        ;helm-surfraw-default-browser-function      'w3m-browse-url
      helm-boring-file-regexp-list               '("\\.git$" "\\.hg$" "\\.svn$" "\\.CVS$" "\\._darcs$" "\\.la$" "\\.o$" "\\.i$")
                                        ;helm-mode-handle-completion-in-region      t
                                        ;helm-moccur-always-search-in-current        t
                                        ;helm-tramp-verbose                         6
      helm-buffer-skip-remote-checking            t
                                        ;helm-ff-file-name-history-use-recentf      t
                                        ;helm-follow-mode-persistent                t
      helm-apropos-fuzzy-match                    t
      helm-M-x-fuzzy-match                        t
      helm-lisp-fuzzy-completion                  t
                                        ;helm-locate-fuzzy-match                     t
      helm-completion-in-region-fuzzy-match       t
      helm-move-to-line-cycle-in-source           t
      ido-use-virtual-buffers                     t             ; Needed in helm-buffers-list
      helm-tramp-verbose                          6
      helm-buffers-fuzzy-matching                 t
      helm-locate-command                         "locate %s -e -A --regex %s"
      helm-org-headings-fontify                   t
      helm-autoresize-max-height                  80 ; it is %.
      helm-autoresize-min-height                  20 ; it is %.
      helm-buffers-to-resize-on-pa                '("*helm apropos*" "*helm ack-grep*"
                                                    "*helm grep*" "*helm occur*"
                                                    "*helm multi occur*" "*helm lsgit*"
                                                    "*helm git-grep*" "*helm hg files*"
                                                    "*helm imenu*" "*helm imenu all*"
                                                    "*helm gid*" "*helm semantic/imenu*")
      fit-window-to-buffer-horizontally           1
      helm-open-github-closed-issue-since         7
      helm-search-suggest-action-wikipedia-url
      "https://fr.wikipedia.org/wiki/Special:Search?search=%s"
      helm-wikipedia-suggest-url
      "http://fr.wikipedia.org/w/api.php?action=opensearch&search="
      helm-wikipedia-summary-url
      "http://fr.wikipedia.org/w/api.php?action=parse&format=json&prop=text&section=0&page=")

;; Avoid hitting forbidden directory .gvfs when using find.
(add-to-list 'completion-ignored-extensions ".gvfs/")

;;; Hide minibuffer
;;
;; (add-hook 'helm-minibuffer-set-up-hook 'helm-hide-minibuffer-maybe)

;;; Toggle grep program
(defun eselect-grep ()
  (interactive)
  (when (y-or-n-p (format "Current grep program is %s, switching? "
                          (helm-grep-command)))
    (if (helm-grep-use-ack-p)
        (setq helm-grep-default-command
              "grep --color=always -d skip %e -n%cH -e %p %f"
              helm-grep-default-recurse-command
              "grep --color=always -d recurse %e -n%cH -e %p %f")
      (setq helm-grep-default-command
            "ack-grep -Hn --smart-case --no-group %e %p %f"
            helm-grep-default-recurse-command
            "ack-grep -H --smart-case --no-group %e %p %f"))
    (message "Switched to %s" (helm-grep-command))))

;;; Debugging
(defun helm-debug-toggle ()
  (interactive)
  (setq helm-debug (not helm-debug))
  (message "Helm Debug is now %s"
           (if helm-debug "Enabled" "Disabled")))

(defun helm-ff-candidates-lisp-p (candidate)
  (cl-loop for cand in (helm-marked-candidates)
           always (string-match "\.el$" cand)))

;;; Modify source attributes
;; Add actions to `helm-source-find-files' IF:

(defmethod helm-setup-user-source ((source helm-source-ffiles))
  (helm-source-add-action-to-source-if
   "Byte compile file(s) async"
   'async-byte-compile-file
   source
   'helm-ff-candidates-lisp-p))

(defmethod helm-setup-user-source ((source helm-source-buffers))
  (set-slot-value source 'candidate-number-limit 200))

;;; Psession windows
(defun helm-psession-windows ()
  (interactive)
  (helm :sources (helm-build-sync-source "Psession windows"
                   :candidates (lambda ()
                                 (sort (mapcar 'car psession--winconf-alist) #'string-lessp))
                   :action (helm-make-actions
                            "Restore" 'psession-restore-winconf
                            "Delete" 'psession-delete-winconf))
        :buffer "*helm psession*"))

;;; helm dictionary
(setq helm-dictionary-database "~/helm-dictionary/dic-en-fr.iso")
(setq helm-dictionary-online-dicts '(("translate.reference.com en->fr" .
                                      "http://translate.reference.com/translate?query=%s&src=en&dst=fr")
                                     ("translate.reference.com fr->en" .
                                      "http://translate.reference.com/translate?query=%s&src=fr&dst=en")))

;; --------------------------------------------------------------------
;; 下面配置helm-swoop.el,快速搜索
;; https://github.com/ShingoFukuyama/helm-swoop
;; --------------------------------------------------------------------
;; helm from https://github.com/emacs-helm/helm
(require 'helm)

;; Locate the helm-swoop folder to your path
;; (add-to-list 'load-path "~/.emacs.d/elisp/helm-swoop")
(require 'helm-swoop)

;; Change the keybinds to whatever you like :)
(global-set-key (kbd "M-i") 'helm-swoop)
(global-set-key (kbd "C-S-s") 'helm-swoop)
(global-set-key (kbd "M-I") 'helm-swoop-back-to-last-point)
(global-set-key (kbd "C-c M-i") 'helm-multi-swoop)
(global-set-key (kbd "C-x M-i") 'helm-multi-swoop-all)

;; When doing isearch, hand the word over to helm-swoop
(define-key isearch-mode-map (kbd "M-i") 'helm-swoop-from-isearch)
;; From helm-swoop to helm-multi-swoop-all
(define-key helm-swoop-map (kbd "M-i") 'helm-multi-swoop-all-from-helm-swoop)
;; When doing evil-search, hand the word over to helm-swoop
;; (define-key evil-motion-state-map (kbd "M-i") 'helm-swoop-from-evil-search)

;; Instead of helm-multi-swoop-all, you can also use helm-multi-swoop-current-mode
(define-key helm-swoop-map (kbd "M-m") 'helm-multi-swoop-current-mode-from-helm-swoop)

;; Move up and down like isearch
(define-key helm-swoop-map (kbd "C-r") 'helm-previous-line)
(define-key helm-swoop-map (kbd "C-s") 'helm-next-line)
(define-key helm-multi-swoop-map (kbd "C-r") 'helm-previous-line)
(define-key helm-multi-swoop-map (kbd "C-s") 'helm-next-line)

;; Save buffer when helm-multi-swoop-edit complete
(setq helm-multi-swoop-edit-save t)

;; If this value is t, split window inside the current window
(setq helm-swoop-split-with-multiple-windows nil)

;; Split direcion. 'split-window-vertically or 'split-window-horizontally
(setq helm-swoop-split-direction 'split-window-vertically)

;; If nil, you can slightly boost invoke speed in exchange for text color
(setq helm-swoop-speed-or-color nil)

;; ;; Go to the opposite side of line from the end or beginning of line
(setq helm-swoop-move-to-line-cycle t)

;; Optional face for line numbers
;; Face name is `helm-swoop-line-number-face`
(setq helm-swoop-use-line-number-face t)

;; use search query at the cursor  (default)
(setq helm-swoop-pre-input-function
      (lambda () (thing-at-point 'symbol)))

;; disable pre-input
(setq helm-swoop-pre-input-function
      (lambda () ""))

;; match only for symbol
(setq helm-swoop-pre-input-function
      (lambda () (format "\\_<%s\\_> " (thing-at-point 'symbol))))

;; Always use the previous search for helm. Remember C-<backspace> will delete entire line
(setq helm-swoop-pre-input-function
      (lambda () (if (boundp 'helm-swoop-pattern)
                     helm-swoop-pattern "")))

;; If there is no symbol at the cursor, use the last used words instead.
(setq helm-swoop-pre-input-function
      (lambda ()
        (let (($pre-input (thing-at-point 'symbol)))
          (if (eq (length $pre-input) 0)
              helm-swoop-pattern ;; this variable keeps the last used words
            $pre-input))))

;; -----------------------------------------------------------------------------
;; helm-dash这个文档插件，可以有时间看看，很有用
;; https://github.com/areina/helm-dash
;; -----------------------------------------------------------------------------
(provide 'init-helm-aborn)

;;; init-helm-thierry.el ends here
