;; http://tools.ietf.org/html/rfc2396 (2.3节)
;; rfc2396 "-_.!~*'()"
(defconst mm-url-unreserved-chars
  '(?a ?b ?c ?d ?e ?f ?g ?h ?i ?j ?k ?l ?m ?n ?o ?p ?q ?r ?s ?t ?u ?v ?w ?x ?y ?z
       ?A ?B ?C ?D ?E ?F ?G ?H ?I ?J ?K ?L ?M ?N ?O ?P ?Q ?R ?S ?T ?U ?V ?W ?X ?Y ?Z
       ?0 ?1 ?2 ?3 ?4 ?5 ?6 ?7 ?8 ?9
       ?- ?_ ?. ?! ?~ ?* ?' ?\( ?\))
  "A list of characters that are _NOT_ reserved in the URL spec.
This is taken from RFC 2396.")

;; http://www.gnu.org/software/emacs/manual/html_node/elisp/String-Conversion.html
;; 查某个character的unicode ?a 反之 (byte-to-string 97)

(defconst java-special-characters '(?. ?- ?* ?_))
;; java里的special characters ".", "-", "*", and "_"
;;                            46   45   42      95
;; 见: http://docs.oracle.com/javase/7/docs/api/java/net/URLEncoder.html
;; java采用了 rfc2396
;; http://www.w3.org/TR/html40/appendix/notes.html#non-ascii-chars

;; 注意：elisp里的实现采用的是 https://www.ietf.org/rfc/rfc3986.txt  (2.3节)
;;      rfc3986 obsoletes [RFC2396]
;; unreserved  = ALPHA / DIGIT / "-" / "." / "_" / "~"
;; a-zA-Z0-9 及 special-characters 为 "-" "_" "." "~"
;;                                    45  95  46 126

;; 把系统的url-unreserved-chars值backup起来
(setq ab/bak-url-unreserved-chars url-unreserved-chars)

;; 按java的格式编码url
(defun ab/url-encode-java (url)
  (interactive)
  (setq url-unreserved-chars mm-url-unreserved-chars)
  (url-hexify-string url))

(defun dp/url-encode (url)
  (interactive)
  (concat "dianping://web?url=" (ab/url-encode-java url)))

;; 按elisp的默认方式编码url
(defun ab/url-encode-default (url)
  (setq url-unreserved-chars ab/bak-url-unreserved-chars)
  (url-hexify-string url))

(provide 'web-utils)
