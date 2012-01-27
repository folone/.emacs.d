(require 'ensime)
(require 'ecb)
(require 'ensime-tree-type-inspector)
(require 'ensime-tree-package-inspector)

;; Main startup ensime with ecb support
(defun ensime-ecb ()
  (interactive)
  (ecb-activate)
  (ecb-layout-switch "leftright-package"))

(provide 'ensime-ecb)
