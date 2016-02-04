(setq load-path (cons  "/usr/local/Cellar/erlang/18.1/lib/erlang/lib/tools-2.8.1/emacs"
                       load-path))
(setq erlang-root-dir "/usr/local/Cellar/erlang/18.1")
(setq exec-path (cons "/usr/local/Cellar/erlang/18.1/bin" exec-path))
(setq erlang-man-root-dir "/usr/local/Cellar/erlang/18.1/lib/erlang/man")

(require 'erlang-start)
(add-to-list 'auto-mode-alist '("\\.erl?$" . erlang-mode))
(add-to-list 'auto-mode-alist '("\\.hrl?$" . erlang-mode))

(provide 'erlang-part)
