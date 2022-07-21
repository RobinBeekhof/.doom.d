;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Robin Beekhof"
      user-mail-address "rbeekhof@gmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; (setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 13))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-outrun-electric)



;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)


;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

(map! :leader
      (:prefix ("d" . "dired")
       :desc "Open dired" "d" #'dired
       :desc "Dired jump to current" "j" #'dired-jump)
      (:after dired
       (:map dired-mode-map
        :desc "Peep-dired image previews" "d p" #'peep-dired
        :desc "Dired view file" "d v" #'dired-view-file)))
;; Make 'h' and 'l' go back and forward in dired. Much faster to navigate the directory structure!
(evil-define-key 'normal dired-mode-map
  (kbd "M-RET") 'dired-display-file
  (kbd "h") 'dired-up-directory
  (kbd "l") 'dired-open-file ; use dired-find-file instead of dired-open.
  (kbd "m") 'dired-mark
  (kbd "t") 'dired-toggle-marks
  (kbd "u") 'dired-unmark
  (kbd "C") 'dired-do-copy
  (kbd "D") 'dired-do-delete
  (kbd "J") 'dired-goto-file
  (kbd "M") 'dired-chmod
  (kbd "O") 'dired-chown
  (kbd "P") 'dired-do-print
  (kbd "R") 'dired-rename
  (kbd "T") 'dired-do-touch
  (kbd "Y") 'dired-copy-filenamecopy-filename-as-kill ; copies filename to kill ring.
  (kbd "+") 'dired-create-Directory
  (kbd "-") 'dired-up-directory
  (kbd "% l") 'dired-downcase
  (kbd "% u") 'dired-upcase
  (kbd "; d") 'epa-dired-do-decrypt
  (kbd "; e") 'epa-dired-do-encrypt)
;; If peep-dired is enabled, you will get image previews as you go up/down with 'j' and 'k'
(evil-define-key 'normal peep-dired-mode-map
  (kbd "j") 'peep-dired-next-file
  (kbd "k") 'peep-dired-prev-file)
(add-hook 'peep-dired-hook 'evil-normalize-keymaps)
;; Get file icons in dired
(add-hook 'dired-mode-hook 'all-the-icons-dired-mode)
;; With dired-open plugin, you can launch external programs for certain extensions
;; For example, I set all .png files to open in 'sxiv' and all .mp4 files to open in 'mpv'
(setq dired-open-extensions '(("gif" . "sxiv")
                              ("jpg" . "sxiv")
                              ("png" . "sxiv")
                              ("mkv" . "mpv")
                              ("mp4" . "mpv")))




;; -------------------------------- ;;
;;;;;;;;;;;; -ELIXIR- ;;;;;;;;;;;;;;;;
;;;;;;;;;;;;  ======  ;;;;;;;;;;;;;;;;

;; Configure elixir-lsp
;; replace t with nil to disable.
(setq lsp-elixir-fetch-deps nil)
(setq lsp-elixir-suggest-specs t)
(setq lsp-elixir-signature-after-complete t)
(setq lsp-elixir-enable-test-lenses t)

;; Compile and test on save
(setq alchemist-hooks-test-on-save t)
(setq alchemist-hooks-compile-on-save t)

;; Disable popup quitting for Elixir’s REPL
;; Default behaviour of doom’s treating of Alchemist’s REPL window is to quit the
;; REPL when ESC or q is pressed (in normal mode). It’s quite annoying so below
;; code disables this and set’s the size of REPL’s window to 30% of editor frame’s
;; height.
(set-popup-rule! "^\\*Alchemist-IEx" :quit nil :size 0.3)

;; Do not select exunit-compilation window
(setq shackle-rules '(("*exunit-compilation*" :noselect t))
      shackle-default-rule '(:select t))

;; Set global LSP options
(after! lsp-mode (
setq lsp-lens-enable t
lsp-ui-peek-enable t
lsp-ui-doc-enable nil
lsp-ui-doc-position 'bottom
lsp-ui-doc-max-height 70
lsp-ui-doc-max-width 150
lsp-ui-sideline-show-diagnostics t
lsp-ui-sideline-show-hover nil
lsp-ui-sideline-show-code-actions t
lsp-ui-sideline-diagnostic-max-lines 20
lsp-ui-sideline-ignore-duplicate t
lsp-ui-sideline-enable t))

;; ------------------------------- ;;
;;;;;;;  -ORG SUPER AGENDA-  ;;;;;;;;
;;;;;;;  ==================  ;;;;;;;;
(setq org-agenda-files (list
                        (concat org-directory "gtd/actionable.org")
                        ))

(use-package! org-super-agenda
  :after
  org-agenda
  :init
  (setq org-super-agenda-groups '(
                                  (:name "Shallow Work"
                                   :and (:tag "Shallow")
                                   :transformer (--> it
                                                     (propertize it 'face '(:foreground "RosyBrown1"))))

                                  (:name "Focus Work"
                                   :and (:tag "Focus" :priority "A")
                                   :transformer (--> it
                                                     (propertize it 'face '(:foreground "medium purple"))))

                                  (:name "Deep Work"
                                   :and (:tag "Deep" :priority "A")
                                   :transformer (--> it
                                                     (propertize it 'face '(:foreground "dark orchid"))))
                                  (:discard (:anything))
                                  ))
  :config
  (org-super-agenda-mode)
  )

;; ------------------------------- ;;
;;;;;;;;;;  -ORG-GTD-  ;;;;;;;;;;;;;;
;;;;;;;;;;  =========  ;;;;;;;;;;;;;;
(use-package! org-gtd
  :after org
  :config
  (org-edna-mode)
  (setq org-gtd-directory "~/Documents/Org/gtd")
  (setq org-gtd-default-file-name "actionable")
  (setq org-edna-use-inheritance t)
  (map!
   :leader
   (:prefix-map ("d" . "org-gtd")
    :desc "Capture"        "c"  #'org-gtd-capture
    :desc "Engage"         "e"  #'org-gtd-engage
    :desc "Process inbox"  "p"  #'org-gtd-process-inbox
    :desc "Show all next"  "n"  #'org-gtd-show-all-next
    :desc "Stuck projects" "s"  #'org-gtd-show-stuck-projects))

  (map!
   :map org-gtd-process-map
   :desc "Choose"         "C-c C-c" #'org-gtd-choose))

;; ------------------------------- ;;
;;;;;;;;;;;;  -ORG-  ;;;;;;;;;;;;;;;;
;;;;;;;;;;;;  =====  ;;;;;;;;;;;;;;;;
(setq org-directory "~/Documents/Org/")
(setq org-refile-use-outline-path t)                  ; Show full paths for refiling


;; --------------------------------- ;;
;;;;;;;;;;;  -ORG ROAM-  ;;;;;;;;;;;;;;
;;;;;;;;;;;  ==========  ;;;;;;;;;;;;;;
(setq org-roam-directory "~/Documents/Org/Roam")

;; --------------------------------- ;;
;;;;;;;;;;;  -NOTMUCH-  ;;;;;;;;;;;;;;;
;;;;;;;;;;;  =========  ;;;;;;;;;;;;;;;
(setq +notmuch-home-function (lambda () (notmuch-search "tag:inbox")))
