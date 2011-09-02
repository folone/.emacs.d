;; Custom view
(defun custom-look ()
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
         default-frame-alist)))

(provide 'custom-look)
