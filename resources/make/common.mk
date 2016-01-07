PROJECT = lfecljapp
LIB = $(PROJECT)
DEPS = ./deps
BIN_DIR = ./bin
LFETOOL=$(BIN_DIR)/lfetool
SOURCE_DIR = ./src
OUT_DIR = ./ebin
TEST_DIR = ./test
TEST_OUT_DIR = ./.eunit
SCRIPT_PATH=.:./bin:"$(PATH)":/usr/local/bin
ERL_LIBS=$(shell lfetool info erllibs)

$(BIN_DIR):
	mkdir -p $(BIN_DIR)

$(LFETOOL): $(BIN_DIR)
	@[ -f $(LFETOOL) ] || \
	curl -L -o ./lfetool https://raw.github.com/lfe/lfetool/master/lfetool && \
	chmod 755 ./lfetool && \
	mv ./lfetool $(BIN_DIR)

get-version:
	@PATH=$(SCRIPT_PATH) lfetool info version

get-deps:
	@echo "Getting dependencies ..."
	@which rebar.cmd >/dev/null 2>&1 && rebar.cmd get-deps || rebar get-deps

clean-ebin:
	@echo "Cleaning ebin dir ..."
	@-rm -f $(OUT_DIR)/*.beam $(OUT_DIR)/*.app

clean-eunit:
	@-PATH=$(SCRIPT_PATH) lfetool tests clean

compile-tests:
	@PATH=$(SCRIPT_PATH) lfetool tests build

check-unit-only:
	@PATH=$(SCRIPT_PATH) lfetool tests unit

check-integration-only:
	@PATH=$(SCRIPT_PATH) lfetool tests integration

check-system-only:
	@PATH=$(SCRIPT_PATH) lfetool tests system

check-unit-with-deps: get-deps compile compile-tests check-unit-only
check-unit: compile-no-deps check-unit-only
check-integration: compile check-integration-only
check-system: compile check-system-only
check-all-with-deps: compile check-unit-only check-integration-only \
	check-system-only
check-all: get-deps compile-no-deps
	@PATH=$(SCRIPT_PATH) lfetool tests all

check: check-unit-with-deps

check-travis: $(LFETOOL) check

push-all:
	@echo "Pusing code to github ..."
	git push --all
	git push upstream --all
	git push --tags
	git push upstream --tags

install: compile
	@echo "Installing lfecljapp ..."
	@PATH=$(SCRIPT_PATH) lfetool install lfe
