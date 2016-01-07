(ns cljnode.server
  "Main server class"
  {:authors ["Maxim Molchanov <elzor.job@gmail.com>"
             "Duncan McGreggor <oubiwann@gmail.com>"
             "Eric Bailey <eric@ericb.me>"]}
  (:require [clojure.tools.logging :as log]
            [cljnode.proto :as proto])
  (:import [com.ericsson.otp.erlang
            OtpErlangTuple
            OtpNode])
  (:gen-class))

(defn process
  [msg mbox]
  (let [cmd (.elementAt ^OtpErlangTuple msg 0)]
    (if (= (.atomValue cmd) "ping")
      (proto/handle-ping msg mbox)
      (log/error (format "Undefined msg: %s" (str msg))))))

(defn handle-erl-messages
  [mbox]
  (try
    (let [msg (.receive mbox 50)]
      (when (instance? OtpErlangTuple msg) (process msg mbox))
      #(handle-erl-messages mbox))
    (catch Exception e
      (log/error (format (str e))))))

(defn server
  [node-name mbox cookie port]
  (log/info (str "Started with params:"
                 "\n\tnodename: "  node-name
                 "\n\tmbox: "      mbox
                 "\n\tcookie: "    cookie
                 "\n\tepmd_port: " port))
  (let [mbox (.createMbox (new OtpNode node-name cookie port) mbox)]
    (proto/check-erl-node mbox 10000)
    (trampoline handle-erl-messages mbox)
    (log/info "Terminating Clojure node server ...")))
