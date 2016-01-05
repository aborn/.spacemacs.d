;; -----------------------------------------------------------------------------
;; install elixir-mode
;; from https://github.com/tonini/alchemist.el
;; 最常用的快捷键
;;   M-.  函数定义处
;;   M-,  back
;; -----------------------------------------------------------------------------
(unless (package-installed-p 'elixir-mode)
  (package-install 'elixir-mode))
(unless (package-installed-p 'alchemist)
  (package-install 'alchemist))

(require 'smartparens)
(require 'alchemist)
(setq alchemist-mix-command "/usr/local/bin/mix")
;; Use a different task for running tests.
(setq alchemist-mix-test-task "espec")

(setq alchemist-iex-program-name "/usr/local/bin/iex")
(setq alchemist-execute-command "/usr/local/bin/elixir")
(setq alchemist-compile-command "/usr/local/bin/elixirc")
(setq alchemist-test-status-modeline nil)

;; Use a different keybinding prefix than C-c a
(setq alchemist-key-command-prefix (kbd "C-c ,"))
(setq alchemist-test-mode-highlight-tests nil)
(setq alchemist-test-ask-about-save nil)
(setq alchemist-test-status-modeline nil)
(setq alchemist-test-display-compilation-output t)

;; Run the whole test suite with alchemist-mix-test after saving a buffer.
(setq alchemist-hooks-test-on-save t)
;; elixir source code
(setq alchemist-goto-elixir-source-dir "/Users/aborn/github/elixir")
(setq alchemist-goto-erlang-source-dir "/Users/aborn/github/otp")

;;(defun custom-elixir-mode-hook ()
;;  (define-key alchemist-mode-keymap (kbd "M-i") 'alchemist-goto-definition-at-point))
;;(add-hook 'elixir-mode-hook 'custom-elixir-mode-hook)
(provide 'elixir-part)
