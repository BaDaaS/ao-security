.PHONY: help
help: ## Ask for help!
	@grep -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		sort | \
		awk 'BEGIN {FS = ":.*?## "}; \
		{printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: setup
setup: ## Setup development environment
	npm --prefix doc install

.PHONY: dev
dev: ## Run documentation dev server
	(cd doc && npx docusaurus start)

.PHONY: build
build: ## Build documentation for production
	(cd doc && npx docusaurus build)

.PHONY: serve
serve: ## Serve built documentation locally
	(cd doc && npx docusaurus serve)

.PHONY: clean
clean: ## Clean build artifacts and caches
	(cd doc && npx docusaurus clear)

.PHONY: check-format
check-format: ## Check formatting
	npx prettier --check "doc/docs/**/*.md"

.PHONY: format
format: ## Format markdown files
	npx prettier --write "doc/docs/**/*.md"

.PHONY: typecheck
typecheck: ## Run TypeScript type checker
	(cd doc && npx tsc --noEmit)

.PHONY: test-sage
test-sage: ## Run all SageMath files
	.github/scripts/run-sage-tests.sh sage

.PHONY: lint-shell
lint-shell: ## Lint shell scripts using shellcheck
	shellcheck .github/scripts/*.sh
