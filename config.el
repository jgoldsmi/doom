;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
(setq doom-font (font-spec :family "FiraCode Nerd Font" :size 12 :weight 'semi-light)
      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme '(modus-vivendi-tinted . modus-operandi-tinted))

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `with-eval-after-load' block, otherwise Doom's defaults may override your
;; settings. E.g.
;;
;;   (with-eval-after-load 'PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look them up).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
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

;;; consult-gh --- GitHub from the minibuffer -----------------------------------
;; `consult-gh-transient' carries no upstream autoload cookie, so `:commands'
;; supplies one. Pressing `SPC g h' loads consult-gh-transient.el, whose
;; top-level (require 'consult-gh) triggers every block below.
(use-package! consult-gh-transient
  :commands consult-gh-transient
  :init
  ;; Bind the full sequence: (:prefix ("g" . "git") ...) would rebind SPC g to a
  ;; *fresh* keymap and wipe Doom's magit/forge bindings.
  (map! :leader :desc "GitHub (consult-gh)" "g h" #'consult-gh-transient))

(use-package! consult-gh
  :defer t
  :config
  ;; Stock `consult-gh-repo-action' opens the repo in a browser; browse its
  ;; files in Emacs instead. `C-o' for preview keeps async searches responsive.
  (setq consult-gh-default-clone-directory "~/src"
        consult-gh-show-preview t
        consult-gh-preview-key "C-o"
        consult-gh-repo-action #'consult-gh--repo-browse-files-action
        consult-gh-default-interactive-command #'consult-gh-transient)
  ;; Binds only C-c keys inside consult-gh view buffers, so evil is unaffected.
  (consult-gh-enable-default-keybindings)
  (add-to-list 'savehist-additional-variables 'consult-gh--known-orgs-list)
  (add-to-list 'savehist-additional-variables 'consult-gh--known-repos-list))

(use-package! consult-gh-embark
  :after consult-gh
  :config
  (consult-gh-embark-mode +1))

;; This block is what makes the first `SPC g h' pull in forge/ghub/magit.
(use-package! consult-gh-forge
  :after consult-gh
  :config
  (consult-gh-forge-mode +1)
  (setq consult-gh-forge-timeout-seconds 20))

(use-package! consult-gh-nerd-icons
  :after consult-gh
  :config
  (consult-gh-nerd-icons-mode +1))
