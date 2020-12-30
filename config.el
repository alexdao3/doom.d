;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Alex"
      user-mail-address "rahx1t@gmail.com")

(setq auth-sources '("~/.authinfo"))

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
(setq doom-theme 'doom-one)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)


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

(keychain-refresh-environment)

(use-package! direnv
 :config
 (direnv-mode))

(use-package! lsp-mode
  :config
  (setq lsp-haskell-server-path "haskell-language-server"))
(use-package! lsp-ui
  :after lsp-mode
  :config
  (defun +grfn/lsp-ui-doc-frame-hook (frame window)
    (set-frame-font (if doom-big-font-mode doom-big-font doom-font)
                    nil (list frame)))
  (lsp-ui-doc-enable t)
  (setq lsp-ui-flycheck-enable t
        lsp-ui-doc-header nil
        lsp-ui-doc-position 'top
        lsp-ui-doc-alignment 'window
        lsp-ui-doc-frame-hook '+grfn/lsp-ui-doc-frame-hook)
  (setq imenu-auto-rescan t)
  :hook
  (lsp-mode . lsp-ui-mode)
  (lsp-ui-mode . flycheck-mode))

(use-package! lsp-imenu
  :after (lsp-mode lsp-ui)
  :hook
  (lsp-after-open . lsp-enable-imenu))

;; Javascript
;;;;; Javascript

(setq js-indent-level 2)

(add-to-list 'auto-mode-alist '("components\\/.*\\.js\\'" . rjsx-mode))

;; (require 'prettier-js)
;; (after! prettier-js
;;   (add-hook! rjsx-mode #'prettier-js-mode)
;;   (add-hook! js2-mode  #'prettier-js-mode)
;;   (add-hook! json-mode #'prettier-js-mode)
;;   (add-hook! css-mode  #'prettier-js-mode))

;; Clojure

(use-package! anakondo
  :ensure t
  :commands anakondo-minor-mode)

(use-package! flycheck-clj-kondo
  :after clojure-mode
  :config (require 'flycheck-clj-kondo))

(after! clojure-mode
  (define-clojure-indent
    (PUT 2)
    (POST 2)
    (GET 2)
    (PATCH 2)
    (DELETE 2)
    (context 2)
    (for-all 2)
    (checking 3)
    (>defn :defn)
    (>defn- :defn)
    (match 1)
    (cond 0)
    (case 1)
    (describe 1)
    (it 2)
    (fn-traced :defn)
    (defn-traced :defn)
    (assert-match 1))
  (add-to-list 'clojure-align-binding-forms "let-flow")
  (setq clojure-indent-style 'align-arguments)
  ;; (setq cider-default-cljs-repl 'shadow)
  (put '>defn 'clojure-doc-string-elt 2)
  (put '>defn- 'clojure-doc-string-elt 2)
  (put 'defsys 'clojure-doc-string-elt 2)
  (put 'defn-traced 'clojure-doc-string-elt 2)


  ;; align map key-values
  ;; (setq clojure-align-forms-automatically t)
  (setq cider-cljs-lein-repl
        "(do (require 'figwheel-sidecar.repl-api)
          (figwheel-sidecar.repl-api/start-figwheel!)
          (figwheel-sidecar.repl-api/cljs-repl))")
  (setq cljr-magic-require-namespaces
        '(("set" . "clojure.set")
          ("time" . "cljs-time.core")
          ("string" . "clojure.string")
          ("walk" . "clojure.walk")
          ("zip" . "clojure.zip")
          ("url" . "cemerick.url")
          ("csv" . "clojure.data.csv")
          ("data" . "clojure.data")
          ("json" . "cheshire.core")
          ("medley" . "medley.core")
          ("rum" . "rum.core")
          ("p" . "promesa.core")
          ("m" . "missionary.core"))))

;; Enable anakondo-minor-mode in all Clojure buffers
;; (add-hook 'clojure-mode-hook #'anakondo-minor-mode)
(add-hook 'clojure-mode-hook #'evil-cleverparens-mode)
;; Enable anakondo-minor-mode in all ClojureScript buffers
;; (add-hook 'clojurescript-mode-hook #'anakondo-minor-mode)
(add-hook 'clojurescript-mode-hook #'evil-cleverparens-mode)
;; Enable anakondo-minor-mode in all cljc buffers
;; (add-hook 'clojurec-mode-hook #'anakondo-minor-mode)
(add-hook 'clojurec-mode-hook #'evil-cleverparens-mode)

;;----------------------------------------------------------------------------
;; Lispy navigation
;;----------------------------------------------------------------------------
(require 'smartparens)

(add-hook 'smartparens-mode #'evil-cleverparens-mode)


;;----------------------------------------------------------------------------
;; Reason setup
;;----------------------------------------------------------------------------
(setq merlin-ac-setup t)

;; https://github.com/hlissner/doom-emacs/issues/3951#issuecomment-694122280
(after! lsp-mode
  (lsp-register-client
   (make-lsp-client :new-connection (lsp-stdio-connection
                                     (-const "reason-language-server"))
                    :major-modes '(reason-mode)
                    :notification-handlers (ht ("client/registerCapability" 'ignore))
                    :priority 1
                    :server-id 'reason-ls)))

(after! reason-mode
  (add-hook! reason-mode #'lsp)
  (add-hook! reason-mode #'merlin-mode))

  ;; (add-hook! reason-mode (add-hook 'before-save-hook #'refmt-before-save nil t))

;;----------------------------------------------------------------------------
;; Treemacs
;;----------------------------------------------------------------------------
(add-hook 'emacs-startup-hook 'treemacs)

(use-package! lsp-treemacs
  :config
  (map! :map lsp-mode-map
        (:leader

          "c X" #'lsp-treemacs-errors-list)))

;;----------------------------------------------------------------------------
;; Magit
;;----------------------------------------------------------------------------

(use-package! magit-todos)
(add-hook 'magit-mode-hook 'magit-todos-mode)

;;----------------------------------------------------------------------------
;; Cljstyle
;;----------------------------------------------------------------------------

;; enables you to require files from the cljstyle directory
;; (add-to-list 'load-path "~/.emacs.d/cljstyle-mode")

;; load the cljstyle-mode file
;; (require 'cljstyle-mode)

;; run cljstyle-mode on Clojure(script) files
;; (add-hook 'clojure-mode-hook #'cljstyle-mode #'lsp)
;; (add-hook 'clojurec-mode-hook #'cljstyle-mode #'lsp)
;; (add-hook 'clojurescript-mode-hook #'cljstyle-mode #'lsp)

(use-package lsp-mode
  :ensure t
  :hook ((clojure-mode . lsp)
         (clojurec-mode . lsp)
         (clojurescript-mode . lsp))
  :config
  ;; add paths to your local installation of project mgmt tools, like lein
  (setenv "PATH" (concat
                   "/usr/local/bin" path-separator
                   (getenv "PATH")))
  (dolist (m '(clojure-mode
               clojurec-mode
               clojurescript-mode
               clojurex-mode))
     (add-to-list 'lsp-language-id-configuration `(,m . "clojure"))))
(setq url-debug t)


(with-eval-after-load 'cider
 (cider-register-cljs-repl-type 'nbb "(+ 1 2 3)"))


(defun mm/cider-connected-hook ()
  (when (eq 'nbb cider-cljs-repl-type)
    (setq-local cider-show-error-buffer nil)
    (cider-set-repl-type 'cljs)))

(add-hook 'cider-connected-hook #'mm/cider-connected-hook)
