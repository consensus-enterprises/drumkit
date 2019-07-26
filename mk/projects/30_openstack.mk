# Tasks for initializing infra-openstack projects.

init-project-openstack-intro:
	@echo "Initializing Drumkit Openstack Infrastructure project."
init-project-openstack: init-project-openstack-intro init-project-ansible roles/consensus.cloud-openstack $(MK_D)/20_project_openstack.mk
	@make -s init-role-cloud-openstack
	@echo "Initialized Drumkit Openstack Infrastructure project."

$(MK_D)/20_project_openstack.mk: $(MK_D) 
	@echo 'include roles/consensus.cloud-openstack/drumkit/mk.d/*.mk' > $@

roles/consensus.cloud-openstack:
	@git submodule add $(CONSENSUS_GIT_URL_BASE)/ansible-roles/ansible-role-cloud-openstack $@
