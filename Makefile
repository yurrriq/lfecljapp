all: compile

priv: ; mkdir -p priv

log: ; mkdir -p log

clean: ; lein clean && rm -r priv; rebar3 clean

clojure: priv log; lein uberjar && mv target/*.jar priv

lfe: ; rebar3 do clean, compile

compile: clojure lfe

dev: ; lfe -sname lfenode -s lfeclj-app
