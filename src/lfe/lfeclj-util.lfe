(defmodule lfeclj-util
  (export (make-name 2)
          (ping 3)))

(defun make-name (node host)
  "Given a `node` and `host`, return `\"node@host\"`."
  (++ node "@" host))

(defun ping (mbox recip sender)
  "Send `` `#(ping ,sender) `` to `recip` at `mbox`."
  (! `#(,mbox ,recip) `#(ping ,sender)))
