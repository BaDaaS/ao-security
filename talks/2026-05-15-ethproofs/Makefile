.PHONY: help
help: ## Ask for help!
	@grep -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		sort | \
		awk 'BEGIN {FS = ":.*?## "}; \
		{printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

BUILD_DIR := _build

.PHONY: build
build: slides.pdf ## Build the slides PDF

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

$(BUILD_DIR)/slides.pdf: slides.tex | $(BUILD_DIR)
	pdflatex -interaction=nonstopmode -halt-on-error \
		-output-directory=$(BUILD_DIR) slides.tex
	pdflatex -interaction=nonstopmode -halt-on-error \
		-output-directory=$(BUILD_DIR) slides.tex

slides.pdf: $(BUILD_DIR)/slides.pdf
	ln -sf $(BUILD_DIR)/slides.pdf slides.pdf

.PHONY: present
present: slides.pdf ## Open the slides for presenting
	open -a Preview slides.pdf

.PHONY: watch
watch: ## Rebuild on change (requires fswatch)
	fswatch -o slides.tex | xargs -n1 -I{} $(MAKE) build

.PHONY: lint
lint: ## Lint the LaTeX source with chktex
	chktex -q slides.tex

.PHONY: format
format: ## Format the LaTeX source in place with latexindent
	latexindent -s -w -m slides.tex

.PHONY: check-format
check-format: ## Check formatting without modifying the file
	latexindent -s -m --check slides.tex

.PHONY: clean
clean: ## Remove build artifacts and PDF symlink
	rm -rf $(BUILD_DIR) slides.pdf slides.bak* indent.log

.PHONY: distclean
distclean: clean ## Alias for clean (kept for compatibility)
