# Tasks for initializing infra-openstack projects.

init-project-openstack-intro:
	@echo "Initializing Drumkit Openstack Infrastructure project."
init-project-openstack: init-project-openstack-intro $(MK_D) roles/consensus.cloud-openstack $(MK_D)/consensus.cloud-openstack.mk
	@make -s init-cloud-openstack
	@echo "Initialized Drumkit Openstack Infrastructure project."

$(MK_D)/consensus.cloud-openstack.mk:
	@echo 'include roles/consensus.cloud-openstack/drumkit/mk.d/*.mk' > $@

roles/consensus.cloud-openstack:
	@git submodule add $(CONSENSUS_GIT_URL_BASE)/ansible-roles/ansible-role-cloud-openstack roles/consensus.cloud-openstack