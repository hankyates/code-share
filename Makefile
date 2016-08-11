BUILD_DIR ?= build

CD := cd
MD := mkdir
PWD := pwd
ELM_MAKE := elm-make
CP := cp
PYTHON := python

P="\\033[34m[+]\\033[0m"

help:
	@echo
	@echo "  \033[34mbuild\033[0m – builds the component"
	@echo "  \033[34mstart\033[0m – start dev server on :8000 with hot module replacement"
	@echo

build:
	@echo "  $(P) build"
	@$(MD) -p $(BUILD_DIR)
	@$(ELM_MAKE) ./src/Main.elm --output $(BUILD_DIR)/main.js
	@$(CP) -v static/* build/
	@echo

start:
	@echo
	@echo "  $(P) start"
	@$(MAKE) clean
	@$(MAKE) build
	@$(MAKE) serve
	@echo

serve:
	@echo "  $(P) serve"
	@$(CD) $(BUILD_DIR) && $(PYTHON) -m SimpleHTTPServer
	@echo

publish:
	@echo "  $(P) publish"
	@$(MAKE) clean
	@$(MD) -p $(BUILD_DIR)
	@$(MAKE) build
	@./scripts/push-gh-pages $(BUILD_DIR)
	@echo

clean:
	@echo "  $(P) clean"
	@rm -rf $(BUILD_DIR)
	@echo

.PHONY: build start serve help clean publish
