(require 'package)
(add-to-list 'package-archives '("org" . "https://orgmode.org/elpa/") t)
(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(package-initialize)

(tool-bar-mode -1)
(add-hook 'emacs-lisp-mode-hook 'paredit-mode)

(global-set-key (kbd "C-x g") 'magit-status)
(global-set-key (kbd "C-x M-g") 'magit-dispatch-popup)
(global-set-key (kbd "C-z") 'list-bookmarks)

(setq-default fill-column 80)
(add-hook 'text-mode-hook 'auto-fill-mode)
(add-hook 'before-save-hook 'delete-trailing-whitespace)
(add-hook 'org-mode-hook 'org-indent-mode)

;; Custum interactive-functions
(defun init-file ()
  "Opens init.el"
  (interactive)
  (find-file "~/.emacs.d/init.el"))

;; Aesthetics
(set-face-attribute 'default nil :font "PragmataPro-13")
(load-theme 'gruvbox t)

;; Deft configuration
(defun launch-deft-in (dir)
  (let (old-dir deft-directory)
    (setq deft-directory dir)
    (deft)
    (setq deft-directory old-dir)))

(global-set-key (kbd "C-$ r") '(lambda () (interactive)(launch-deft-in "~/Dropbox/Reference")))
(global-set-key (kbd "C-$ p") '(lambda () (interactive)(launch-deft-in "~/Dropbox/Perceptron")))
(global-set-key (kbd "C-$ w") '(lambda () (interactive)(launch-deft-in "~/Dropbox/Reference/Work")))

(setq deft-directory "~/Dropbox/Reference")
(setq deft-use-filename-as-title t)
(setq deft-recursive t)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("ce0788113995714fd96970417e8e71d5182d02bc40cc7ffef307f5e01e55942f" "ed2b5df51c3e1f99207074f8a80beeb61757ab18970e43d57dec34fe21af2433" "d411730c6ed8440b4a2b92948d997c4b71332acf9bb13b31e9445da16445fe43" "d677ef584c6dfc0697901a44b885cc18e206f05114c8a3b7fde674fce6180879" default)))
 '(package-selected-packages
   (quote
    (deft magithub magit gruvbox-theme notmuch solarized-theme paredit org-plus-contrib markdown-mode))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
