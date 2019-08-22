(require 'package)
(let* ((no-ssl (and (memq system-type '(windows-nt ms-dos))
                    (not (gnutls-available-p))))
       (proto (if no-ssl "http" "https")))
  (when no-ssl
    (warn "\
Your version of Emacs does not support SSL connections,
which is unsafe because it allows man-in-the-middle attacks.
There are two things you can do about this warning:
1. Install an Emacs version that does support SSL and be safe.
2. Remove this warning from your init file so you won't see it again."))
  ;; Comment/uncomment these two lines to enable/disable MELPA and MELPA Stable as desired
  ;; (add-to-list 'package-archives (cons "melpa" (concat proto "://melpa.org/packages/")) t)
  (add-to-list 'package-archives (cons "melpa-stable" (concat proto "://stable.melpa.org/packages/")) t)
  (when (< emacs-major-version 24)
    ;; For important compatibility libraries like cl-lib
    (add-to-list 'package-archives (cons "gnu" (concat proto "://elpa.gnu.org/packages/")))))
(package-initialize)

(require 'fill-column-indicator)
(setq-default fill-column 80)

(require 'ido)
(ido-mode t)

(require 'xcscope)
;; setq cscope-do-not-update-database t)
(define-key global-map [(control f3)] 'cscope-set-initial-directory)
(define-key global-map [(control f4)] 'cscope-find-this-file)
(define-key global-map [(control f5)] 'cscope-find-this-symbol)
(define-key global-map [(control f6)] 'cscope-find-global-definition)
(define-key global-map [(control f7)] 'cscope-find-this-text-string)
(define-key global-map [(control f8)] 'cscope-pop-mark)
(define-key global-map [(control f9)] 'cscope-find-functions-calling-this-function)
(define-key global-map [(control f10)] 'cscope-find-called-functions)
(define-key global-map [(control f11)] 'cscope-display-buffer)

;; (set-frame-font "-*-DejaVu Sans Mono-normal-normal-normal-*-12-*-*-*-m-0-iso10646-1")
;; (set-frame-font "-*-Menlo-normal-normal-normal-*-13-*-*-*-m-0-iso10646-1")


(column-number-mode t)
(display-time-mode t)
(show-paren-mode t)
(which-function-mode t)

;; Setting relevant only if running in a windowing system 
;; (if (display-graphic-p)
;;     (ns-toggle-toolbar)
;;   )


(setq inhibit-startup-message t) ;; hide the startup message
(load-theme 'solarized-light t) ;; load material theme
;; (global-linum-mode t) ;; enable line numbers globally

;; Needed to locate cscope executable installed with brew before installing
;; exec-path-from-shell
;; (setenv "PATH" (concat (getenv "PATH") ":/usr/local/bin"))
;; (setq exec-path (append exec-path '("/usr/local/bin")))

;; Enable Hide-Show minor mode for C and Python
(add-hook 'c-mode-common-hook 'hs-minor-mode)
(add-hook 'python-mode-hook 'hs-minor-mode)
(add-hook 'dts-mode-hook 'hs-minor-mode)

;; Open files ending in “.ino” in C++ mode
(add-to-list 'auto-mode-alist '("\\.ino\\'" . c++-mode))

(add-to-list 'auto-mode-alist '("defconfig\\'" . conf-mode))

;; Look for a regex at the beginning of file
(add-to-list 'magic-mode-alist '("# Kconfig.+" . conf-mode))


;; Define keyboard shortcut for running compilation
(define-key global-map "\C-xc" 'compile)

;; Automatically revert buffer
(global-auto-revert-mode 1)

;; (add-to-list 'package-archives
;;              '("melpa-stable" . "https://stable.melpa.org/packages/") t)

;; ;;; XEmacs backwards compatibility file
;; (setq user-init-file
;;       (expand-file-name "init.el"
;; 			(expand-file-name ".xemacs" "~")))
;; (setq custom-file
;;       (expand-file-name "custom.el"
;; 			(expand-file-name ".xemacs" "~")))

;; (load-file user-init-file)
;; (load-file custom-file)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(column-number-mode t)
 '(custom-safe-themes
   (quote
    ("8aebf25556399b58091e533e455dd50a6a9cba958cc4ebb0aab175863c25b9a4" "d677ef584c6dfc0697901a44b885cc18e206f05114c8a3b7fde674fce6180879" default)))
 '(display-time-mode t)
 '(electric-pair-mode t)
 '(package-selected-packages
   (quote
    (racer flycheck-rust cargo company-racer flymd markdown-preview-mode markdown-mode php-mode exec-path-from-shell autopair elpy use-package yaml-mode cmake-mode dts-mode xcscope fill-column-indicator solarized-theme rust-mode)))
 '(show-paren-mode t)
 '(solarized-distinct-fringe-background t)
 '(tool-bar-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(font-lock-doc-face ((t (:foreground "#93a1a1" :slant normal)))))

(package-initialize)
(elpy-enable)

(exec-path-from-shell-initialize)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Company                                                                  ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Enable globally
(add-hook 'after-init-hook 'global-company-mode)

;; No delay in showing suggestions.
(setq company-idle-delay 0)

;; Show suggestions after entering one character.
(setq company-minimum-prefix-length 1)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Rust                                                                     ;;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(add-hook 'rust-mode-hook #'racer-mode)
(add-hook 'rust-mode-hook 'electric-pair-mode)
(add-hook 'rust-mode-hook 'cargo-minor-mode)

;; Indent current buffer with C-c <tab> (relies on rustfmt)
(add-hook 'rust-mode-hook
          (lambda ()
            (local-set-key (kbd "C-c <tab>") #'rust-format-buffer)))

(add-hook 'racer-mode-hook #'eldoc-mode)
(add-hook 'racer-mode-hook #'company-mode)

(require 'rust-mode)
(define-key rust-mode-map (kbd "TAB") #'company-indent-or-complete-common)
(setq company-tooltip-align-annotations t)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Flycheck                                                                 ;;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(add-hook 'flycheck-mode-hook #'flycheck-rust-setup)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Themes                                                                   ;;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(custom-set-variables '(solarized-distinct-fringe-background t))
