(require 'color-theme)

(setq dzhan-fore-color    "#b0b0b0"
      dzhan-back-color    "#303058"
      dzhan-orange-color  "#f09a71"
      dzhan-comment-color "#10a5b7")

(defun color-theme-dzhan ()
  "Color theme by Roman Zaharov <zahardzhan@gmail.com>"
  (Interactive)
  (Color-theme-install
   `(color-theme-dzhan
     ((foreground-color . ,dzhan-fore-color)
      (background-color . ,dzhan-back-color)
      (mouse-color      . ,dzhan-fore-color)
      (cursor-color     . ,dzhan-fore-color)
      (border-color     . "#405088")
      (background-mode  . dark))

     ((help-highlight-face . underline)
      (list-matching-lines-face . bold)
      (widget-mouse-face . highlight))

     (default ((t (:height normal :width normal
                           :background ,dzhan-back-color
                           :foreground ,dzhan-fore-color
                           :inverse-video nil :box nil :strike-through nil
                           :overline nil :stipple nil :underline nil
                           :slant normal :weight normal))))

     (bold ((t (:bold t :weight bold))))
     (bold-italic ((t (:italic t :bold t :slant italic :weight bold))))
     (border ((t (:background "#25254d"))))
     (comint-highlight-input ((t (:bold t :weight bold))))
     (comint-highlight-prompt ((t (:foreground "cyan"))))
     (cursor ((t (:foreground "#303058" :background "#b0b0b0"))))
     
     (fixed-pitch ((t (:family "courier"))))

     (font-lock-builtin-face ((t (:foreground "#899cff"))))
     (font-lock-comment-face ((t (:foreground ,dzhan-comment-color))))
     (font-lock-constant-face ((t (:foreground "13c1d5"))))
     (font-lock-doc-face ((t (:foreground ,dzhan-comment-color))))
     (font-lock-doc-string-face ((t (:foreground ,dzhan-comment-color))))
     (font-lock-function-name-face ((t (:foreground "#8dbafc"))))
     (font-lock-keyword-face ((t (:foreground ,dzhan-orange-color))))
     (font-lock-preprocessor-face ((t (:foreground ,dzhan-orange-color))))
     (font-lock-reference-face ((t (:underline t))))
     (font-lock-string-face ((t (:foreground "#4aa5ff"))))
     (font-lock-type-face ((t (:foreground ,dzhan-orange-color))))
     (font-lock-variable-name-face ((t (:foreground "#44c573"))))
     (font-lock-warning-face ((t (:bold t :foreground "#d04d63" :weight bold))))
     
     (fringe ((t (:background "#222251" :foreground "#b0b0b0"))))
     (header-line ((t (:box (:line-width -1 :style released-button) 
                       :background "grey20" :foreground "grey90" :box nil))))
     (highlight ((t (:background "#222251"))))
     (horizontal-divider ((t (:background "gray16" :foreground "#00ff00"))))
     
     (ido-first-match ((t (:foreground ,dzhan-orange-color))))
     (ido-only-match ((t (:foreground ,dzhan-orange-color :bold t))))
     (ido-subdir ((t (:foreground ,dzhan-orange-color))))
     
     (isearch ((t (:box (:line-width -1) :foreground ,dzhan-orange-color :background ,dzhan-back-color :underline nil))))
     (isearch-fail ((t (:background ,dzhan-back-color :foreground ,dzhan-orange-color :weight bold :inverse-video t))))
     (isearch-lazy-highlight-face ((t  (:background ,dzhan-back-color :foreground ,dzhan-orange-color :underline t))))
     
     (italic ((t (:italic t :slant italic))))
     (menu ((t (:background "gray16" :foreground "green"))))
     
     (modeline ((t (:background "grey75" :foreground "grey15" :box (:line-width -1 :style flat)))))
     (modeline-highlight ((t (:bold t))))
     (mode-line-inactive ((t (:background "grey60" :foreground "grey15" :box (:line-width -1 :style flat)))))
     
     (minibuffer-prompt ((t (:foreground ,dzhan-orange-color))))
     
     (mouse ((t (:background "yellow"))))
     (primary-selection ((t (:background "#4a4a67"))))
     (region ((t (:background "#444478"))))
     (scroll-bar ((t (:background "gray16" :foreground "#00ff00"))))
     (secondary-selection ((t (:background "#00ff00" :foreground "black"))))

     (show-paren-match    ((t (:foreground ,dzhan-orange-color :weight bold))))
     (show-paren-mismatch ((t (:foreground ,dzhan-orange-color :weight bold :inverse-video t
                                           :box (:line-width -1)))))

     (slime-repl-inputed-output-face ((((class color) (background dark)) (:foreground "#4aa5ff"))))

     (font-latex-verbatim-face ((t (:foreground ,dzhan-comment-color))))

     (speedbar-button-face ((t (:foreground "#00ff00"))))
     (speedbar-directory-face ((t (:foreground ,dzhan-orange-color))))
     (speedbar-file-face ((t (:foreground ,dzhan-fore-color))))
     (speedbar-highlight-face ((t (:background "#4a4a67" :foreground "#eeeeee"))))
     (speedbar-selected-face ((t (:foreground ,dzhan-orange-color :underline t))))
     (speedbar-tag-face ((t (:foreground "yellow"))))
     (tool-bar ((t (:background "gray16" :foreground "green" :box (:line-width 1 :style released-button)))))
     (tooltip ((t (:background "#303058" :foreground "#13c1d5"))))
     (trailing-whitespace ((t (:background "red"))))
     ;;(underline ((t (:underline t))))
     (variable-pitch ((t (:family "helv"))))
     (vertical-divider ((t (:background "gray16" :foreground "#00ff00"))))
     (widget-button-face ((t (:bold t :weight bold))))
     (widget-button-pressed-face ((t (:foreground "red"))))
     (widget-documentation-face ((t (:foreground "lime green"))))
     (widget-field-face ((t (:background "dim gray"))))
     (widget-inactive-face ((t (:foreground "light gray"))))
     (widget-single-line-field-face ((t (:background "dim gray"))))
     (zmacs-region ((t (:background "steelblue" :foreground "white")))))))

(provide 'color-theme-dzhan)
