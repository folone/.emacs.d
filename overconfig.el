;; Desktop saving
(desktop-save-mode 1)

(report-errors "File mode specification error: %s"
  (set-auto-mode))

;; set up unicode
(prefer-coding-system       'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
;; This from a japanese individual.  I hope it works.
(setq default-buffer-file-coding-system 'utf-8)
;; From Emacs wiki
(setq x-select-request-type '(UTF8_STRING COMPOUND_TEXT TEXT STRING))

;; Set font
(set-default-font "Monaco-8")

;; Set default browser to chromium
(setq browse-url-browser-function 'browse-url-generic
      browse-url-generic-program "chromium")
;; Chromium edit extension
(require 'edit-server)
(edit-server-start)

;; Jabber connection settings.
;; This file should be of following format:
;; (defun custom-jabber-settings ()
;;  (custom-set-variables
;;   '(jabber-account-list (quote
;;                         (("name@gmail.com/emacs"
;;                           (:password . "*******")
;;                       (:network-server . "talk.google.com")
;;                         (:port . 5223)
;;                         (:connection-type . ssl))
;;                        ("name@jabber.ru/emacs"
;;                         (:password . "*******")
;;                         (:network-server . "jabber.ru"))
;;                        )))
;;   '(jabber-default-status "jabber.el")
;;   '(jabber-history-enabled t)
;;   '(jabber-use-global-history nil)
;;   '(jabber-vcard-avatars-retrieve nil)))
;;(provide 'custom-jabber-settings)
(require 'jabber)
(require 'custom-jabber-settings)
(custom-jabber-settings)

;; Notifying of new jabber.el messages.
(defvar jabber-activity-jids-count 0)

(defun jabber-message-blink ()
  (let ((count (length jabber-activity-jids)))
    (unless (= jabber-activity-jids-count count)
      (start-process-shell-command "blink" nil 
                                   "blink" (format "--numlockled --rate %s" count))
      (setq jabber-activity-jids-count count))))

(add-hook 'jabber-activity-update-hook 'jabber-message-blink)

;; don't forget to disable blinking after disconnection
(add-hook 'jabber-post-disconnect-hook 
     (lambda () 
       (jabber-autoaway-stop)
            (jabber-keepalive-stop)
       (start-process-shell-command "blink" nil "blink")))

;; Notifying through libnotify
(defvar libnotify-program "/usr/bin/notify-send")

(defun notify-send (title message)
  (start-process "notify" " notify"
		 libnotify-program "--expire-time=3000" title message))

(defun libnotify-jabber-notify (from buf text proposed-alert)
  "(jabber.el hook) Notify of new Jabber chat messages via libnotify"
  (when (or jabber-message-alert-same-buffer
            (not (memq (selected-window) (get-buffer-window-list buf))))
    (if (jabber-muc-sender-p from)
        (notify-send (format "(PM) %s"
                       (jabber-jid-displayname (jabber-jid-user from)))
               (format "%s: %s" (jabber-jid-resource from) text)))
      (notify-send (format "%s" (jabber-jid-displayname from))
             text)))

(add-hook 'jabber-alert-message-hooks 'libnotify-jabber-notify)

;; Send message on C-RET
(define-key jabber-chat-mode-map (kbd "RET") 'newline)
(define-key jabber-chat-mode-map [C-return] 'jabber-chat-buffer-send)

;; Open chats in their own frames (does not work)
(setq 
  special-display-regexps 
  '(("jabber-chat" 
     (width . 80)
     (scroll-bar-width . 16)
     (height . 15)
     (tool-bar-lines . 0)
     (menu-bar-lines 0)
     ;;(font . "-GURSoutline-Courier New-normal-r-normal-normal-11-82-96-96-c-70-iso8859-1")
     (left . 80))))

;; Custom view
(require 'custom-look)
(custom-look)

;; Setting initial frame size
(defun set-frame-size-according-to-resolution ()
  (interactive)
  (if window-system
  (progn
    ;; use 120 char wide window for largeish displays
    ;; and smaller 80 column windows for smaller displays
    ;; pick whatever numbers make sense for you
    (if (> (x-display-pixel-width) 1280)
        (add-to-list 'default-frame-alist (cons 'width 120))
      (add-to-list 'default-frame-alist (cons 'width 80)))
    ;; for the height, subtract a couple hundred pixels
    ;; from the screen height (for panels, menubars and
    ;; whatnot), then divide by the height of a char to
    ;; get the height we want
    (add-to-list 'default-frame-alist 
                 (cons 'height 100)))))

(set-frame-size-according-to-resolution)


;; Load up Org Mode and Babel
(require 'org-install)

;; Markdown to PDF and other conversions support
(load "pandoc-mode")
(add-hook 'markdown-mode-hook 'turn-on-pandoc)

;; Load scala mode
(require 'scala-mode-auto)

;; Load ensime mode
(require 'ensime)

;; This step causes the ensime-mode to be started whenever
;; scala-mode is started for a buffer. You may have to customize this step
;; if you're not using the standard scala mode.
(add-hook 'scala-mode-hook 'ensime-scala-mode-hook)
(setq exec-path (append exec-path (list "~/bin/scala-2.9.0.1/bin" )))

(require 'ensime-ecb)
(require 'ensime-layout-defs)
(require 'sbt)

(global-set-key [f12] 'ecb-toggle-ecb-windows)

;; Scalaz unicode hook
(add-to-list 'load-path (concat dotfiles-dir "/elpa-to-submit/scalaz-unicode-input-method"))
(require 'scalaz-unicode-input-method)
(add-hook 'scala-mode-hook
          (lambda () (set-input-method "scalaz-unicode")))

;; Haskell mode
(load "~/.emacs.d/haskellmode-emacs/haskell-site-file")
(add-hook 'haskell-mode-hook 'turn-on-haskell-doc-mode)
(add-hook 'haskell-mode-hook 'turn-on-haskell-indentation)
;;(add-hook 'haskell-mode-hook 'turn-on-haskell-indent)
;;(add-hook 'haskell-mode-hook 'turn-on-haskell-simple-indent)
(setq haskell-program-name "ghci")

;; Spaces for tabs
(setq-default indent-tabs-mode nil)

;; nxml-mode
(load "nxml-mode/rng-auto.el")
(setq auto-mode-alist
        (cons '("\\.\\(xml\\|xsl\\|rng\\|xhtml\\)\\'" . nxml-mode)
	      auto-mode-alist))

;;js2-mode
(autoload 'js2-mode "js2" nil t)
(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))


;; Show line-number in the mode line
(line-number-mode 1)

;; Show column-number in the mode line
(column-number-mode 1)

;; In every buffer, the line which contains the cursor will be fully
;; highlighted
(global-hl-line-mode 1)

;; Nyan mode
(add-to-list 'load-path (concat dotfiles-dir "/nyan-mode"))
(require 'nyan-mode)
(nyan-mode 1)

;; Colourfull brackets
(require 'rainbow-delimiters)
;; Add hooks for modes where you want it enabled, for example:
(add-hook 'scala-mode-hook 'rainbow-delimiters-mode)

;; Line numbers
(require 'linum)
(global-linum-mode 1)

;; Cyrillic hotkeys
(defun reverse-input-method (input-method)
  "Build the reverse mapping of single letters from INPUT-METHOD."
  (interactive
   (list (read-input-method-name "Use input method (default current): ")))
  (if (and input-method (symbolp input-method))
      (setq input-method (symbol-name input-method)))
  (let ((current current-input-method)
        (modifiers '(nil (control) (meta) (control meta))))
    (when input-method
      (activate-input-method input-method))
    (when (and current-input-method quail-keyboard-layout)
      (dolist (map (cdr (quail-map)))
        (let* ((to (car map))
               (from (quail-get-translation
                      (cadr map) (char-to-string to) 1)))
          (when (and (characterp from) (characterp to))
            (dolist (mod modifiers)
              (define-key function-key-map
                (vector (append mod (list from)))
                (vector (append mod (list to)))))))))
    (when input-method
      (activate-input-method current))))
(reverse-input-method 'cyrillic-jcuken)

(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))

;; IRC chats
;; TODO move to separate file
(require 'erc)

;; joining && autojoing
;; make sure to use wildcards for e.g. freenode as the actual server
;; name can be be a bit different, which would screw up autoconnect
(erc-autojoin-mode t)
(setq erc-autojoin-channels-alist
      '((".*\\.freenode.net" "#haskell" "#scala")))

;; check channels
(erc-track-mode t)
(setq erc-track-exclude-types '("JOIN" "NICK" "PART" "QUIT" "MODE"
                                "324" "329" "332" "333" "353" "477"))
;; don't show any of this
(setq erc-hide-list '("JOIN" "PART" "QUIT" "NICK"))

(defun djcb-erc-start-or-switch ()
  "Connect to ERC, or switch to last active buffer"
  (interactive)
  (if (get-buffer "irc.freenode.net:6667") ;; ERC already active?
    (erc-track-switch-buffer 1) ;; yes: switch to last active
    (when (y-or-n-p "Start ERC? ") ;; no: maybe start ERC
      (erc :server "irc.freenode.net" :port 6667 :nick "folone" :password "**********" :full-name "Georgii Leontiev"))))

;; switch to ERC with Ctrl+c e
(global-set-key (kbd "C-c e") 'djcb-erc-start-or-switch) ;; ERC

(require 'roy-mode)

(eval-after-load "color-theme" '(color-theme-blackboard))

;; minimap
(require 'minimap)
;; TODO assign `toggle this feature` on some key.

;; This function does some scala code prettifying.
(defun prettify-scala-code ()
  "Replace ascii with it's unicode counterparts."
  (interactive)
  (save-excursion
    (beginning-of-buffer)
    (let ((replace-table (make-hash-table :test 'equal))
          replaces)
      (puthash "=>" "⇒" replace-table)
      (puthash "<-" "←" replace-table)
      (puthash "->" "→" replace-table)
      (maphash (lambda (toreplace withreplace)
                 (replace-string toreplace withreplace))
               replace-table)
      replaces)))
(global-set-key (kbd "C-c p") 'prettify-scala-code)
