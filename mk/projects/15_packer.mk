PACKER_JSON_DIR = scripts/packer/json
PACKER_SH_DIR = scripts/packer/scripts
PACKER_SH_SCRIPTS = $(PACKER_SH_DIR)/apt.sh $(PACKER_SH_DIR)/cleanup.sh $(PACKER_SH_DIR)/php.sh $(PACKER_SH_DIR)/purge-extra-packages.sh  $(PACKER_SH_DIR)/python.sh $(PACKER_SH_DIR)/utils.sh

init-project-packer-intro:
	@echo "Initializing Drumkit Packer project."

init-project-packer-vars:
	@echo "Please provide the following information to initialize your Packer scripts:"
	@read -p "Docker container project name: " project && export CONTAINER_PROJECT_NAME=$${project:-project} && \
	read -p "Docker container registry URL: " registry_url && export CONTAINER_REGISTRY_URL=$${registry_url:-registry.gitlab.com} && \
	make -s $(MK_D)/20_ci.mk && \
	make -s $(PACKER_SH_DIR)/$(CONTAINER_PROJECT_NAME).sh

init-project-packer-static:
	@mkdir -p $(PACKER_JSON_DIR) $(PACKER_SH_DIR)
	@echo "Initializing Packer JSON files and scripts."
	@cp $(FILES_DIR)/packer/json/*.json $(PACKER_JSON_DIR)
	@make -s $(PACKER_SH_SCRIPTS) $(PACKER_JSON_DIR)/40-$$CONTAINER_PROJECT_NAME.json

init-project-packer: init-project-packer-intro init-project-packer-static ##@projects Initialize a packer project.
	@make -s init-project-packer-vars 
	@echo "Finished initializing Drumkit Packer project."

$(MK_D)/20_ci.mk: ##@testing Create .gitlab-ci.yml file for new 
	@echo "Initializing CI makefile."
	@mkdir -p $(MK_D)
	@envsubst < $(FILES_DIR)/packer/20_ci.mk.tmpl > $@

$(PACKER_JSON_DIR)/40-$(CONTAINER_PROJECT_NAME).json:
	@echo "Initializing project-specific Packer JSON file $@"
	@cp $(FILES_DIR)/packer/40-project.json $@

$(PACKER_SH_SCRIPTS):
	@cd $(PACKER_SH_DIR) && ln -s $(SCRIPTS_DIR)/packer/scripts/$(notdir $@) .

$(PACKER_SH_DIR)/$(CONTAINER_PROJECT_NAME).sh:
	@echo "Initializing project specific Packer script $@"
	@envsubst < $(FILES_DIR)/packer/project.sh.tmpl > $@
