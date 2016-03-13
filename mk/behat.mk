behat      = $(bin_dir)/behat
behat_src  = $(src_dir)/behat
bde_dir    = $(drush_dir)/drush-bde-env
bde_exists = $(shell if [[ -d $(bde_dir) ]]; then echo 1; fi)

_help-behat:
	@echo "make behat"
	@echo "  Install Behat."

drush-bde-env: drush
ifneq '$(bde_exists)' '1'
	@echo Cloning Drush Behat config extension
	@git clone https://github.com/pfrenssen/drush-bde-env.git $(bde_dir)
	@$(drush) cc drush
endif

behat-config: behat drush-bde-env $(root)
	@echo Generating project-specific Behat config
	@cd $(root) && $(drush) beg --subcontexts=profiles/$(profile)/modules --site-root=$(root) --skip-path-check --base-url=$(uri) $(project_root)/behat_params.sh

deps-behat: aptitude-update composer
	@echo Installing Behat dependencies
	@sudo DEBIAN_FRONTEND=noninteractive apt-get -y -qq install php5-curl

clean-behat:
	@rm -rf $(behat_src)
	@rm -f $(behat)

$(behat_src)/composer.json: $(mk_dir)/behat.composer.json
	@mkdir -p $(behat_src)
	@cp $(mk_dir)/behat.composer.json $(behat_src)/composer.json

$(behat_src)/composer.lock: $(behat_src)/composer.json 
	@cd $(behat_src) && \
	rm -f composer.lock && \
	$(composer) install

$(behat_src)/bin/behat: $(behat_src)/composer.lock 

$(behat): $(behat_src)/bin/behat 
	@cd $(bin_dir) && \
	ln -sf ../src/behat/bin/behat behat

behat: $(behat)
