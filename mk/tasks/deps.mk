deps: apt-update mysql-server

mysql-server: apt-update
	@echo Installing MySQL server
	@echo 'mysql-server mysql-server/root_password password' | sudo debconf-set-selections
	@echo 'mysql-server mysql-server/root_password_again password' | sudo debconf-set-selections
	@sudo DEBIAN_FRONTEND=noninteractive apt-get -y -qq install mysql-server

apt-update:
	@echo Updating apt
	@sudo DEBIAN_FRONTEND=noninteractive apt-get update -qq

# vi:syntax=makefile
