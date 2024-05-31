;; -*- coding: utf-8; lexical-binding: t -*

(when (window-system)
  (tool-bar-mode -1)
  (scroll-bar-mode -1)
  (tooltip-mode -1))

(setq custom-file (concat user-emacs-directory "/custom.el"))

(setq package-check-signature nil)

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(add-to-list 'package-archives '("ublt" . "https://elpa.ubolonton.org/packages/") t)
(setq package-native-compile t)
(setq use-package-always-ensure t)
(unless (package-installed-p 'use-package)
  (message "refreshing contents")
  (unless package-archive-contents (package-refresh-contents))
  (package-install 'use-package))



(require 'use-package)

(setq gc-cons-threshold 100000000)

(use-package zenburn-theme 
  :config
  (load-theme 'zenburn t))

(setq
 ;; No need to see GNU agitprop.
 ;;inhibit-startup-screen t
 ;; No need to remind me what a scratch buffer is.
 ;;initial-scratch-message nil
 ;; Double-spaces after periods is morally wrong.
 sentence-end-double-space nil
 ;; Never ding at me, ever.
 ring-bell-function 'ignore
 ;; Save existing clipboard text into the kill ring before replacing it.
 save-interprogram-paste-before-kill t
 ;; Prompts should go in the minibuffer, not in a GUI.
 use-dialog-box nil
 ;; Fix undo in commands affecting the mark.
 mark-even-if-inactive nil
 ;; Let C-k delete the whole line.
 kill-whole-line t
 ;; search should be case-sensitive by default
 case-fold-search nil
 ;; no need to prompt for the read command _every_ time
 ;;compilation-read-command nil
 ;; scroll to first error
 compilation-scroll-output 'first-error
 ;; accept 'y' or 'n' instead of yes/no
 ;; the documentation advises against setting this variable
 ;; the documentation can get bent imo
 use-short-answers t
 ;; my source directory
 default-directory "~/repos/"
 ;; eke out a little more scrolling performance
 fast-but-imprecise-scrolling t
 ;; prefer newer elisp files
 load-prefer-newer t
 ;; when I say to quit, I mean quit
 ;;confirm-kill-processes nil
 ;; if native-comp is having trouble, there's not very much I can do
 ;;native-comp-async-report-warnings-errors 'silent
 ;; unicode ellipses are better
 truncate-string-ellipsis "…"
 )

;; Never mix tabs and spaces. Never use tabs, period.
;; We need the setq-default here because this becomes
;; a buffer-local variable when set.
(setq-default indent-tabs-mode nil)

(setq-default js-indent-level 4)

(set-charset-priority 'unicode)
(prefer-coding-system 'utf-8-unix)

(delete-selection-mode t)
(global-display-line-numbers-mode t)
(column-number-mode)

(require 'hl-line)
(add-hook 'prog-mode-hook #'hl-line-mode)
(add-hook 'text-mode-hook #'hl-line-mode)

(setq
 make-backup-files nil
 auto-save-default nil
 create-lockfiles nil)

(use-package recentf
  :pin gnu
  :config
  (recentf-mode))



(use-package magit
  :diminish magit-auto-revert-mode
  :diminish auto-revert-mode
)


;; hack to eliminate weirdness
(unless (boundp 'bug-reference-auto-setup-functions)
  (defvar bug-reference-auto-setup-functions '()))

;(use-package js2-mode
;  :ensure t
;  :mode ("\\.js$" . js2-mode)
;  :hook(js2-mode . js2-minor-mode))

(use-package eglot
  :hook ((go-mode . eglot-ensure)
         (c++-mode . eglot-ensure)
         (c-mode . eglot-ensure)
         (js-mode . eglot-ensure))
  :bind (:map eglot-mode-map
              ("C-c a r" . #'eglot-rename)
              ("C-<down-mouse-1>" . #'xref-find-definitions)
              ("C-S-<down-mouse-1>" . #'xref-find-references)
              ("C-c C-c" . #'eglot-code-actions))
  :custom
  (eglot-autoshutdown t)
  )

(use-package consult-eglot
  :bind (:map eglot-mode-map ("s-t" . #'consult-eglot-symbols)))

 (use-package xref
  :pin gnu
  :bind (("s-r" . #'xref-find-references)
         ("s-[" . #'xref-go-back)
         ("C-<down-mouse-2>" . #'xref-go-back)
         ("s-]" . #'xref-go-forward)))

(use-package eldoc
  :pin gnu
  :diminish
  :bind ("s-d" . #'eldoc)
  :custom (eldoc-echo-area-prefer-doc-buffer t))

(use-package deadgrep
  :bind (("C-c H" . #'deadgrep)))

(use-package visual-regexp
  :bind (("C-c 5" . #'vr/replace)))

(use-package dap-mode
  :bind
  (:map dap-mode-map
   ("C-c b b" . dap-breakpoint-toggle)
   ("C-c b r" . dap-debug-restart)
   ("C-c b l" . dap-debug-last)
   ("C-c b d" . dap-debug))
  :init
  
  ;; NB: dap-go-setup appears to be broken, so you have to download the extension from GH, rename its file extension
  ;; unzip it, and copy it into the config so that the following path lines up
 
  (defun pt/turn-on-debugger ()
    (interactive)
    (dap-mode)
    (dap-auto-configure-mode)
    (dap-ui-mode)
    (dap-ui-controls-mode)
    )
  )

(bind-key "C-." #'completion-at-point)


(use-package restclient
  :mode ("\\.restclient$" . restclient-mode))


(provide 'init)
