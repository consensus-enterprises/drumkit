ifeq ($(user),'root')
  SUDO=
else
  SUDO='$(SUDO)'
endif

deps: apt-update mysql-server

mysql-server: apt-update
	@echo Installing MySQL server
	@echo 'mysql-server mysql-server/root_password password' | $(SUDO) debconf-set-selections
	@echo 'mysql-server mysql-server/root_password_again password' | $(SUDO) debconf-set-selections
	@$(SUDO) DEBIAN_FRONTEND=noninteractive apt-get -y -qq install mysql-server

apt-update:
	@echo Updating apt
	@$(SUDO) DEBIAN_FRONTEND=noninteractive apt-get update -qq

deps-python: apt-update
	@echo Ensuring python dependencies are installed.
	@$(SUDO) DEBIAN_FRONTEND=noninteractive apt-get install -y -qq python3-minimal python3-pip python3-yaml
	@$(SUDO) update-alternatives --install /usr/bin/python python /usr/bin/python3 1

deps-php: apt-update
	@echo Ensuring PHP dependencies are installed.
	@$(SUDO) DEBIAN_FRONTEND=noninteractive apt-get install -y -qq php-cli php-mbstring php-curl php-xml php-gd unzip tree

# vi:syntax=makefile
