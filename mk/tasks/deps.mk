local_OS          ?= $(shell uname)
ifeq ($(shell whoami),root)
  SUDO=
else
  SUDO=sudo
endif



deps: apt-update mysql-server

mysql-server: apt-update
ifeq ($(local_OS), Linux)
	@echo Installing MySQL server
	@echo 'mysql-server mysql-server/root_password password' | $(SUDO) debconf-set-selections
	@echo 'mysql-server mysql-server/root_password_again password' | $(SUDO) debconf-set-selections
	@$(SUDO) DEBIAN_FRONTEND=noninteractive apt-get -y -qq install mysql-server
endif

apt-update:
ifeq ($(local_OS), Linux)
	@echo Updating apt
	@$(SUDO) DEBIAN_FRONTEND=noninteractive apt-get update -qq
endif

deps-python: apt-update
ifeq ($(local_OS), Linux)
	@echo Ensuring python dependencies are installed.
	@$(SUDO) DEBIAN_FRONTEND=noninteractive apt-get install -y -qq python3-minimal python3-pip python3-yaml python3-jinja2
	@$(SUDO) update-alternatives --install /usr/bin/python python /usr/bin/python3 1
endif

deps-php: apt-update
ifeq ($(local_OS), Linux)	
	@echo Ensuring PHP dependencies are installed.
	@$(SUDO) DEBIAN_FRONTEND=noninteractive apt-get install -y -qq php-cli php-mbstring php-curl php-xml php-gd unzip tree
endif

# vi:syntax=makefile
