PACKER_JSON_DIR = scripts/packer/json
PACKER_SH_DIR = scripts/packer/scripts
PACKER_SH_SCRIPTS = $(PACKER_SH_DIR)/apt.sh $(PACKER_SH_DIR)/cleanup.sh $(PACKER_SH_DIR)/php.sh $(PACKER_SH_DIR)/purge-extra-packages.sh  $(PACKER_SH_DIR)/python.sh $(PACKER_SH_DIR)/utils.sh

init-project-packer-intro:
	@echo "Initializing Drumkit Packer project."

.drumkit-packer.conf:
	@echo "Please provide the following information to initialize your Packer scripts:"
	@read -p "Docker container project name: " project && echo "CONTAINER_PROJECT_NAME=$${project}" >> drumkit-packer.conf
	@read -p "Docker container registry URL: " registry_url && echo "CONTAINER_REGISTRY_URL=$${registry_url}" >> drumkit-packer.conf

clean-drumkit-packer.conf:
	@rm .drumkit-packer.conf

init-project-packer: init-project-packer-intro .drumkit-packer.conf $(MK_D)/20-ci.mk
	@mkdir -p $(PACKER_JSON_DIR) $(PACKER_SH_DIR)
	@echo "Initializing Packer JSON files and scripts."
	@cp $(FILES_DIR)/packer/json/*.json $(PACKER_JSON_DIR)
	@export `cat .drumkit-packer.conf | xargs` && make -s \
		$(PACKER_SH_SCRIPTS) \
		$(PACKER_SH_DIR)/$$CONTAINER_PROJECT_NAME.sh \
		$(PACKER_JSON_DIR)/40-$$CONTAINER_PROJECT_NAME.json
	@make -s clean-drumkit-packer.conf
	@echo "Finished initializing Drumkit Packer project."

$(MK_D)/20-ci.mk: .drumkit-packer.conf
	@echo "Initializing CI makefile."
	@echo jinja2 `perl -n < .drumkit-packer.conf -e 'chomp and print " -D " and print "\"$$_\""'` -o $@ $(FILES_DIR)/packer/20-ci.mk.j2 > .drumkit-packer-init-$(notdir $@)-script.cmd
	@ . .drumkit-packer-init-$(notdir $@)-script.cmd
	@rm .drumkit-packer-init-$(notdir $@)-script.cmd

$(PACKER_JSON_DIR)/40-$(CONTAINER_PROJECT_NAME).json:
	@echo Initializing project-specific Packer JSON file $@
	@cp $(FILES_DIR)/packer/40-project.json $@

$(PACKER_SH_SCRIPTS):
	@cd $(PACKER_SH_DIR) && ln -s $(SCRIPTS_DIR)/packer/scripts/$(notdir $@) .

$(PACKER_SH_DIR)/$(CONTAINER_PROJECT_NAME).sh:
	@echo "Initializing project specific Packer script $@"
	@echo jinja2 `perl -n < .drumkit-packer.conf -e 'chomp and print " -D " and print "\"$$_\""'` -o $@ $(FILES_DIR)/packer/project.sh.j2 > .drumkit-packer-init-$(notdir $@)-script.cmd
	@ . .drumkit-packer-init-$(notdir $@)-script.cmd
	@rm .drumkit-packer-init-$(notdir $@)-script.cmd
