.PHONY: help-vagrant vagrant up rebuild

help-vagrant:
	@echo "make vagrant"
	@echo "  Add a Vagrantfile."
	@echo "make up"
	@echo "  Launch Vagrant."
	@echo "make rebuild"
	@echo "  Destroy the current Vagrant VM and re-provision a new one."

vagrant: Vagrantfile

Vagrantfile:
	@ln -s $(MK_DIR)/Vagrantfile .

vagrant-up: vagrant
	@vagrant up --provision

vagrant-rebuild: vagrant
	@vagrant destroy -f && vagrant up

