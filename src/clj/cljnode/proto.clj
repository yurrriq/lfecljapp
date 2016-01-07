(ns cljnode.proto
  "Protocol handler class"
  {:authors ["Maxim Molchanov <elzor.job@gmail.com>"
             "Duncan McGreggor <oubiwann@gmail.com>"
             "Eric Bailey <eric@ericb.me>"]}
  (:require [clojure.tools.logging :as log])
  (:import [com.ericsson.otp.erlang
            OtpErlangAtom
            OtpErlangTuple
            OtpErlangObject])
  (:gen-class))

(defn handle-ping
  [msg mbox]
  (log/info (format "Handling %s ..." msg))
  (->> [(OtpErlangAtom. "pong") (.self mbox)]
       (into-array OtpErlangObject)
       (new OtpErlangTuple)
       (.send mbox (.elementAt ^OtpErlangTuple msg 1))))

(defn link-to-erl
  [dpid mbox]
  (.link mbox dpid)
  (log/info (format "Linked with Erlang %s" dpid)))

(defn check-erl-node
  [mbox timeout]
  (let [msg-obj (.receive mbox timeout)
        cmd     (.elementAt msg-obj 0)
        dpid    (.elementAt msg-obj 1)]
    (if (= (.atomValue cmd) "ping")
      (link-to-erl dpid mbox)
      (Exception. "First message should be ping")))
  (log/info "erlang node checked"))
