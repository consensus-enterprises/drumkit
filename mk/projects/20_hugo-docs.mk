init-project-hugo-docs-intro:
	@echo "Initializing Hugo Docs project."
	@echo "OS is $(OS)"

hugo-docs.conf:
	@echo "Please provide the following information to initialize your Hugo Gitlab Pages site:"
	@read -p "GitLab group name: " group && export GITLAB_GROUP=$${group} && \
	read -p "GitLab project name: " project && export GITLAB_PROJECT_NAME=$${project}

docs/config.yaml: mustache
	@echo "Initializing config.yaml."
	@mkdir -p docs
	@mustache ENV $(FILES_DIR)/hugo-docs/config.yaml.tmpl > $@
	@rm -f docs/config.toml


clean-hugo-docs.conf:
	@rm hugo-docs.conf


init-project-hugo-docs: init-project-hugo-docs-intro hugo-docs.conf init-project-hugo-docs-dir docs/config.yaml hugo-docs-search-index ##@projects Initialize a hugo site
	@git add docs
	@git commit -m "Initialize docs site."
	@cd docs && hugo new _index.md
	@echo "Your new docs site is initialized, please edit docs/config.yaml to fill in site details."
	@echo "Initial homepage _index.md file requires edits to be published (remove draft: true). "
	@echo "Usage (from inside docs folder):"
	@echo "  hugo new <path/to/file.md> --> create new pages."
	@echo "  hugo serve --> serve files locally at http://localhost:1313/PROJECT"

init-project-hugo-docs-dir: hugo
	@echo "Download URL is $(hugo_DOWNLOAD_URL)"
	@hugo new site docs
	@git submodule add https://github.com/matcornic/hugo-theme-learn.git docs/themes/learn

hugo-docs-search-index:
	@echo "Initializing search index.json."
	@cp $(FILES_DIR)/hugo-docs/index.json docs/layouts/index.json

hugo-ci-local: gitlab-runner .gitlab-ci.yml
	gitlab-runner exec docker tests

.gitlab-ci.yml:
	@echo "Copying hugo CI file"
	@cp $(FILES_DIR)/hugo-docs/.gitlab-ci.yml.tmpl .gitlab-ci.yml