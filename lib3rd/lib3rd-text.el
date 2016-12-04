;;; lib3rd-text.el --- text/string releated third-part library.

;;; Commentary:

;; (xah-convert-english-chinese-punctuation *begin *end &optional *to-direction) 中英文标点符号转换

;;; Code:

(defun xah-convert-english-chinese-punctuation (*begin *end &optional *to-direction)
  "Convert punctuation from/to English/Chinese characters.

When called interactively, do current line or selection. The conversion direction is automatically determined.

If `universal-argument' is called, ask user for change direction.

When called in lisp code, *begin *end are region begin/end positions. *to-direction must be any of the following values: 「\"chinese\"」, 「\"english\"」, 「\"auto\"」.

See also: `xah-remove-punctuation-trailing-redundant-space'.

URL `http://ergoemacs.org/emacs/elisp_convert_chinese_punctuation.html'
Version 2015-10-05"
  (interactive
   (let (-p1 -p2)
     (if (use-region-p)
         (progn
           (setq -p1 (region-beginning))
           (setq -p2 (region-end)))
       (progn
         (setq -p1 (line-beginning-position))
         (setq -p2 (line-end-position))))
     (list
      -p1
      -p2
      (if current-prefix-arg
          (ido-completing-read
           "Change to: "
           '( "english"  "chinese")
           "PREDICATE"
           "REQUIRE-MATCH")
        "auto"
        ))))
  (let (
        (-input-str (buffer-substring-no-properties *begin *end))
        (-replacePairs
         [
          [". " "。"]
          [".\n" "。\n"]
          [", " "，"]
          [",\n" "，\n"]
          [": " "："]
          ["; " "；"]
          ["? " "？"] ; no space after
          ["! " "！"]

          ;; for inside HTML
          [".</" "。</"]
          ["?</" "？</"]
          [":</" "：</"]
          [" " "　"]
          ]
         ))

    (when (string= *to-direction "auto")
      (setq
       *to-direction
       (if
           (or
            (string-match "　" -input-str)
            (string-match "。" -input-str)
            (string-match "，" -input-str)
            (string-match "？" -input-str)
            (string-match "！" -input-str))
           "english"
         "chinese")))
    (save-excursion
      (save-restriction
        (narrow-to-region *begin *end)
        (mapc
         (lambda (-x)
           (progn
             (goto-char (point-min))
             (while (search-forward (aref -x 0) nil "noerror")
               (replace-match (aref -x 1)))))
         (cond
          ((string= *to-direction "chinese") -replacePairs)
          ((string= *to-direction "english") (mapcar (lambda (x) (vector (elt x 1) (elt x 0))) -replacePairs))
          (t (user-error "Your 3rd argument 「%s」 isn't valid" *to-direction))))))))


;;; lib3rd-text.el ends here
