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

(use-package lsp-mode
  :defer
  :commands lsp
  :diminish lsp-mode
  :hook
  (elixir-mode . lsp)
  :init
  (add-to-list 'exec-path "~/elixir-ls/release/")
  :config
  (progn
   (lsp-register-client
    (make-lsp-client :new-connection (lsp-tramp-connection "~/elixir-ls/release/language_server.sh")
                     :major-modes '(elixir-mode)
                     :remote? t
                     :server-id 'elixir-ls-remote))))

;; file watch
(setq lsp-enable-file-watchers t)
(setq lsp-file-watch-threshold 3000)
(setq-default lsp-file-watch-ignored ())
(add-to-list 'lsp-file-watch-ignored ".elixir_ls")
(add-to-list 'lsp-file-watch-ignored "deps")
(add-to-list 'lsp-file-watch-ignored "_build")
(add-to-list 'lsp-file-watch-ignored "assets/node_modules")

;; Create a buffer-local hook to run elixir-format on save, only when we enable elixir-mode.
(add-hook 'elixir-mode-hook
          (lambda () (add-hook 'before-save-hook 'elixir-format nil t)))

(use-package! lsp-tailwindcss)
(add-to-list 'lsp-language-id-configuration '(".*\\.heex$" . "html"))


;; alchemist key bindings
(setq alchemist-key-command-prefix (kbd doom-localleader-key))

;; Enable folding
(setq lsp-enable-folding t)

;; Add origami and LSP integration
(use-package! lsp-origami)
(add-hook! 'lsp-after-open-hook #'lsp-origami-try-enable)
projectile-project-search-path '("~/Documents/Local.nosync/")



;; ------------------------------- ;;
;;;;;;;  -ORG SUPER AGENDA-  ;;;;;;;;
;;;;;;;  ==================  ;;;;;;;;
(use-package! org-super-agenda
              :after
              org-agenda
              :init
              (setq org-super-agenda-groups '((:name "Today"
                                                     :time-grid t
                                                     :scheduled today)
                                              (:name "Due today"
                                                     :deadline today)
                                              (:name "Important"
                                                     :priority "A")
                                              (:name "Overdue"
                                                     :deadline past)
                                              (:name "Due soon"
                                                     :deadline future)
                                              (:name "Big Outcomes"
                                                     :tag "bo")
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

;;Default directory for Org files.
(setq org-directory "~/Documents/Org/")

;; ;;Hide Org markup indicators.
;; (after! org (setq org-hide-emphasis-markers t))

;; ;; Enable logging of done tasks, and log stuff into the LOGBOOK drawer by default
;; (after! org
;;   (setq org-log-done t)
;;   (setq org-log-into-drawer t))

;; ;; Org Capture Templates

;; (map! :leader
;;       :desc "Org Capture"           "x" #'org-capture
;;       :desc "Pop up scratch buffer" "X" #'doom/open-scratch-buffer)

;; ;; from npsolve/dotfiles
;; (defun org-capture-select-template-prettier (&optional keys)
;;   "Select a capture template, in a prettier way than default
;; Lisp programs can force the template by setting KEYS to a string."
;;   (let ((org-capture-templates
;;          (or (org-contextualize-keys
;;               (org-capture-upgrade-templates org-capture-templates)
;;               org-capture-templates-contexts)
;;              '(("t" "Task" entry (file+headline "" "Tasks")
;;                 "* TODO %?\n  %u\n  %a")))))
;;     (if keys
;;         (or (assoc keys org-capture-templates)
;;             (error "No capture template referred to by \"%s\" keys" keys))
;;       (org-mks org-capture-templates
;;                "Select a capture template\n━━━━━━━━━━━━━━━━━━━━━━━━━"
;;                "Template key: "
;;                `(("q" ,(concat (all-the-icons-octicon "stop" :face 'all-the-icons-red :v-adjust 0.01) "\tAbort")))))))
;; (advice-add 'org-capture-select-template :override #'org-capture-select-template-prettier)

;; (setq org-capture-templates
;;       '(("d" "Demo template" entry
;;          (file+headline "organiser.org" "Our first heading")
;;          "* DEMO TEXT %?"
;;          )))

;; --------------------------------- ;;
;;;;;;;;;;;  -ORG ROAM-  ;;;;;;;;;;;;;;
;;;;;;;;;;;  ==========  ;;;;;;;;;;;;;;

(setq org-roam-directory "~/Documents/Org/Roam")
