(require 'tree-buffer)

(defvar ensime-package-inspector-root-node nil
 "Root node of package tree inspector.")

(defcustom ensime-package-inspector-tree-buffer-name "*Package Inspector*"
  "Name of the Ensime tree type inspector."
  :group 'ensime-inspector
  :type 'string)

;;(ensime-create-type-inspector-tree-buffer)

(defecb-tree-buffer-creator ensime-create-package-inspector-tree-buffer ensime-package-inspector-tree-buffer-name
  "Create the tree-buffer for analyse-display."
  (tree-buffer-create
   ensime-package-inspector-tree-buffer-name
   :frame ecb-frame
   :mouse-action-trigger ecb-tree-mouse-action-trigger
   :is-click-valid-fn 'ecb-interpret-mouse-click
   :node-selected-fn 'ecb-tree-buffer-node-select-callback
   :node-expanded-fn 'ecb-tree-buffer-node-expand-callback
   :node-collapsed-fn 'ecb-tree-buffer-node-collapsed-callback
   :node-mouse-over-fn 'ecb-mouse-over-analyse-node
   :mouse-highlight-fn 'ecb-analyse-node-mouse-highlighted-p
   :node-data-equal-fn 'equal
   :maybe-empty-node-types nil
   :leaf-node-types nil
   :menu-creator 'ecb-analyse-menu-creator
   :menu-titles (ecb-analyse-gen-menu-title-creator)
   :modeline-menu-creator 'ecb-common-tree-buffer-modeline-menu-creator
   :sticky-parent-p ecb-tree-make-parent-node-sticky
   :sticky-indent-string ecb-tree-stickynode-indent-string
   :sticky-parent-fn nil
   :trunc-lines t ;; RPR (ecb-member-of-symbol/value-list 
		  ;; ensime-type-inspector-tree-buffer-name
		  ;;  ecb-tree-truncate-lines)
   :read-only t
   :tree-indent ecb-tree-indent
   :incr-search-p nil ;; ecb-tree-incremental-search
   :incr-search-additional-pattern nil ;; ecb-methods-incr-searchpattern-node-prefix
   :arrow-navigation ecb-tree-navigation-by-arrow
   :hor-scroll-step ecb-tree-easy-hor-scroll
   :default-images-dir (car ecb-tree-image-icons-directories)
   :additional-images-dir (ecb-member-of-symbol/value-list ecb-analyse-buffer-name
                                                           (cdr ecb-tree-image-icons-directories)
                                                           'car 'cdr)
   :image-file-prefix "ecb-"
   :tree-style ecb-tree-buffer-style
   :ascii-guide-face ecb-tree-guide-line-face
   :type-facer nil
   :expand-symbol-before-p ecb-tree-expand-symbol-before
   :highlight-node-face ecb-analyse-face
   :general-face ecb-analyse-general-face
   :after-create-hook (append
                       (list (function (lambda ()
                                         (ecb-common-after-tree-buffer-create-actions))))
                       ecb-common-tree-buffer-after-create-hook
                       ecb-analyse-buffer-after-create-hook)
   :after-update-hook nil))

(defecb-window-dedicator-to-ecb-buffer ensime-set-package-inspector-tree-buffer
    ensime-package-inspector-tree-buffer-name t
  "Display in current window the tree inspector buffer and make window dedicated."
  ;; FIXME RPR - make delay a configuration
  (ecb-activate-ecb-autocontrol-function 2 'ensime-tree-package-inspector-idle/sync)
  (switch-to-buffer ensime-package-inspector-tree-buffer-name))

;; Override ensime's package show function.
(defun ensime-package-inspector-show (info)
  "Refined ensimes inspector show function."
  (ensime-package-inspector-tree-show info))

(defun ensime-package-info-p (info)
  (let ((type-data (plist-get info :info-type)))
    (and type-data (string-equal type-data "package"))))

(defun ensime-make-template-node (parent info)
  (let ((node-data (let ((pos (plist-get info :pos)))
		     (if pos
			 (plist-put '() :pos pos)
		       nil))))
    (let ((template-type-str (ensime-declared-as-str info)))
      (tree-node-new
       (concat " "
	       (ensime-font-lock-node-text-face template-type-str font-lock-keyword-face)
	       (if (equal (length template-type-str) 5)
		   "  "
		 " ")
	       (ensime-font-lock-node-text-face (plist-get info :name) font-lock-variable-name-face))
       0 node-data t parent nil))))

;; root: TreeNode
;; info: PList
(defun ensime-make-package-node (parent info)
  (let* ((pkg-name (plist-get info :name))
	 (pkg-node (tree-node-new pkg-name 0 '() nil parent nil)))
    (dolist (m (plist-get info :members))
      (if (ensime-package-info-p m) 
	  (ensime-make-package-node pkg-node m)
	(ensime-make-template-node pkg-node m)))))

;;    (ensime-make-package-node pkg-node (car (plist-get info :members)))))

(defun ensime-package-inspector-tree-show (info)
  (with-current-buffer ensime-package-inspector-tree-buffer-name
    (tree-buffer-set-root (tree-node-new-root))
    (ensime-make-package-node (tree-buffer-get-root) info)
    (dolist (n (tree-node->children (tree-buffer-get-root)))
      (tree-node-toggle-expanded n))
    (tree-buffer-update)))

(defecb-tree-buffer-callback ecb-method-clicked ensime-package-inspector-tree-buffer-name select
                             (&optional no-post-action additional-post-action-list)
  "Handles all user events when a user clicks onto a node in the package-inspector-buffer."
  (let* ((pos (plist-get (tree-node->data node) :pos))
	 (src-path (plist-get pos :file))
	 (offset (plist-get pos :offset)))
    ;; First of all we must highlight the tag
    (tree-buffer-highlight-node-by-data/name (tree-node->data node) (tree-node->name node))
    (ensime-ecb-member-node-selected node ecb-button edit-window-nr shift-mode meta-mode)))

;; Create an idle time function to update the package tree inspector
(defecb-autocontrol/sync-function ensime-tree-package-inspector-idle/sync
    ensime-package-inspector-tree-buffer-name
    nil
    nil
  "Create and register a function to update the packge tree inspector during idle."
  ;; (message "Package Inspector idle refresh.")
  (ensime-inspect-project-package))

(provide 'ensime-tree-package-inspector)
