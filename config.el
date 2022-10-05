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
;;;;;;;;;;  -ORG-REF-  ;;;;;;;;;;;;;;
;;;;;;;;;;  =========  ;;;;;;;;;;;;;;
(use-package! org-ref

  ;; this bit is highly recommended: make sure Org-ref is loaded after Org
  :after org

  ;; Put any Org-ref commands here that you would like to be auto loaded:
  ;; you'll be able to call these commands before the package is actually loaded.
  :commands
  (org-ref-cite-hydra/body
   org-ref-bibtex-hydra/body)

  ;; if you don't need any autoloaded commands, you'll need the following
  ;; :defer t

  ;; This initialization bit puts the `orhc-bibtex-cache-file` into `~/.doom/.local/cache/orhc-bibtex-cache
  ;; Not strictly required, but Org-ref will pollute your home directory otherwise, creating the cache file in ~/.orhc-bibtex-cache
  :init
  (let ((cache-dir (concat doom-cache-dir "org-ref")))
    (unless (file-exists-p cache-dir)
      (make-directory cache-dir t))
    (setq orhc-bibtex-cache-file (concat cache-dir "/orhc-bibtex-cache"))))

;; ------------------------------- ;;
;;;;;;;;;;;;  -ORG-  ;;;;;;;;;;;;;;;;
;;;;;;;;;;;;  =====  ;;;;;;;;;;;;;;;;
(setq org-directory "~/Documents/Org/")
(setq org-refile-use-outline-path t)                  ; Show full paths for refiling


;; --------------------------------- ;;
;;;;;;;;;;;  -ORG ROAM-  ;;;;;;;;;;;;;;
;;;;;;;;;;;  ==========  ;;;;;;;;;;;;;;
(setq org-roam-directory "~/Documents/Org/Roam")

(use-package! websocket
    :after org-roam)

(use-package! org-roam-ui
    :after org-roam ;; or :after org
;;         normally we'd recommend hooking orui after org-roam, but since org-roam does not have
;;         a hookable mode anymore, you're advised to pick something yourself
;;         if you don't care about startup time, use
;;  :hook (after-init . org-roam-ui-mode)
    :config
    (setq org-roam-ui-sync-theme t
          org-roam-ui-follow t
          org-roam-ui-update-on-save t
          org-roam-ui-open-on-start t))

(use-package! org-roam-bibtex
  :after org-roam
  :hook (org-roam-mode . org-roam-bibtex-mode)
  :bind (:map org-mode-map
         (("C-c n a" . orb-note-actions)))
  :config
  (require 'org-ref)) ; optional: if Org Ref is not loaded anywhere else, load it here

;;;; Add the cite-key in the title of the notes and make sure they end up in bibnotes folder.
;; (setq orb-templates
;;       '(("r" "ref" plain (function org-roam-capture--get-point) "%?"
;;          :file-name "bibnotes/${citekey}"
;;          (use-package! org-roam-bibtex
;;   :after org-roam
;;   :hook (org-roam-mode . org-roam-bibtex-mode)
;;   :bind (:map org-mode-map
;;          (("C-c n a" . orb-note-actions)))
;;   :config
;;   (require 'org-ref)) ; optional: if Org Ref is not loaded anywhere else, load it here

;;;; Add the cite-key in the title of the notes and make sure they end up in bibnotes folder.
;; (setq orb-templates
;;       '(("r" "ref" plain (function org-roam-capture--get-point) "%?"
;;          :file-name "bibnotes/${citekey}"
;;          :head "#+TITLE: ${citekey}: ${title}\n#+ROAM_KEY: ${ref}\n#+CREATED: %U\n#+LAST_MODIFIED: %U\n"
;;          :unnarrowed t)))

;; (setq org-roam-capture-templates
;;         '(("d" "default" plain (function org-roam-capture--get-point) "%?"
;;          :file-name "%<%Y%m%d%H%M%S>-${slug}"
;;          :head "#+TITLE: ${title}\n#+ROAM_ALIAS: \n#+CREATED: %U\n#+LAST_MODIFIED: %U\n"
;;          :unnarrowed t)
;;          :head "#+TITLE: ${citekey}: ${title}\n#+ROAM_KEY: ${ref}\n#+CREATED: %U\n#+LAST_MODIFIED: %U\n"
;;          :unnarrowed t)))

;; (setq org-roam-capture-templates
;;         '(("d" "default" plain (function org-roam-capture--get-point) "%?"
;;          :file-name "%<%Y%m%d%H%M%S>-${slug}"
;;          :head "#+TITLE: ${title}\n#+ROAM_ALIAS: \n#+CREATED: %U\n#+LAST_MODIFIED: %U\n"
;;          :unnarrowed t)))

;; --------------------------------- ;;
;;;;;;;;;;;  -NOTMUCH-  ;;;;;;;;;;;;;;;
;;;;;;;;;;;  =========  ;;;;;;;;;;;;;;;
(setq +notmuch-home-function (lambda () (notmuch-search "tag:inbox")))


;; ------------------------------- ;;
;;;;;;;;;;  -ORG-WSJF-  ;;;;;;;;;;;;;;
;;;;;;;;;;  =========  ;;;;;;;;;;;;;;

(defun org-wsjf-put-value ()
    (org-entry-put (point) "VALUE" (read-string "Value: ")))

;; ------------------------------- ;;
;;;;;;;;;;  -md4rd-  ;;;;;;;;;;;;;;
;;;;;;;;;;  =========  ;;;;;;;;;;;;;;

(when (require 'md4rd nil 'noerror)

  (setq md4rd-subs-active
        '(academicbiblical
          askhistorian
          askreddit
          askscience
          bitcoin
          changemyview
          clojure
          common_lisp
          compsci
          cryptocurrency
          emacs
          fire
          futurelings
          guile
          guix
          ipfs
          learnprogramming
          linux
          lisp
          neutralpolitics
          nixos
          outoftheloop
          personalfinance
          politics
          programming
          racket
          science
          todayilearned
          unpopularopinion
          worldnews))

  (defun consider-refresh-md4rd-login ()
    (when (and (boundp 'md4rd--oauth-client-id)
               (boundp 'md4rd--oauth-access-token)
               (boundp 'md4rd--oauth-refresh-token)
               (not (string= "" md4rd--oauth-client-id))
               (not (string= "" md4rd--oauth-access-token))
               (not (string= "" md4rd--oauth-refresh-token)))
      (md4rd-refresh-login)))

  (run-with-timer 0 3540 'consider-refresh-md4rd-login)

  (add-hook 'md4rd-mode-hook 'md4rd-indent-all-the-lines))
