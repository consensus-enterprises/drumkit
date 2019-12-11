deps: apt-update mysql-server

mysql-server: apt-update
	@echo Installing MySQL server
	@echo 'mysql-server mysql-server/root_password password' | sudo debconf-set-selections
	@echo 'mysql-server mysql-server/root_password_again password' | sudo debconf-set-selections
	@sudo DEBIAN_FRONTEND=noninteractive apt-get -y -qq install mysql-server

apt-update:
	@echo Updating apt
	@sudo DEBIAN_FRONTEND=noninteractive apt-get update -qq

install-python-deps: apt-update
	@echo Installing python dependencies so that Drumkit can use ansible and jinja2.
	@sudo DEBIAN_FRONTEND=noninteractive apt install python3-minimal python3-pip python3-yaml python3-jinja2
	@sudo update-alternatives --install /usr/bin/python python /usr/bin/python3 1
	@pip3 install jinja2-cli

install-php-deps: apt-update
	@echo Installing PHP dependencies.
	@sudo apt install make php-cli php-mbstring php-curl php-xml php-gd unzip tree

# vi:syntax=makefile
