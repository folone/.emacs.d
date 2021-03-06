;; pg-goals.el ---  Proof General goals buffer mode.
;;
;; Copyright (C) 1994-2009 LFCS, University of Edinburgh.
;; Authors:   David Aspinall, Yves Bertot, Healfdene Goguen,
;;            Thomas Kleymann and Dilip Sequeira
;; License:   GPL (GNU GENERAL PUBLIC LICENSE)
;;
;; pg-goals.el,v 11.0 2010/10/10 22:57:05 da Exp
;;

;;; Commentary:

;;; Code:
(eval-when-compile
  (require 'easymenu)			; easy-menu-add, etc
  (require 'cl)				; incf
  (require 'span)			; span-*
  (defvar proof-goals-mode-menu)	; defined by macro below
  (defvar proof-assistant-menu))	; defined by macro in proof-menu

(require 'pg-assoc)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Goals buffer mode
;;

;;;###autload
(define-derived-mode proof-goals-mode proof-universal-keys-only-mode
  proof-general-name
  "Mode for goals display.
May enable proof-by-pointing or similar features.
\\{proof-goals-mode-map}"
  (setq proof-buffer-type 'goals)
  (add-hook 'kill-buffer-hook 'pg-save-from-death nil t)
  (easy-menu-add proof-goals-mode-menu proof-goals-mode-map)
  (easy-menu-add proof-assistant-menu proof-goals-mode-map)
  (proof-toolbar-setup)
  (buffer-disable-undo)
  (if proof-keep-response-history (bufhist-mode)) ; history for contents
  (set-buffer-modified-p nil)
  (setq cursor-type 'bar))

;;
;; Menu for goals buffer
;;
(proof-eval-when-ready-for-assistant ; proof-aux-menu depends on <PA>
    (easy-menu-define proof-goals-mode-menu
      proof-goals-mode-map
      "Menu for Proof General goals buffer."
      (proof-aux-menu)))

;;
;; Keys for goals buffer
;;
(define-key proof-goals-mode-map [q] 'bury-buffer)
;; TODO: use standard Emacs button behaviour here (cf Info mode)
(define-key proof-goals-mode-map [mouse-1] 'pg-goals-button-action)
(define-key proof-goals-mode-map [C-M-mouse-3]
  'proof-undo-and-delete-last-successful-command)



;;
;; The completion of init
;;
;;;###autoload
(defun proof-goals-config-done ()
  "Initialise the goals buffer after the child has been configured."
  (setq font-lock-defaults '(proof-goals-font-lock-keywords)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Goals buffer processing
;;
(defun pg-goals-display (string)
  "Display STRING in the `proof-goals-buffer', properly marked up.
Converts term substructure markup into mouse-highlighted extents."
  (save-excursion
    ;; Response buffer may be out of date. It may contain (error)
    ;; messages relating to earlier proof states

    ;; NB: this isn't always the case.  In Isabelle
    ;; we get <WARNING MESSAGE> <CURRENT GOALS> output,
    ;; or <WARNING MESSAGE> <ORDINARY MESSAGE>.  Both times
    ;; <WARNING MESSAGE> would be relevant.
    ;; We should only clear the output that was displayed from
    ;; the *previous* prompt.

    ;; Erase the response buffer if need be, maybe removing the
    ;; window.  Indicate it should be erased before the next output.
    (pg-response-maybe-erase t t)

    ;; Erase the goals buffer and add in the new string
    (set-buffer proof-goals-buffer)

    (setq buffer-read-only nil)

    (unless (eq 0 (buffer-size))
      (bufhist-checkpoint-and-erase))

    ;; Only display if string is non-empty.
    (unless (string-equal string "")
      (insert string))

    (setq buffer-read-only t)
    (set-buffer-modified-p nil)
    
    ;; Keep point at the start of the buffer.
    (proof-display-and-keep-buffer
     proof-goals-buffer (point-min))))

;;
;; Actions in the goals buffer
;;

(defun pg-goals-button-action (event)
  "Construct a command based on the mouse-click EVENT."
  (interactive "e")
  (let* ((posn     (event-start event))
	 (pos      (posn-point posn))
	 (buf      (window-buffer (posn-window posn)))
	 (props    (text-properties-at pos buf))
	 (sendback (plist-get props 'sendback)))
    (cond
     (sendback
      (with-current-buffer buf
	(let* ((cmdstart (previous-single-property-change pos 'sendback
							  nil (point-min)))
	       (cmdend   (next-single-property-change pos 'sendback
						      nil (point-max)))
	       (cmd      (buffer-substring-no-properties cmdstart cmdend)))
	  (proof-insert-sendback-command cmd)))))))





(provide 'pg-goals)

;;; pg-goals.el ends here
