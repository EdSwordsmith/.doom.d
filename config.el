;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "Eduardo Espadeiro"
      user-mail-address "eduardo@espadeiro.pt")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-unicode-font' -- for unicode glyphs
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
(setq doom-font (font-spec :family "JetBrains Mono" :size 18))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'gruber-darker)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")
(setq initial-major-mode 'org-mode)

;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
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
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

(use-package! websocket
  :after org-roam)

(use-package! org-roam-ui
  :after org-roam
  :config
  (setq org-roam-ui-sync-theme t
        org-roam-ui-follow t
        org-roam-ui-update-on-save t
        org-roam-ui-open-on-start t))

;; (use-package! elcord
;;   :init
;;   (setq elcord-use-major-mode-as-main-icon t)
;;   (setq elcord-editor-icon "doom_cute_icon")
;;   (setq elcord-display-line-numbers nil)
;;   (add-hook 'doom-first-buffer-hook #'elcord-mode))

(map! :after python
      :map python-mode-map
      :localleader
      "r" #'run-python)

(setq read-file-name-completion-ignore-case t
      read-buffer-completion-ignore-case t
      completion-ignore-case t)

(set-formatter! 'alejandra '("alejandra" "--quiet") :modes '(nix-mode))

;; taken from (https://discourse.doomemacs.org/t/org-tips-and-tricks-thread/2718/2)
(defadvice! edswordsmith/org-roam-in-own-workspace-a (&rest _)
  "Open all roam buffers in there own workspace."
  :before #'org-roam-node-find
  :before #'org-roam-node-random
  :before #'org-roam-buffer-display-dedicated
  :before #'org-roam-buffer-toggle
  (when (modulep! :ui workspaces)
    (+workspace-switch "*roam*" t)))

(defadvice! edswordsmith/doom-config-in-own-workspace-a (&rest _)
  "Open doom config in its own workspace."
  :before #'doom/find-file-in-private-config
  :before #'doom/open-private-config
  :before #'doom/goto-private-config-file
  :before #'doom/goto-private-init-file
  :before #'doom/goto-private-packages-file
  (when (modulep! :ui workspaces)
    (+workspace-switch "doom" t)))

;; Astro
(add-to-list 'auto-mode-alist '(".*\\.astro\\'"  . web-mode))

;; Eat
(use-package! eat
  :config
  (setq eat-term-name "xterm-256color"))

;; Julia REPL
(use-package! julia-repl
  :config
  (julia-repl-set-terminal-backend 'vterm))

(setq eglot-jl-language-server-project "~/.julia/environments/v1.10")

;; Common Lisp
;; (defun +common-lisp*refresh-sly-version (version conn)
;;   (unless sly-protocol-version
;;     (setq sly-protocol-version (sly-version nil (locate-library "sly.el")))))
;; (advice-add #'sly-check-version :before #'+common-lisp*refresh-sly-version)
