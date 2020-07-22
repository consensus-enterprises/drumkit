python3_installed = $(shell which python3)
OS_X_MESSAGE = On OS X, manage package dependencies e.g. python/python3 via Homebrew, outside of Drumkit.

deps: apt-update mysql-server

mysql-server: apt-update
ifneq ($(MK_OS),darwin)
	@echo Installing MySQL server
	@echo 'mysql-server mysql-server/root_password password' | sudo debconf-set-selections
	@echo 'mysql-server mysql-server/root_password_again password' | sudo debconf-set-selections
	@sudo DEBIAN_FRONTEND=noninteractive apt-get -y -qq install mysql-server
else
	@echo $@: $(OS_X_MESSAGE)
endif

apt-update:
ifneq ($(MK_OS),darwin)
	@echo Updating apt
	@sudo DEBIAN_FRONTEND=noninteractive apt-get update -qq
else
	@echo $@: $(OS_X_MESSAGE)
endif

python3-update-alternatives:
	  @sudo update-alternatives --install /usr/bin/python python /usr/bin/python3 1

deps-python:
ifndef python3_installed
  ifneq ($(MK_OS),darwin)
	  @make -s apt-update
	  @echo Ensuring python dependencies are installed.
	  @sudo DEBIAN_FRONTEND=noninteractive apt-get install -y -qq python3-minimal python3-pip python3-yaml python3-venv
	  @make -s python3-update-alternatives
  else
	  @echo $@: $(OS_X_MESSAGE)
  endif
endif

.mk/.local/bin/activate: deps-python
	@python3 -m venv `pwd`/.mk/.local
	@mkdir -p drumkit/bootstrap.d
	@cp $(FILES_DIR)/python/*.sh drumkit/bootstrap.d

venv: 
ifndef VIRTUAL_ENV
	@make -s .mk/.local/bin/activate 
	@source `pwd`/.mk/.local/bin/activate
else
	@echo "Python virtual environment already is already bootstrapped."
endif

deps-php: apt-update
ifneq ($(MK_OS),darwin)
	@echo Ensuring PHP dependencies are installed.
	@sudo DEBIAN_FRONTEND=noninteractive apt-get install -y -qq php-cli php-mbstring php-curl php-xml php-gd unzip tree
else
	@echo $@: $(OS_X_MESSAGE)
endif

# vi:syntax=makefile
