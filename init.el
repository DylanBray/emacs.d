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

(condition-case nil
      ;; (set-frame-font "Iosevka SS09-12")
      ;; (set-frame-font "Go Mono-11")
      ;; (set-frame-font "Fira Mono-11")
      ;; (set-frame-font "Inconsolata-13")
      ;; (set-frame-font "Monospace-11")
      ;; (set-frame-font "Ubuntu Mono-13")
      ;; (set-frame-font "IBM Plex Mono-13")
      ;; (set-frame-font "Cascadia Code-14")
      ;; (set-frame-font "Jetbrains Mono-11")
      ;; (set-frame-font "Monaco-11")
         (set-frame-font "Martian Mono")
      ;; (set-frame-font "Dina-10")
      ;; (set-frame-font "iAWriterDuospace-13")
      ;; (set-frame-font "Hermit-13")
      ;; (set-frame-font "Menlo-11")
      ;; (set-frame-font "Hack-14")
      ;;(set-frame-font "LM Mono 10")
    (error (set-frame-font "Monospace-11")))

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
 create-lockfiles nil
 isearch-lazy-count t)

(setq
 backup-directory-alist `(("." . "~/.emacs.d/backups/"))
 backup-by-copying t
 delete-old-versions t
 kept-new-versions 6
 kept-old-versions 2
 version-control t)

(setq auto-save-file-name-transforms
      `((".*" "~/.emacs.d/autosaves/" t)))

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

(use-package eglot
  :hook ((go-mode . eglot-ensure)
         (c++-mode . eglot-ensure)
         (c-mode . eglot-ensure)
         (js-mode . eglot-ensure)
         (java-mode . eglot-ensure)
         (terraform-mode . eglot-ensure))
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

(bind-key "C-." #'completion-at-point)

(add-to-list 'eglot-server-programs
             `((java-mode java-ts-mode) .
               ("/opt/jdtls/bin/jdtls"
                :initializationOptions
                (:bundles ["/opt/java-debug-0.52.0/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-0.52.0.jar"])))
             )

(use-package dape
 ; :preface
  ;; By default dape shares the same keybinding prefix as `gud'
  ;; If you do not want to use any prefix, set it to nil.
  ;; (setq dape-key-prefix "\C-x\C-a")

  :hook
  ;; Save breakpoints on quit
   ((kill-emacs . dape-breakpoint-save)
  ;; Load breakpoints on startup
    (after-init . dape-breakpoint-load))

  ;:init
  ;; To use window configuration like gud (gdb-mi)
  ;; (setq dape-buffer-window-arrangement 'gud)

   :config
  ;; Info buffers to the right
   (setq dape-buffer-window-arrangement 'right)

  ;; Global bindings for setting breakpoints with mouse
   (dape-breakpoint-global-mode)

  ;; To not display info and/or buffers on startup
  ;; (remove-hook 'dape-on-start-hooks 'dape-info)
  ;; (remove-hook 'dape-on-start-hooks 'dape-repl)

  ;; To display info and/or repl buffers on stopped
  ;; (add-hook 'dape-on-stopped-hooks 'dape-info)
  ;; (add-hook 'dape-on-stopped-hooks 'dape-repl)

  ;; Kill compile buffer on build success
  ;; (add-hook 'dape-compile-compile-hooks 'kill-buffer)

  ;; Save buffers on startup, useful for interpreted languages
  ;; (add-hook 'dape-on-start-hooks (lambda () (save-some-buffers t t)))

  ;; Projectile users
  ;; (setq dape-cwd-fn 'projectile-project-root)
   )

(use-package company
  :config
  (global-company-mode t))


(use-package sql-indent)

(use-package terraform-mode)


(use-package dockerfile-mode
  :ensure t
  :mode ("Dockerfile\\'" . dockerfile-mode))
(use-package sql-indent)



(use-package restclient
  :mode ("\\.restclient$" . restclient-mode))

(use-package chess)

(provide 'init)
