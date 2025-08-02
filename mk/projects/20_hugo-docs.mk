.PHONY: init-project-hugo-docs hugo-ci-local

init-project-hugo-docs: docs docs/config.yaml docs/layouts/index.json docs/themes/learn docs/content/_index.md .gitlab-ci.yml ##@projects@hugo Create a new hugo docs site at the root level of the project
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


## None of the remaining targets have docs as a dependency, but they will fail if it is not present. This is intentional
## The hugo `new site docs` command will fail if the docs directory is present and not empty, so we must not create it
## in any other targets.
## But if you make it a dependency, it changes at each stage, so the whole process fails because it keeps trying to make 
## a new hugo docs site #TODO... make docs target depend on the directory not existing so that we can add it as a dep

docs/content/_index.md:
	@cd docs && hugo new _index.md

docs/themes/learn: 
	@echo "Installing learn theme as submodule"
	@git submodule add https://github.com/matcornic/hugo-theme-learn.git docs/themes/learn

docs/config.yaml:
	@echo "Initializing config.yaml."
	@cp $(FILES_DIR)/hugo-docs/config.yaml.tmpl $@
	@rm -f docs/config.toml

docs/layouts/index.json:
	@echo "Initializing search index.json."
	@cp $(FILES_DIR)/hugo-docs/index.json $@

hugo-ci-local: gitlab-runner .gitlab-ci.yml ##@hugo@testing Run CI tests for hugo docs project
	@echo "Running gitlab tests for hugo"
	@gitlab-runner exec docker test

#@TODO: Re-instate this target in such a way that it doesn't conflict with the corresponding one in mk/project/ddev_drupal/init-project-drupal.mk
#.gitlab-ci.yml:
#	@echo "Copying hugo CI file"
#	@cp $(FILES_DIR)/hugo-docs/.gitlab-ci.yml.tmpl .gitlab-ci.yml
