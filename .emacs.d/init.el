(add-to-list 'load-path "~/.emacs.d/elegant-emacs")
(require 'elegance)
(require 'sanity)

;; Older Stuff

;; Require Emacs' package functionality
(require 'package)
;; (set package-enable-at-startup nil)

;; Add the Melpa repository to the list of package sources
(add-to-list 'package-archives
 	'("melpa" . "http://melpa.org/packages/") t)
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(use-package which-key
  :ensure t
  :init
  (which-key-mode))

(use-package ivy
  :ensure t)

(use-package hydra
  :ensure t)

;; GUI PREFERENCES
  ;; disable menu-bar
  (menu-bar-mode -1)
  ;; disable scroll-bar
  (toggle-scroll-bar -1)
  ;; disable tool-nar
  (tool-bar-mode -1)
  ;; enable line numbers
  (global-linum-mode 1)
  ;; make the left fringe 4 pixels wide and the right disappear
  (fringe-mode '(4 . 0))
  ;; Only type in GPG password when opening
  (setq epa-file-cache-passphrase-for-symmetric-encryption t)
  ;; Set Tabs to 4
  (setq-default tab-width 4) ; Assuming you want your tabs to be four spaces wide
  (setq-default indent-tabs-mode 'only)
  (defvaralias 'c-basic-offset 'tab-width)
  ;; Allow highlighted text to be deleted
  (delete-selection-mode 1)
  ;; change prompt to y/n instead of longer yes/no
  (defalias 'yes-or-no-p 'y-or-n-p)
  ;; use Ctrl+x followed by Ctrl+k to kill current buffer (no choose prompt)
  (global-set-key [(control x) (control k)] 'kill-this-buffer)
  ;; call ibuffer (buffers list) with Ctrl+x followed by Ctrl+b
  (global-set-key (kbd "C-x C-b") 'ibuffer)
  ;; set scroll not to be so fast
  ;;(setq scroll-conservatively 100)

;; MY CONFIGS
(ivy-mode 1)
(setq ivy-use-virtual-buffers t)
(setq enable-recursive-minibuffers t)

;; the following functions add autocomplete functionality for parenthesis and quotes
  (setq skeleton-pair t)
  (defvar skeletons-alist
    '((?\( . ?\))
      (?\" . ?\")
      (?[  . ?])
      (?{  . ?})
      (?$  . ?$)))

  (global-set-key (kbd "(") 'skeleton-pair-insert-maybe)
  (global-set-key (kbd "[") 'skeleton-pair-insert-maybe)
  (global-set-key (kbd "\"") 'skeleton-pair-insert-maybe)
  (global-set-key (kbd "\'") 'skeleton-pair-insert-maybe)

(defadvice delete-backward-char (before delete-empty-pair activate)
  (if (eq (cdr (assq (char-before) skeletons-alist)) (char-after))
      (and (char-after) (delete-char 1))))

(defadvice backward-kill-word (around delete-pair activate)
  (if (eq (char-syntax (char-before)) ?\()
      (progn
 (backward-char 1)
 (save-excursion
   (forward-sexp 1)
   (delete-char -1))
 (forward-char 1)
 (append-next-kill)
 (kill-backward-chars 1))
    ad-do-it))

;; the following turns C-g into a onetime-buffer-killer
(advice-add #'undefined :override #'keyboard-quit)

;; turn off backups
(setq make-backup-files nil)

;; ask for password in the minibuffer
(setq epa-pinentry-mode 'loopback)

;; auto-re-encrypt gpg files
(setq epa-file-cache-passphrase-for-symmetric-encryption t)

;; start emacs in server-mode
(server-start)

;; iflipb keybinds
(global-set-key (kbd "<C-tab>") 'iflipb-next-buffer)
(global-set-key
 (if (featurep 'xemacs) (kbd "<C-iso-left-tab>") (kbd "<C-S-iso-lefttab>"))
 'iflipb-previous-buffer)
(setq iflipb-wrap-around 1)

;;; Other Window/Buffer
;; http://emacs.stackexchange.com/q/22226/115
(defhydra hydra-other-window-buffer
  (global-map "C-x"
              :color red)
  "other window/buffer"
  ;; ("<right>" other-window "→win")
  ;; ("<left>" (lambda () (interactive) (other-window -1)) "win←")
  ("<C-right>" next-buffer "→buf")
  ("<C-left>" previous-buffer "buf←"))

;; reopen last killed file using Ctrl+Shift+t shortcut
(require 'cl)
(require 'recentf)

(defun find-last-killed-file ()
  (interactive)
  (let ((active-files (loop for buf in (buffer-list)
                            when (buffer-file-name buf) collect it)))
    (loop for file in recentf-list
          unless (member file active-files) return (find-file file))))

(define-key global-map (kbd "C-S-t") 'find-last-killed-file)
