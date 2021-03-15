.PHONY: init-project-hugo-docs hugo-ci-local

init-project-hugo-docs: docs docs/config.yaml docs/layouts/index.json docs/themes/learn docs/content/_index.md .gitlab-ci.yml ##@projects Initialize a hugo site
	@echo "Initializing Hugo Docs project."
	@git add docs
	@git commit -m "Initialize docs site."
	@echo "Your new docs site has been added, configuration instructions are in docs/config.yaml"
	@echo "To publish content/_index.md, remove 'draft: true' from forematter"
	@echo "Usage (from inside docs folder):"
	@echo "  hugo new <path/to/file.md> --> create new pages."
	@echo "  hugo serve --> serve files locally at http://localhost:1313/PROJECT"

docs: hugo
	@echo "Download URL is $(hugo_DOWNLOAD_URL)"
	@hugo new site docs

docs/content/_index.md:
	@cd docs && hugo new _index.md

docs/themes/learn: 
	@git submodule add https://github.com/matcornic/hugo-theme-learn.git docs/themes/learn

docs/config.yaml:
	@echo "Initializing config.yaml."
	@mkdir -p docs
	@cp $(FILES_DIR)/hugo-docs/config.yaml.tmpl $@
	@rm -f docs/config.toml

docs/layouts/index.json:
	@echo "Initializing search index.json."
	@cp $(FILES_DIR)/hugo-docs/index.json $@

hugo-ci-local: gitlab-runner .gitlab-ci.yml ##Run CI tests for hugo docs project
	@gitlab-runner exec docker test

.gitlab-ci.yml:
	@echo "Copying hugo CI file"
	@cp $(FILES_DIR)/hugo-docs/.gitlab-ci.yml.tmpl .gitlab-ci.yml
