(defmodule lfeclj-sup
  (behaviour supervisor)
  ;; API
  (export (start_link 0))
  ;; Supervisor callbacks
  (export (init 1)))

(defun SERVER () (MODULE))


;;;===================================================================
;;; API
;;;===================================================================

(defun start_link () (supervisor:start_link `#(local ,(SERVER)) (MODULE) []))


;;;===================================================================
;;; Supervisor callbacks
;;;===================================================================

(defun init (args)
  (let ((server    '#m(id       lfeclj-server
                       start    #(lfeclj-server start_link [])
                       restart  permanent
                       shutdown 5000
                       type     worker
                       modules  [lfeclj-server]))
        (sup-flags '#m(strategy  one_for_one
                       intensity 5
                       period    10)))
    `#(ok #(,sup-flags [,server]))))
