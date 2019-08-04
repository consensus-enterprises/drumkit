# Tasks for initializing infra-openstack projects.

init-project-openstack-intro:
	@echo "Initializing Drumkit OpenStack infrastructure project."
init-project-openstack: init-project-openstack-intro init-project-ansible roles/consensus.cloud-openstack $(MK_D)/20_project_openstack.mk ## Initialize a project for provisioning cloud infrastructure on an OpenStack provider.
	@make -s init-role-cloud-openstack
	@echo "Finished initializing Drumkit OpenStack infrastructure project."

$(MK_D)/20_project_openstack.mk: $(MK_D) 
	@echo 'include roles/consensus.cloud-openstack/drumkit/mk.d/*.mk' > $@

roles/consensus.cloud-openstack:
	@git submodule add $(CONSENSUS_GIT_URL_BASE)/ansible-roles/ansible-role-cloud-openstack $@
