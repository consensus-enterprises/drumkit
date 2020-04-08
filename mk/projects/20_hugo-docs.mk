init-project-hugo-docs-intro:
	@echo "Initializing Hugo Docs project."

hugo-docs.conf:
	@echo "Please provide the following information to initialize your Hugo docs site:"
	@read -p "GitLab group name: " group && echo "GROUP=$${group}" >> hugo-docs.conf
	@read -p "GitLab project name: " project && echo "PROJECT=$${project}" >> hugo-docs.conf

clean-hugo-docs.conf:
	@rm hugo-docs.conf

init-project-hugo-docs: init-project-hugo-docs-intro hugo hugo-docs.conf init-project-hugo-docs-dir docs/config.yaml hugo-docs-search-index
	@git add docs
	@git commit -m "Initialize docs site."
	@cd docs && hugo new _index.md
	@echo "Your new docs site is initialized, please edit docs/config.yaml to fill in site details."
	@echo "Initial homepage _index.md file requires edits to be published (remove draft: true). "
	@echo "Usage (from inside docs folder):"
	@echo "  hugo new <path/to/file.md> --> create new pages."
	@echo "  hugo serve --> serve files locally at http://localhost:1313/PROJECT"

init-project-hugo-docs-dir:
	@hugo new site docs
	@git submodule add https://github.com/matcornic/hugo-theme-learn.git docs/themes/learn

docs/config.yaml: jinja2
	@echo "Initializing config.yaml."
	@echo jinja2 `perl -n < hugo-docs.conf -e 'chomp and print " -D " and print "\"$$_\""'` -o $@ $(FILES_DIR)/hugo-docs/config.yaml.j2 > .drumkit-hugo-docs-init-config.cmd
	@echo jinja2 `perl -n < hugo-docs.conf -e 'chomp and print " -D " and print "\"$$_\""'` -o $@ $(FILES_DIR)/drupal8/lando.yml.j2  > .drumkit-drupal8-init-lando.cmd
	@ . .drumkit-hugo-docs-init-config.cmd
	@rm .drumkit-hugo-docs-init-config.cmd
	@rm docs/config.toml

hugo-docs-search-index:
	@echo "Initializing search index.json."
	@cp $(FILES_DIR)/hugo-docs/index.json docs/layouts/index.json
