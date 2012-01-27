(require 'tree-buffer)

(defgroup ensime-inspector nil
  "Type Inspector Configuration"
  :prefix "ensime-"
  :group 'ensime)

(defvar ensime-type-inspector-root-node nil
  "Root node of currently selected source.")

(defcustom ensime-type-inspector-tree-buffer-name "*Tree Inspector*"
  "Name of the Ensime tree type inspector."
  :group 'ensime-inspector
  :type 'string)

(defecb-tree-buffer-creator ensime-create-type-inspector-tree-buffer ensime-type-inspector-tree-buffer-name
  "Create the tree-buffer for analyse-display."
  (tree-buffer-create
   ensime-type-inspector-tree-buffer-name
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

(defecb-window-dedicator-to-ecb-buffer ensime-set-type-inspector-tree-buffer
    ensime-type-inspector-tree-buffer-name t
  "Display in current window the tree inspector buffer and make window dedicated."
  ;; Schedule for 4 secs idle
  ;; Need to put this on a post-xxx hook.
  ;; FIXME RPR - make delay a configuration
  (ecb-activate-ecb-autocontrol-function 0.75 'ensime-tree-inspector-idle/sync)

  (switch-to-buffer ensime-type-inspector-tree-buffer-name))

;; Create, register and schedule an idle time function to update the tree inspector
(defecb-autocontrol/sync-function ensime-tree-inspector-idle/sync
    ensime-type-inspector-tree-buffer-name
    nil
    nil
  "Create and register an idle function to update the tree inspector."
  ;; (message "Tree Inspector idle refresh.")
  (ensime-inspect-type-at-point))

(defun ensime-type-inspector-show (info)
  "Refined ensimes inspector show function."
  (ensime-type-inspector-tree-show info))

(defmacro ensime-font-lock-node-text-face (text face)
  "Font lock face of text for a tree node."
  `(tree-buffer-merge-face ,face 0 (length ,text) ,text))  
  
(defun ensime-type-inspector-tree-show (info)
  "Display all members of the type under point using tree UI."
  (if (null info)
      (message "Cannot inspect nil type.")    
    (let* ((interfaces (plist-get info :interfaces))
	   (type (plist-get info :type))
	   (type-id (plist-get type :type-id))
	   (companion-id (plist-get info :companion-id))
	   (buffer-name ensime-inspector-buffer-name)
	   (ensime-indent-level 0))
      (with-current-buffer ensime-type-inspector-tree-buffer-name
	;; Main Type
	(tree-buffer-set-root (tree-node-new-root))
	(let* ((full-type-name (ensime-font-lock-node-text-face (format "%s %s"  
									(plist-get type :decl-as) 
									(plist-get type :name))
								font-lock-variable-name-face))
	       (type-node (tree-node-new full-type-name 0 (list 'type-name 0)
					 nil (tree-buffer-get-root))))
	  (tree-node-toggle-expanded type-node)
	  ;; Companion Id
	  (if companion-id
	      (tree-node-new (format "Companion object id: %s" companion-id) 0 nil t type-node nil)
	    (tree-node-new "No companion object" 0 nil t type-node nil))
	  
	  ;; top level class methods first
	  (catch 'break 
	    (dolist (interface interfaces)
	      (let ((itype (plist-get interface :type)))
		(when (equal type-id (plist-get itype :type-id))
		  (dolist (m (plist-get itype :members))
		    (let ((type (ensime-member-type m)))
		      (when (or (equal 'method (ensime-declared-as m))
				(equal 'field (ensime-declared-as m)))
			(make-member-node type-node m))))
		  (throw 'break nil)))))
	    
	  ;; Rest of Template type's interfaces
	  (dolist (interface interfaces)
	    (let ((itype (plist-get interface :type)))
	      (unless (equal type-id (plist-get itype :type-id))
		(let ((interface-node (make-interface-node type-node interface))
		      (members (plist-get itype :members)))
		  ;; Interface type's members
		  (dolist (m members)
		    (let ((type (ensime-member-type m)))
		      (when (or (equal 'method (ensime-declared-as m))
				(equal 'field  (ensime-declared-as m)))
			(make-member-node interface-node m))))))))

	  (tree-buffer-update))))))

	      ;; (let* ((type-args (ensime-type-type-args type))
	      ;;        (last-type-arg (car (last type-args)))
	      ;;        (is-obj (ensime-type-is-object-p type)))
	      ;;   '()))))))))


;; parent: TreeNode
;; interface: PList
;; => TreeNode
(defun make-interface-node (parent interface)
  "Make a tree node from template property list."
  (let* ((owner-type (plist-get interface :type))
	 (implicit (plist-get interface :via-view)))
    (let ((template-node (tree-node-new 
			  (concat (ensime-font-lock-node-text-face (ensime-declared-as-str owner-type) font-lock-keyword-face)
				  " " 
				  (ensime-font-lock-node-text-face (plist-get owner-type :name) font-lock-variable-name-face)
				  (if implicit 
				      (ensime-font-lock-node-text-face (concat " (via implicit, " implicit ")") font-lock-comment-face)
				    ""))
			  0 '() nil parent nil)))
      ;; Add fully qualified (package) name
      (tree-node-new (concat " "(plist-get owner-type :full-name))
		     0 '() t template-node nil)
      template-node)))

;; parent: TreeNode
;; member: PList
;; => TreeNode
(defun make-member-node (parent member)
  "Make a tree node for template members."
  (let ((full-node-name (concat " " (ensime-font-lock-node-text-face (ensime-member-name member) font-lock-function-name-face)
				" " (ensime-font-lock-node-text-face (ensime-type-name type) font-lock-type-face)))
	(node-data (let ((pos (plist-get member :pos)))
		     (if pos 
			 (plist-put '() :pos pos)
		       nil))))
    (tree-node-new full-node-name 0 node-data t parent nil)))

(defecb-tree-buffer-callback ecb-method-clicked ensime-type-inspector-tree-buffer-name select
                             (&optional no-post-action additional-post-action-list)
  "Handles all user events when a user clicks onto a node in the tree-inspector--buffer."
  (let* ((pos (plist-get (tree-node->data node) :pos))
	 (src-path (plist-get pos :file))
	 (offset (plist-get pos :offset)))
    ;; First of all we must highlight the tag
    (tree-buffer-highlight-node-by-data/name (tree-node->data node) (tree-node->name node))
    (ensime-ecb-member-node-selected node ecb-button edit-window-nr shift-mode meta-mode)))
   
;; NOTES
;; Middle -> Source 1
;; Alt-Middle -> 1
;; Sft-Middle -> 1
;; Other-window -> splitted if C-middle hmmmm.

(defun ensime-ecb-member-node-selected (node ecb-button edit-window-nr shift-mode meta-mode)
  ;; Load if necessary and switch to the method's source buffer
  (let* ((pos (plist-get (tree-node->data node) :pos))
	 (src-path (plist-get pos :file))
	 (offset (plist-get pos :offset)))
    (if src-path
	(let ((other-window (ecb-combine-ecb-button/edit-win-nr ecb-button edit-window-nr)))
	  (ecb-set-selected-source src-path other-window shift-mode)
	  (goto-char offset))
      (message "No source information for template member %s" (tree-node->name node)))))

(provide 'ensime-tree-type-inspector)
