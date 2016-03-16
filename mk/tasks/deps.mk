deps_hooks = $(shell grep "^deps-[^:]*" $(MK_DIR)/mk -rho)

deps: apt-update mysql-server $(deps_hooks)

list-deps:
	@echo The following 'dependency' hooks are defined:
	@echo '   '$(deps_hooks)

mysql-server: apt-update
	@echo Installing MySQL server
	@echo 'mysql-server mysql-server/root_password password' | sudo debconf-set-selections
	@echo 'mysql-server mysql-server/root_password_again password' | sudo debconf-set-selections
	@sudo DEBIAN_FRONTEND=noninteractive apt-get -y -qq install mysql-server

apt-update:
	@echo Updating apt
	@sudo DEBIAN_FRONTEND=noninteractive apt-get update -qq

# vi:syntax=makefile
