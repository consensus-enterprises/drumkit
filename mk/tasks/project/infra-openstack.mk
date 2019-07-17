# Tasks for initializing infra-openstack projects.
init-infra-openstack:
	@echo "Initializing Drumkit Openstack Infrastructure project."
	@git submodule add git@gitlab.com:consensus.enterprises/ansible-roles/ansible-role-cloud-openstack roles/consensus.cloud-openstack
	@echo "include roles/consensus.cloud-openstack/Makefile" >> $(PROJECT_ROOT)/Makefile
	@make init-cloud-openstack

# TODO: turn on/off relevant makefiles by adding symlinks inside a new makefiles.d
