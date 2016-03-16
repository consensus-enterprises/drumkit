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

up:
	@vagrant up

rebuild:
	@vagrant destroy -f && vagrant up

