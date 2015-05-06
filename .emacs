(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(column-number-mode t)
 '(custom-safe-themes (quote ("41b6698b5f9ab241ad6c30aea8c9f53d539e23ad4e3963abff4b57c0f8bf6730" default)))
 '(display-time-mode t)
 '(inhibit-startup-screen t)
 '(show-paren-mode t)
 '(size-indication-mode t)
 '(tool-bar-mode nil)
 '(transient-mark-mode (quote (only . t))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(when (>= emacs-major-version 24)
  (require 'package)
  (package-initialize)
  (add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)

  ;; set up theme
  (load-theme 'monokai t)
  ;(load-theme 'base16-tomorrow t)
)

;; disable internationalization so we can use the meta key in console mode
(unless window-system 'set-keyboard-coding-system nil)

(when window-system
  ;; set the window size (and font) to a larger default
  (set-frame-size (selected-frame) 100 40)
  (set-face-attribute 'default nil :height 150)
  
  (defadvice yes-or-no-p (around prevent-dialog activate)
    "Prevent yes-or-no-p from activating a dialog"
    (let ((use-dialog-box nil))
      ad-do-it))
  (defadvice y-or-n-p (around prevent-dialog-yorn activate)
    "Prevent y-or-n-p from activating a dialog"
    (let ((use-dialog-box nil))
      ad-do-it))
  )


;; helm setup
(add-to-list 'load-path "~/.emacs.d/emacs-helm")
(add-to-list 'load-path "~/.emacs.d/helm")
(require 'helm-config)
(helm-mode 1)
(global-set-key (kbd "M-x") 'helm-M-x)


;; set up autocomplete
(add-to-list 'load-path "~/.emacs.d/")
(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "~/.emacs.d//ac-dict")
(ac-config-default)


;; jsmode setup
(add-to-list 'load-path "~/.emacs.d/elpa/js2-mode-20150503.617")
(add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))


;; Tern is an intelligent tool to help with javascript autocomplete
;; set up autocomplete for tern
(add-to-list 'load-path "~/.emacs.d/tern/emacs")
(eval-after-load 'tern
  '(progn
    (require 'tern-auto-complete)
    (tern-ac-setup)))
(autoload 'tern-mode "tern.el" nil t)
(add-hook 'js-mode-hook (lambda () (tern-mode t)))


;; javascript code should be indented with spaces
(add-hook 'js-mode-hook (lambda () 
			  (setq-default indent-tabs-mode nil)))


;; Show markers for code-folding
(autoload 'hideshowvis-enable "hideshowvis" "Highlight foldable regions")
(autoload 'hideshowvis-minor-mode
  "hideshowvis"
  "Will indicate regions foldable with hideshow in the fringe."
  'interactive)
(dolist (hook (list 'emacs-lisp-mode-hook
                    'c++-mode-hook))
  (add-hook hook 'hideshowvis-enable))


;; Hinting and linting for javascript
;; (requires jshint: npm install -g jshint)
(add-to-list 'load-path "~/.emacs.d/flymake-node-jshint")
(require 'flymake-node-jshint)
; (setq flymake-node-jshint-config "~/.emacs.d/.jshintrc-node.json") ; optional
(add-hook 'js-mode-hook (lambda () (flymake-mode 1)))


;; set up the beautifier for web languages
(require 'web-beautify) ;; Not necessary if using ELPA package
(eval-after-load 'js2-mode
  '(define-key js2-mode-map (kbd "C-c b") 'web-beautify-js))
(eval-after-load 'json-mode
  '(define-key json-mode-map (kbd "C-c b") 'web-beautify-js))
(eval-after-load 'sgml-mode
  '(define-key html-mode-map (kbd "C-c b") 'web-beautify-html))
(eval-after-load 'css-mode
  '(define-key css-mode-map (kbd "C-c b") 'web-beautify-css))


;; web mode for web templating in html (like with ejs and php and angular)
(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.[agj]sp\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.ejs\\'" . web-mode))


;; markdown mode
(autoload 'markdown-mode "markdown-mode"
  "Major mode for editing Markdown files" t)
(add-to-list 'auto-mode-alist '("\\.text\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))


;; groovy mode
;;; turn on syntax highlighting
(global-font-lock-mode 1)


;;; use groovy-mode when file ends in .groovy or has #!/bin/groovy at start
(autoload 'groovy-mode "groovy-mode" "Major mode for editing Groovy code." t)
(add-to-list 'auto-mode-alist '("\.groovy$" . groovy-mode))
(add-to-list 'interpreter-mode-alist '("groovy" . groovy-mode))


;;; also use it for gradle files
(add-to-list 'auto-mode-alist '("\.gradle$" . groovy-mode))
(add-to-list 'interpreter-mode-alist '("gradle" . groovy-mode))


;;; make Groovy mode electric by default.
(add-hook 'groovy-mode-hook
          '(lambda ()
             (require 'groovy-electric)
             (groovy-electric-mode)))


;;; racer - rust autocompletion
(add-to-list 'load-path "~/Documents/Scripts/racer/src/etc/emacs/")
(autoload 'rust-mode "rust-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.rs\\'" . rust-mode))
(setq racer-rust-src-path "~/Documents/Scripts/racer/src/")
(setq racer-cmd "~/Documents/Scripts/racer/bin/racer")
(add-to-list 'load-path "~/Documents/Scripts/racer/editors")
(eval-after-load "rust-mode" '(require 'racer))


;; set up workgroups.el for window layout
;; (add-to-list 'load-path "~/.emacs.d/workgroups.el/")
;; (require 'workgroups)


;;; set up cider
(add-hook 'cider-mode-hook #'eldoc-mode)
(add-to-list 'load-path "~/bin")
(setq cider-lein-command "~/bin/lein")


;; set up c programming mode
(setq c-default-style "k&r" c-basic-offset 4)

;; On OSX, move the ctrl key to fn key
(setq ns-function-modifier 'control)


;; a better modeline
(add-to-list 'load-path "~/.emacs.d/powerline")
(require 'powerline)
(powerline-default-theme)


;; file explorer support
(add-to-list 'load-path "~/.emacs.d/neotree")
(require 'neotree)
(global-set-key [f8] 'neotree-toggle)
