(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(company-backends
   (quote
    (company-bbdb company-nxml company-css company-eclim company-semantic company-clang company-xcode company-cmake company-capf company-files
		  (company-dabbrev-code company-gtags company-etags company-keywords)
		  company-oddmuse company-dabbrev)))
 '(custom-safe-themes
   (quote
    ("a8245b7cc985a0610d71f9852e9f2767ad1b852c2bdea6f4aadc12cce9c4d6d0" "d91ef4e714f05fff2070da7ca452980999f5361209e679ee988e3c432df24347" "0598c6a29e13e7112cfbc2f523e31927ab7dce56ebb2016b567e1eff6dc1fd4f" default)))
 '(package-selected-packages
   (quote
    (flycheck-rust flycheck cargo racer rust-mode yasnippet elpy use-package company flymd markdown-mode dts-mode fill-column-indicator solarized-theme xcscope)))
 '(solarized-distinct-fringe-background t)
 '(tool-bar-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "DejaVu Sans Mono" :foundry "PfEd" :slant normal :weight normal :height 98 :width normal)))))

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

;; Ido mode
(setq ido-enable-flex-matching t)
;; (setq ido-everywhere t)
(ido-mode 1)

;; Automatically revert buffer
(global-auto-revert-mode 1)

;; Highlight matching paren
(show-paren-mode t)

;; Minor modes for C programming
(add-hook 'c-mode-common-hook 'hs-minor-mode)
(add-hook 'c-mode-common-hook 'column-number-mode)
(add-hook 'c-mode-common-hook 'electric-pair-mode)

;; Default value of 80 for column width indicator
(require 'fill-column-indicator)
(setq-default fill-column 80)

;; Keyboard shorcut for C program compilation
(define-key global-map "\C-xc" 'compile)

;; Display function name in status bar
(which-function-mode t)

;; Linux kernel code layout settings
(setq comment-style 'multi-line)
(setq comment-style 'extra-line)
(setq c-default-style '((other . "linux")))

;; cscope-related settings
(require 'xcscope)
(setq cscope-do-not-update-database t)
(define-key global-map [(control f3)] 'cscope-set-initial-directory)
(define-key global-map [(control f4)] 'cscope-find-this-file)
(define-key global-map [(control f5)] 'cscope-find-this-symbol)
(define-key global-map [(control f6)] 'cscope-find-global-definition)
(define-key global-map [(control f7)] 'cscope-find-this-text-string)
(define-key global-map [(control f8)] 'cscope-pop-mark)
(define-key global-map [(control f9)] 'cscope-find-functions-calling-this-function)
(define-key global-map [(control f10)] 'cscope-find-called-functions)
(define-key global-map [(control f11)] 'cscope-display-buffer)

;; (cscope-set-initial-directory "/home/godzilla/RIVA_FIRMWARE/Workspace/AsicMeter-Dev/build_armv7l-timesys-linux-uclibcgnueabi/linux-4.4")

;; (visit-tags-table "/home/godzilla/RIVA_FIRMWARE/Workspace/AsicMeter-Dev/build_armv7l-timesys-linux-uclibcgnueabi/linux-4.4/TAGS")

(add-hook 'after-init-hook 'global-company-mode)

;; https://www.monolune.com/configuring-company-mode-in-emacs/

;; No delay in showing suggestions.
(setq company-idle-delay 0)

;; Show suggestions after entering one character.
(setq company-minimum-prefix-length 1)

;; Use tab key to cycle through suggestions.
;; ('tng' means 'tab and go')
(company-tng-configure-default)

(use-package elpy
  :ensure t
  :init
  (elpy-enable))

;; Minor modes for Python
(add-hook 'python-mode-hook 'hs-minor-mode)
(add-hook 'python-mode-hook 'electric-pair-mode)

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

;; Determine source path with "echo `rustc --print sysroot`/lib/rustlib/src/rust/src"
(setq racer-rust-src-path "/home/godzilla/.rustup/toolchains/stable-x86_64-unknown-linux-gnu/lib/rustlib/src/rust/src")

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
