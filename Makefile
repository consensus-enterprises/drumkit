where-am-i    = $(CURDIR)/$(word $(words $(MAKEFILE_LIST)),$(MAKEFILE_LIST))
MK_DIR       := $(shell dirname $(call where-am-i))
SHELL        := /bin/bash
project_root ?= $(CURDIR)

default: help

check-makefile-paths:
	$(info MK_DIR: $(MK_DIR))
	$(info project_root: $(project_root))

make:
	@vagrant ssh -c"cd /var/www/html/d8 && sudo drush -y make /vagrant/dev.build.yml"

include $(MK_DIR)/mk/*/*.mk

