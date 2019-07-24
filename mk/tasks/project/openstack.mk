# Tasks for initializing infra-openstack projects.

CONSENSUS_GIT_URL_BASE := https://gitlab.com/consensus.enterprises
ROLE_NAME = consensus.cloud-openstack

init-project-openstack-intro:
	@echo "Initializing Drumkit Openstack Infrastructure project."
init-project-openstack: init-project-openstack-intro $(MK_D) roles/$(ROLE_NAME) $(MK_D)/$(ROLE_NAME).mk
	@make -s init-cloud-openstack
	@echo "Initialized Drumkit Openstack Infrastructure project."

$(MK_D)/$(ROLE_NAME).mk:
	@echo 'include roles/$(ROLE_NAME)/drumkit/mk.d/*.mk' > $@

roles/$(ROLE_NAME):
	@git submodule add $(CONSENSUS_GIT_URL_BASE)/ansible-roles/ansible-role-cloud-openstack roles/$(ROLE_NAME)
