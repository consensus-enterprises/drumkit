PACKER_JSON_DIR = scripts/packer/json
PACKER_SH_DIR = scripts/packer/scripts
PACKER_SH_SCRIPTS = $(PACKER_SH_DIR)/apt.sh $(PACKER_SH_DIR)/cleanup.sh $(PACKER_SH_DIR)/php.sh $(PACKER_SH_DIR)/purge-extra-packages.sh  $(PACKER_SH_DIR)/python.sh $(PACKER_SH_DIR)/utils.sh
PACKER_PROJECT_JSON := $(PACKER_JSON_DIR)/$(PROJECT_CONTAINER_NAME).json
PACKER_PROJECT_SH := $(PACKER_SH_DIR)/$(PROJECT_CONTAINER_NAME).sh

PROJECT_CONTAINER_NAME ?= $(shell bash -c 'read -p "Docker container project name: " project_container_name; echo $$project_container_name')
PROJECT_CONTAINER_REGISTRY_URL ?= $(shell bash -c 'read -p "Docker container registry URL (eg. registry.gitlab.com/consensus.enterprises/drumkit): " container_registry_url; echo $$container_registry_url')

init-project-packer: init-project-packer-intro ##@projects Initialize a packer project.
	@make -s init-project-packer-vars init-project-packer-static PROJECT_CONTAINER_NAME=$(PROJECT_CONTAINER_NAME) PROJECT_CONTAINER_REGISTRY_URL=$(PROJECT_CONTAINER_REGISTRY_URL)
	@echo "Finished initializing Drumkit Packer project."

init-project-packer-intro:
	@echo "Initializing Drumkit Packer project."
	@echo "Please provide the following information to initialize your Packer scripts:"

init-project-packer-vars:
	@make -s $(MK_D)/20_ci.mk
	@make -s $(PACKER_PROJECT_SH)

init-project-packer-static:
	@mkdir -p $(PACKER_JSON_DIR) $(PACKER_SH_DIR)
	@echo "Initializing Packer JSON files and scripts."
	@cp $(FILES_DIR)/packer/json/*.json $(PACKER_JSON_DIR)
	@make -s $(PACKER_SH_SCRIPTS) $(PACKER_PROJECT_JSON)

$(MK_D)/20_ci.mk: ##@testing Create .gitlab-ci.yml file for new 
	@echo "Initializing CI makefile."
	@mkdir -p $(MK_D)
	@envsubst < $(FILES_DIR)/packer/20_ci.mk.tmpl > $@

$(PACKER_PROJECT_JSON):
	@echo "Initializing project-specific Packer JSON file $@"
	@cp $(FILES_DIR)/packer/40-project.json $@

$(PACKER_SH_SCRIPTS):
	@cd $(PACKER_SH_DIR) && ln -s $(SCRIPTS_DIR)/packer/scripts/$(notdir $@) .

$(PACKER_PROJECT_SH):
	@echo "Initializing project specific Packer script $@"
	@mkdir -p $(@D)
	@envsubst < $(FILES_DIR)/packer/project.sh.tmpl > $@
