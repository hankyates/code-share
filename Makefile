BUILD_DIR ?= build

P="\\033[34m[+]\\033[0m"

help:
	@echo
	@echo "  \033[34mbuild\033[0m – builds the component"
	@echo "  \033[34mstart\033[0m – start dev server on :8000 with hot module replacement"
	@echo

build:
	@echo "  $(P) build"
	@$(MAKE) elm
	@$(MAKE) static
	@$(MAKE) sass
	@echo

static:
	@echo "  $(P) static"
	@mkdir -p $(BUILD_DIR)
	@cp -v static/* build/
	@echo

elm:
	@echo "  $(P) elm"
	@mkdir -p $(BUILD_DIR)
	@elm-make ./src/Main.elm --output $(BUILD_DIR)/main.js
	@echo

sass:
	@echo "  $(P) sass"
	@mkdir -p $(BUILD_DIR)
	@node-sass sass/main.scss $(BUILD_DIR)/main.css
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
	@cd $(BUILD_DIR) && python -m SimpleHTTPServer
	@echo

publish:
	@echo "  $(P) publish"
	@$(MAKE) clean
	@$(MAKE) build
	@./scripts/push-gh-pages $(BUILD_DIR)
	@echo

clean:
	@echo "  $(P) clean"
	@rm -rf $(BUILD_DIR)
	@echo

.PHONY: build start serve help clean publish sass static elm
