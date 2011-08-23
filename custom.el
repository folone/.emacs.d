;; Desktop saving
(desktop-save-mode 1)

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
      browse-url-generic-program "chromium-browser")
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
(custom-set-faces
  '(default ((t (:foreground "Wheat"))))
  '(region ((t (:foreground "White" :background "MediumSlateBlue"))) t)
  '(modeline ((t (:foreground "DarkSlateBlue" :background "White"))) t)
  '(list-mode-item-selected ((t (:background "gray68"))) t)
  '(font-lock-comment-face ((t (:foreground "Coral"))))
  '(font-lock-builtin-face ((t (:foreground "Violet"))))
  '(font-lock-reference-face ((t (:foreground "DodgerBlue"))))
  '(font-lock-string-face ((t (:foreground "LimeGreen"))))
  '(font-lock-keyword-face ((t (:foreground "aquamarine"))))
  '(show-paren-mismatch-face ((((class color)) (:foreground "white" :background "red"))))
  '(isearch ((t (:foreground "black" :background "paleturquoise"))) t)
  '(paren-match ((t (:background "darkseagreen4"))) t)
  '(widget-field-face ((((class color) (background light)) (:foreground "Red" :background "Brown"))))
  '(widget-field-face ((((class color) (background dark)) (:foreground "Red" :background "Brown"))))
  '(widget-button-face ((t (:bold t :foreground "black" :background "gray60"))))
  '(font-lock-preprocessor-face ((t (:italic nil :foreground "CornFlowerBlue"))) t)
  '(font-lock-type-face ((t (:foreground "#9290ff"))))
  '(highlight ((t (:foreground "black" :background "darkseagreen2"))))
  '(show-paren-match-face ((((class color)) (:foreground "black" :background "yellow"))))
  '(font-lock-variable-name-face ((t (:foreground "Khaki"))))
  '(font-lock-doc-string-face ((t (:foreground "green2"))) t)
  '(font-lock-function-name-face ((t (:foreground "SteelBlue"))))
  '(font-lock-keys-face ((t (:foreground "LightSteelBlue"))))
  '(font-lock-number-face ((t (:foreground "Yellow"))))
  '(font-lock-hexnumber-face ((t (:foreground "Orange"))))
  '(font-lock-floatnumber-face ((t (:foreground "DarkGrey"))))
  '(font-lock-qt-face ((t (:foreground "SkyBlue"))))
  ;; Jabber colors
'(jabber-roster-user-xa ((t (:inherit font-lock-comment-face))))
'(jabber-roster-user-online ((t (:inherit font-lock-string-face))))
'(jabber-roster-user-away ((t (:inherit font-lock-keyword-face))))
'(jabber-chat-prompt-local ((t (:inherit font-lock-string-face :weight bold))))
'(jabber-chat-prompt-foreign ((t (:inherit font-lock-keyword-face :weight bold))))
 )
(set-background-color "DarkSlateBlue")
(set-foreground-color "White")
(set-cursor-color "Pink")
(set-mouse-color "Pink")
(set-border-color "DarkSlateBlue")
(setq initial-frame-alist
      (cons 
       '(foreground-color  . "White")
       initial-frame-alist))
(setq initial-frame-alist
      (cons 
       '(background-color  . "#456345")
       initial-frame-alist))
(setq initial-frame-alist
      (cons 
       '(cursor-color      . "Pink")
       initial-frame-alist))

;; Display settings
;; default size and color options for all frames
;; foreground, background, and cursor colors 
(setq default-frame-alist
      (cons 
       '(foreground-color  . "White")
       default-frame-alist))
(setq default-frame-alist
      (cons 
       '(background-color  . "#456345")
       default-frame-alist))
(setq default-frame-alist
      (cons 
       '(cursor-color      . "Pink")
       default-frame-alist))

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
(add-to-list 'load-path (concat dotfiles-dir "/scala-mode"))
(require 'scala-mode-auto)

;; Load ensime mode
(add-to-list 'load-path (concat dotfiles-dir "/ensime/elisp"))
(require 'ensime)

;; This step causes the ensime-mode to be started whenever
;; scala-mode is started for a buffer. You may have to customize this step
;; if you're not using the standard scala mode.
(add-hook 'scala-mode-hook 'ensime-scala-mode-hook)
(setq exec-path (append exec-path (list "~/bin/scala-2.9.0.1/bin" )))

;; MINI HOWTO: 
;; Open .scala file. M-x ensime (once per project)

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
