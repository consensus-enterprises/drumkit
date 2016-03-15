vagrant: Vagrantfile
Vagrantfile:
	@ln -s $(MK_DIR)/Vagrantfile .

up:
	@vagrant up
rebuild:
	@vagrant destroy -f && vagrant up

