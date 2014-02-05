(defun djcb-opacity-modify (&optional dec)
  "modify the transparency of the emacs frame; if DEC is t,
    decrease the transparency, otherwise increase it in 10%-steps"
  (let* ((alpha-or-nil (frame-parameter nil 'alpha)) ; nil before setting
          (oldalpha (if alpha-or-nil alpha-or-nil 100))
          (newalpha (if dec (- oldalpha 10) (+ oldalpha 10))))
    (when (and (>= newalpha frame-alpha-lower-limit) (<= newalpha 100))
      (modify-frame-parameters nil (list (cons 'alpha newalpha))))))

 ;; C-8 will increase opacity (== decrease transparency)
 ;; C-9 will decrease opacity (== increase transparency
 ;; C-0 will returns the state to normal
(global-set-key (kbd "C-8") '(lambda()(interactive)(djcb-opacity-modify)))
(global-set-key (kbd "C-9") '(lambda()(interactive)(djcb-opacity-modify t)))
(global-set-key (kbd "C-0") '(lambda()(interactive)
                               (modify-frame-parameters nil `((alpha . 100)))))

(global-set-key "\C-c\C-n" 'comment-dwim)

;; Desktop saving
(desktop-save-mode 1)

(report-errors "File mode specification error: %s"
  (set-auto-mode))

;; disable autofill mode.
(auto-fill-mode 0)
;; set up unicode
(prefer-coding-system       'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(setq default-buffer-file-coding-system 'utf-8)
;; From Emacs wiki
(setq x-select-request-type '(UTF8_STRING COMPOUND_TEXT TEXT STRING))

;; Set font
(set-face-attribute 'default nil :height 100)

;; Set default browser to chromium
(setq browse-url-browser-function 'browse-url-generic
      browse-url-generic-program "chromium")
;; Chromium edit extension
(require 'edit-server)
(edit-server-start)

(require 'jabber)
(require 'jabber-autoloads)

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

(require 'typopunct)
(setq-default typopunct-buffer-language 'russian)

(add-hook 'markdown-mode-hook 'turn-on-typopunct-mode)
(add-hook 'org-mode-hook 'turn-on-typopunct-mode)
(add-hook 'jabber-chat-mode-hook 'turn-on-typopunct-mode)

;; Markdown to PDF and other conversions support
(load "pandoc-mode")
(add-hook 'markdown-mode-hook 'turn-on-pandoc)

;; Load scala mode
(require 'scala-mode2)

;; Load ensime mode
(require 'ensime)

;; This causes the ensime-mode to be started whenever scala-mode is started
(add-hook 'scala-mode-hook 'ensime-scala-mode-hook)

;; Ecb with type inspector and stuff
(require 'ensime-ecb)
(require 'ensime-layout-defs)
(require 'sbt)

;; Scalaz unicode hook
(add-to-list 'load-path (concat dotfiles-dir "/elpa-to-submit/scalaz-unicode-input-method"))
(require 'scalaz-unicode-input-method)

;; Only enable unicode mode for insert and emacs states in evil-mode
(add-hook 'evil-insert-state-entry-hook
          (lambda () (set-input-method "scalaz-unicode")))
(add-hook 'evil-insert-state-exit-hook
          (lambda () (set-input-method nil)))
(add-hook 'evil-emacs-state-entry-hook
          (lambda () (set-input-method "scalaz-unicode")))
(add-hook 'evil-emacs-state-exit-hook
          (lambda () (set-input-method nil)))


;; Haskell mode
;;(load "haskell-site-file")
(add-hook 'haskell-mode-hook 'turn-on-haskell-doc-mode)
(add-hook 'haskell-mode-hook 'turn-on-haskell-indentation)
(add-to-list 'auto-mode-alist '("\\.idr\\'" . haskell-mode))
;;(add-hook 'haskell-mode-hook 'turn-on-haskell-indent)
;;(add-hook 'haskell-mode-hook 'turn-on-haskell-simple-indent)
(setq haskell-program-name "ghci")

;; Proof General
(add-to-list 'load-path (concat dotfiles-dir "/elpa-to-submit/ProofGeneral-4.1/generic"))
(require 'proof-site)

;; Spaces for tabs
(setq-default indent-tabs-mode nil)

;;js2-mode
(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))

;; Show line-number in the mode line
(line-number-mode 1)

;; Show column-number in the mode line
(column-number-mode 1)

;; In every buffer, the line which contains the cursor will be fully
;; highlighted
(require 'hl-line+)
;;(toggle-hl-line-when-idle 1)
(global-hl-line-mode 1)

;; Nyan mode
(require 'nyan-mode)
(nyan-mode 1)
;;(setq nyan-wavy-trail t)
(setq nyan-bar-length 20)
;;(nyan-start-animation)
;;(nyan-start-music)

;; Colourfull brackets
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

;; IRC chats
;; TODO move to separate file
(require 'erc)

;; joining && autojoing
;; make sure to use wildcards for e.g. freenode as the actual server
;; name can be be a bit different, which would screw up autoconnect
(erc-autojoin-mode t)
(setq erc-autojoin-channels-alist
      '((".*\\.freenode.net" "#haskell" "#scala" "#scalaz")))

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
      (erc :server "irc.freenode.net" :port 6667 :nick "folone"
           :full-name "George Leontiev"))))

;; Python stuff
(when (load "flymake" t)
  (defun flymake-pyflakes-init ()
    (let* ((temp-file (flymake-init-create-temp-buffer-copy
                       'flymake-create-temp-inplace))
           (local-file (file-relative-name
                        temp-file
                        (file-name-directory buffer-file-name))))
      (list "/home/folone/bin/pycheckers"  (list local-file))))
  (add-to-list 'flymake-allowed-file-name-masks
               '("\\.py\\'" flymake-pyflakes-init)))

(custom-set-variables
 '(py-pychecker-command "/home/folone/bin/pycheckers")
 '(py-pychecker-command-args (quote ("")))
 '(python-check-command "/home/folone/bin/pycheckers"))

(add-hook 'find-file-hook 'flymake-find-file-hook)

;;(add-hook 'python-mode-hook 'flymake-mode)
;;(add-hook 'python-mode-hook 'flymake-python-pyflakes-load)

(require 'roy-mode)

;;(eval-after-load "color-theme" '(color-theme-blackboard))

;; minimap
(require 'minimap)

(require 'evil)
(evil-mode 1)
(setq evil-default-cursor t)
(set-cursor-color "#cdcdc1")

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

;; Toggling minimap
(defun minimap-toggle ()
  "Toggle minimap for current buffer."
  (interactive)
  (if (null minimap-bufname)
      (minimap-create)
    (minimap-kill)
    (balance-windows))
  )

;; Configuration for ibuffer
(setq ibuffer-saved-filter-groups
  (quote (("default"
            ("Org" ;; all org-related buffers
              (mode . org-mode))
            ("Scala"
             (mode . scala-mode))
            ("web"
             (or
              (mode . js2-mode)
;;              (mode . nxml-mode)
              ))
            ("Chat"
             (or
              (mode . erc-mode)
              (mode . jabber-chat)))
            ("Haskell"
             (mode . haskell-mode))
            ("SQL"
             (mode .sql-mode))
            ("Elisp"
             (filename . "el"))
           ))))

(add-hook 'ibuffer-mode-hook
  (lambda ()
    (ibuffer-switch-to-saved-filter-groups "default")))

;; Keys mapping:

;; switch to ERC with Ctrl+c e
(global-set-key (kbd "C-c e") 'djcb-erc-start-or-switch) ;; ERC

;; Scala prettification
(global-set-key (kbd "C-c p") 'prettify-scala-code)

;; F12 to toggle ecb
(global-set-key [f12] 'ecb-toggle-ecb-windows)

;; File navigation
(global-set-key [f11] 'nav)

;; Minimap
(global-set-key [f10] 'minimap-toggle)

;; Toolbar
(global-set-key [f9] 'tool-bar-mode)

;; popup-switch
;;(require 'popup-switcher)
;;(setq psw-in-window-center t)
;;(global-set-key [f2] 'psw-switch)

;; key bindings
(when (eq system-type 'darwin) ;; mac specific settings
 (setq mac-option-modifier 'meta)
  (setq mac-command-modifier 'meta)
  (global-set-key [kp-delete] 'delete-char) ;; sets fn-delete to be right-delete
  )
