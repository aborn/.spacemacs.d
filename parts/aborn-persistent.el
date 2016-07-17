;; (require 'eieio)
;; (require 'eieio-base)
;; here use pcache for persistent
;; https://github.com/sigma/pcache/blob/master/pcache.el
(require 'pcache)

(defun aborn/persistent-hash-table ()
  "persistent hash table"
  (interactive)
  (let ((repo (pcache-repository "aborn"))
        (abornhash (make-hash-table :test 'equal)))
    (puthash "a" '((a . "a") (b ."b")) abornhash)
    (pcache-put repo 'ab/hash abornhash)
    (message "finished persistent")
    ))

(defun aborn/persistent-get (key)
  "get"
  (interactive)
  (let ((repo (pcache-repository "aborn")))
    (setq ab/debug (pcache-get repo 'ab/hash))
    )
  )

(provide 'aborn-persistent)
