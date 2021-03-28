(require 'ob)

(org-babel-do-load-languages
      'org-babel-load-languages
      '((emacs-lisp . t)
        (R . t)
        (shell . t)))

(setq org-latex-listings 'listings)

(add-to-list 'org-latex-packages-alist '("" "listings"))
(add-to-list 'org-latex-packages-alist '("" "color"))
(add-to-list 'org-latex-packages-alist '("" "graphicx"))

(setq org-latex-listings-options
      '(
        ("breaklines" "true")
        ("breakatwhitespace" "true")
        )
      )
