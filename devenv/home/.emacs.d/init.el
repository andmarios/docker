;; -*- mode: emacs-lisp -*-
;; Simple .emacs configuration

;; ---------------------
;; -- Global Settings --
;; ---------------------
(add-to-list 'load-path "~/.emacs.d/lisp")
(setq package-list '(cl ido ffap ansi-color recentf linum smooth-scrolling
                        whitespace yaml-mode go-mode auto-complete adoc-mode
                        go-autocomplete sws-mode jade-mode web-mode flycheck
                        scala-mode2 dockerfile-mode markdown-mode+ ensime
                        ac-html ac-html-bootstrap ac-html-csswatcher go-eldoc
                        apache-mode nginx-mode ansible ansible-doc))

;; list the repositories containing them
(setq package-archives '(("melpa" . "http://melpa.org/packages/")
                         ("gnu" . "http://elpa.gnu.org/packages/")
                         ("marmalade" . "http://marmalade-repo.org/packages/")))

;; activate all the packages (in particular autoloads)
(package-initialize)

;; fetch the list of packages available
(unless package-archive-contents
  (package-refresh-contents))

;; install the missing packages
(dolist (package package-list)
  (unless (package-installed-p package)
        (package-install package)))

(require 'cl)
(require 'ido)
(require 'ffap)
(require 'uniquify)
(require 'ansi-color)
(require 'recentf)
(require 'linum)
(require 'smooth-scrolling)
(require 'whitespace)
(require 'dired-x)
(require 'compile)
(require 'scala-mode2)
(require 'dockerfile-mode)
(require 'markdown-mode+)
(require 'ansible-doc)
;;(require 'magit)
;;(setq magit-last-seen-setup-instructions "1.4.0")
(require 'adoc-mode)

(ido-mode t)
(menu-bar-mode -1)
(setq column-number-mode t)
(setq-default show-trailing-whitespace t)
(setq suggest-key-bindings t)

;; ------------
;; -- Macros --
;; ------------
(global-set-key "\M-n" 'next5)
(global-set-key "\M-p" 'prev5)
(global-set-key "\M-o" 'other-window)
;;(global-set-key "\C-z" 'zap-to-char)
;;(global-set-key "\C-h" 'backward-delete-char)
(global-set-key "\M-d" 'delete-word)
(global-set-key "\M-h" 'backward-delete-word)
;;(global-set-key "\M-u" 'zap-to-char)
;;(global-set-key (kbd "<home>") 'beginning-of-line)
(global-set-key [select] 'end-of-line)

;; ---------------------------
;; -- JS Mode configuration --
;; ---------------------------
(require 'sws-mode)
(require 'jade-mode)
(add-to-list 'auto-mode-alist '("\\.styl$" . sws-mode))
(add-to-list 'auto-mode-alist '("\\.jade$" . jade-mode))

;; By AndMarios
;; Indentation with spaces by 2 and tab will insert 4 spaces
(setq c-basic-indent 2)
(setq tab-width 4)
(setq-default indent-tabs-mode nil)
(global-set-key "\M-m" 'hippie-expand)


;; By AndMarios
(require 'web-mode)
(require 'ac-html)
(require 'ac-html-bootstrap)
(require 'ac-html-csswatcher)
(add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.jsp\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))
(setq web-mode-engines-alist
      '(("php"    . "\\.phtml\\'")
        ("blade"  . "\\.blade\\.")
        ("html"   . "\\.html\\'")
        ("html"   . "\\.htm\\'")))
(setq web-mode-enable-css-colorization t)
(setq web-mode-enable-current-element-highlight t)
(setq web-mode-enable-current-column-highlight t)
(add-to-list 'ac-modes 'web-mode)
(add-hook 'html-mode-hook 'ac-html-enable)
(add-to-list 'web-mode-ac-sources-alist
             '("html" . (ac-source-html-attribute-value
                         ac-source-html-tag
                         ac-source-html-attribute)))

(autoload 'php-mode "php-mode" "Major mode for editing php code." t)
(add-to-list 'auto-mode-alist '("\\.php$" . php-mode))
(add-to-list 'auto-mode-alist '("\\.inc$" . php-mode))

(autoload 'markdown-mode "markdown-mode"
   "Major mode for editing Markdown files" t)
(add-to-list 'auto-mode-alist '("\\.text\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))

;Enable these manually when you have installed needed units.
(require 'go-mode)
(require 'auto-complete)
(require 'go-autocomplete)
(require 'auto-complete-config)
(ac-config-default)
(global-auto-complete-mode t)
(require 'go-eldoc) ;; Don't need to require, if you install by package.el
(add-hook 'go-mode-hook 'go-eldoc-setup)
(load-file "$GOPATH/src/golang.org/x/tools/cmd/oracle/oracle.el")
(defun my-go-mode-hook ()
  (setq gofmt-command "goimports")
  (setq flycheck-mode t)
  (setq yas-minor-mode t)
  ;; Call Gofmt before saving
  (add-hook 'before-save-hook 'gofmt-before-save)
  ;; Customize compile command to run go build
  (if (not (string-match "go" compile-command))
      (set (make-local-variable 'compile-command)
           "go build -v && go test -v && go vet"))
  ;; add go snippets
  (add-to-list 'yas-snippet-dirs "~/.emacs.d/yasnippet-golang")
  ;; Godef jump key binding
  (local-set-key (kbd "M-.") 'godef-jump)
  )
(add-hook 'go-mode-hook 'my-go-mode-hook)

;(require 'site-gentoo)

;(require 'org)
;(define-key global-map "\C-cl" 'org-store-link)
;(define-key global-map "\C-ca" 'org-agenda)
;(setq org-log-done t)

(load "yaml-mode.el")

;; Associate tmpl (golang's templates) with web mode:
(add-to-list 'auto-mode-alist '("\\.tmpl\\'" . web-mode))

(require 'ensime)
(add-hook 'scala-mode-hook 'ensime-scala-mode-hook)

(add-to-list 'auto-mode-alist '("\\.adoc$" . adoc-mode))
(add-to-list 'auto-mode-alist '("\\.asciidoc$" . adoc-mode))

(require 'org)
(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)
(setq org-log-done t)

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(popup-face ((t (:background "white" :foreground "black"))))
 '(popup-summary-face ((t (:inherit popup-face :foreground "blue")))))
