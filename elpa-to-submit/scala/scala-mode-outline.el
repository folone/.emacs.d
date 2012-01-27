;;; -*-Emacs-Lisp-*-
;;; scala-mode-structure.el - 

;;; Copyright (C) 2011 Raymond Racine

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This program is free software: you can redistribute it and/or modify     ;;
;;    it under the terms of the GNU General Public License as published by  ;;
;;    the Free Software Foundation, either version 3 of the License, or     ;;
;;    (at your option) any later version.				     ;;
;; 									     ;;
;;    This program is distributed in the hope that it will be useful,	     ;;
;;    but WITHOUT ANY WARRANTY; without even the implied warranty of	     ;;
;;    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the	     ;;
;;    GNU General Public License for more details.			     ;;
;; 									     ;;
;;    You should have received a copy of the GNU General Public License     ;;
;;    along with this program.  If not, see <http://www.gnu.org/licenses/>. ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; (defconst scala-outline-re
;;   (let* ((upto-re "[^{=]+")
;; 	(or-re   "\\|")
;; 	(tail-re (concat upto-re or-re)))
;;     (concat 
;;      "\\btrait\\b" tail-re
;;      "\\bclass\\b" tail-re
;;      "\\bobject\\b" tail-re
;;      "\\bdef\\b"    tail-re
;;      "\\bval\\b" tail-re
;;      "\\bvar\\b" upto-re
;;      )))

(provide 'scala-mode-outline)

(defconst scala-outline-re
  (let ((or-re   "\\|"))
    (concat 
     "\\btrait\\b"  or-re
     "\\bclass\\b"  or-re
     "\\bobject\\b" ;;or-re
     ;; "\\bdef\\b"    or-re
     ;; "\\bval\\b" or-re
     ;; "\\bvar\\b" 
     )))

(defun scala-outline-buffer () 
  "Create an outline of the structure of a source file."
  (interactive)
  (occur scala-outline-re))

(defun scala-outline ()
  "Create an outline of the structure of all open Scala buffers."
  (interactive)
  (multi-occur-in-matching-buffers "scala$" scala-outline-re t))

(defun scala-template-narrow (&optional posn)
  "Narrow the buffer to current template declared or the enclosing template."
  (interactive)
  (message "Posn: %s" posn)
  (let ((curr-posn (point)))
    (move-beginning-of-line 1)
    (scala-forward-spaces)
    (if (looking-at "class\\|trait\\|object")
	(let ((start-posn (move-beginning-of-line 1)))
	  (goto-char (- (search-forward "{" nil t nil) 1))
	  (forward-sexp)
	  (narrow-to-region start-posn (point))
	  (if posn 
	      (goto-char posn)
	    (goto-char curr-posn)))
      (if posn
	  (goto-char posn)
	(progn
	  (search-backward-regexp "\\bclass\\b\\|\\btrait\\b\\|\\bobject\\b")
	  (scala-template-narrow curr-posn))))))

  
   
    
