;;START global config

;;loading packages
(require 'package)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/") t)
(package-initialize)
(when (not package-archive-contents)
  (package-refresh-contents))
(unless (package-installed-p 'use-package)
  (package-install 'use-package))
(require 'use-package)
(setq use-package-always-ensure t)
(add-to-list 'load-path "~/.emacs.d/custom")
(require 'setup-general)
(if (version< emacs-version "24.4")
    (require 'setup-ivy-counsel)
  (require 'setup-helm)
  (require 'setup-helm-gtags))
(require 'setup-cedet)
(require 'setup-editing)
(require 'company)
(add-hook 'after-init-hook 'global-company-mode)
(setq company-backends (delete 'company-semantic company-backends))
(add-to-list 'company-backends 'company-c-headers)
(require 'clean-aindent-mode)
(add-hook 'prog-mode-hook 'clean-aindent-mode)
(require 'dtrt-indent)
(dtrt-indent-mode 1)
(setq dtrt-indent-verbosity 0)
(require 'ws-butler)
(add-hook 'c-mode-common-hook 'ws-butler-mode)
(require 'yasnippet)
(yas-global-mode 1)
(require 'smartparens-config)
(show-smartparens-global-mode +1)
(smartparens-global-mode 1)
(require 'function-args)
(fa-config-default)
(require 'setup-helm)
(require 'helm-gtags)
(define-key helm-gtags-mode-map (kbd "C-c g a") 'helm-gtags-tags-in-this-function)
(define-key helm-gtags-mode-map (kbd "C-j") 'helm-gtags-select)
(define-key helm-gtags-mode-map (kbd "M-.") 'helm-gtags-dwim)
(define-key helm-gtags-mode-map (kbd "M-,") 'helm-gtags-pop-stack)
(define-key helm-gtags-mode-map (kbd "C-c <") 'helm-gtags-previous-history)
(define-key helm-gtags-mode-map (kbd "C-c >") 'helm-gtags-next-history)
(setq
 helm-gtags-ignore-case t
 helm-gtags-auto-update t
 helm-gtags-use-input-at-cursor t
 helm-gtags-pulse-at-cursor t
 helm-gtags-prefix-key "\C-cg"
 helm-gtags-suggested-key-mapping t
 )
(setq-local imenu-create-index-function #'ggtags-build-imenu-index)
(require 'cc-mode)
(require 'semantic)
(global-semanticdb-minor-mode 1)
(global-semantic-idle-scheduler-mode 1)
(semantic-add-system-include "/usr/local/include")
(semantic-add-system-include "~/linux/include")
(semantic-mode 1)
(global-semantic-idle-summary-mode 1)
(add-to-list 'semantic-default-submodes 'global-semantic-stickyfunc-mode)
(require 'ede)
(global-ede-mode)
(require 'stickyfunc-enhance)
(setq-local eldoc-documentation-function #'ggtags-eldoc-function)
(projectile-global-mode)
(require 'better-defaults)
(require 'flycheck)
(global-flycheck-mode)
(require 'elpy)
(require 'py-autopep8)
(require 'ein)
(require 'flycheck)
(require 'flymake)

;; indentation
(global-set-key (kbd "RET") 'newline-and-indent)                                       ;; automatically indent when press RET
(global-set-key (kbd "C-c w") 'whitespace-mode)                                        ;; activate whitespace-mode to view all whitespace characters
(add-hook 'prog-mode-hook (lambda () (interactive) (setq show-trailing-whitespace 1))) ;; show unncessary whitespace that can mess up your diff
(setq-default indent-tabs-mode nil)                                                    ;; use space to indent by default
(setq-default tab-width 4)                                                             ;; set appearance of a tab that is represented by 4 spaces
(sp-with-modes '(c-mode c++-mode)                                                      ;; when you press RET, the curly braces automatically add another newline
  (sp-local-pair "{" nil :post-handlers '(("||\n[i]" "RET")))
  (sp-local-pair "/*" "*/" :post-handlers '((" | " "SPC")
                                            ("* ||\n[i]" "RET"))))
;; compilation support
(global-set-key (kbd "<f5>") (lambda ()
                               (interactive)
                               (setq-local compilation-read-command nil)
                               (call-interactively 'compile)))

;;layout
(setq
 gdb-many-windows t                                                                     ;; use gdb-many-windows by default
 gdb-show-main t                                                                        ;; Non-nil means display source file containing the main routine at startup
 )

;;speedbar config
(setq speedbar-show-unknown-files t)
(setq speedbar-directory-unshown-regexp "^\\(CVS\\|RCS\\|SCCS\\|\\.\\.*$\\)\\'")
(add-hook 'emacs-startup-hook (lambda ()
                                (sr-speedbar-open)
                                ))
(setq sr-speedbar-right-side nil)                                                       ;; put speedbar on left side

;;themeing
(load-theme 'gruvbox t)
(require 'nyan-mode)
(nyan-mode)
(setq inhibit-startup-message t)
(global-linum-mode t)

;;END global config

;;c++ config
(add-hook 'c++-mode-hook 'helm-gtags-mode)
(define-key c++-mode-map  [(tab)] 'company-complete)

;;c config
(add-hook 'c-mode-hook 'helm-gtags-mode)
(define-key c-mode-map  [(tab)] 'company-complete)

;;python config
(elpy-enable)
(when (require 'flycheck nil t)
  (setq elpy-modules (delq 'elpy-module-flymake elpy-modules))
  (add-hook 'elpy-mode-hook 'flycheck-mode))
(add-hook 'elpy-mode-hook 'py-autopep8-enable-on-save)
(setq python-shell-interpreter "ipython"
      python-shell-interpreter-args "-i --simple-prompt")

;;dired config
(add-hook 'dired-mode-hook 'helm-gtags-mode)

;;eshell config
(add-hook 'eshell-mode-hook 'helm-gtags-mode)

;;asm config
(add-hook 'asm-mode-hook 'helm-gtags-mode)

;;latex mode
(setq TeX-auto-save t)
(setq TeX-parse-self t)
(setq TeX-save-query nil)
(defun flymake-get-tex-args (file-name)
  (list "pdflatex"
        (list "-file-line-error" "-draftmode" "-interaction=nonstopmode" file-name)))
(add-hook 'LaTeX-mode-hook 'flymake-mode)
(setq ispell-program-name "aspell")
(setq ispell-dictionary "english")
(add-hook 'LaTeX-mode-hook 'flyspell-mode)
(add-hook 'LaTeX-mode-hook 'flyspell-buffer)
(defun turn-on-outline-minor-mode ()
  (outline-minor-mode 1))
(add-hook 'LaTeX-mode-hook 'turn-on-outline-minor-mode)
(add-hook 'latex-mode-hook 'turn-on-outline-minor-mode)
(setq outline-minor-mode-prefix "\C-c \C-o")
(require 'tex-site)
(autoload 'reftex-mode "reftex" "RefTeX Minor Mode" t)
(autoload 'turn-on-reftex "reftex" "RefTeX Minor Mode" nil)
(autoload 'reftex-citation "reftex-cite" "Make citation" nil)
(autoload 'reftex-index-phrase-mode "reftex-index" "Phrase Mode" t)
(add-hook 'latex-mode-hook 'turn-on-reftex)
(add-hook 'reftex-load-hook 'imenu-add-menubar-index)
(add-hook 'LaTeX-mode-hook 'turn-on-reftex)
(setq LaTeX-eqnarray-label "eq"
      LaTeX-equation-label "eq"
      LaTeX-figure-label "fig"
      LaTeX-table-label "tab"
      LaTeX-myChapter-label "chap"
      TeX-auto-save t
      TeX-newline-function 'reindent-then-newline-and-indent
      TeX-parse-self t
      TeX-style-path
      '("style/" "auto/"
        "/usr/share/emacs21/site-lisp/auctex/style/"
        "/var/lib/auctex/emacs21/"
        "/usr/local/share/emacs/site-lisp/auctex/style/")
      LaTeX-section-hook
      '(LaTeX-section-heading
        LaTeX-section-title
        LaTeX-section-toc
        LaTeX-section-section
        LaTeX-section-label))

(custom-set-variables

 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (helm-flymake flymake-shell auctex haskell-emacs ein py-autopep8 elpy flycheck-haskell flycheck gruvbox-theme nyan-mode ## sr-speedbar zygospore helm-gtags helm yasnippet ws-butler volatile-highlights use-package undo-tree iedit dtrt-indent counsel-projectile company clean-aindent-mode anzu))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
