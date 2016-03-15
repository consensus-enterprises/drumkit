ROOT_DIR     ?= $(CURDIR)
where-am-i    = $(ROOT_DIR)/$(word $(words $(MAKEFILE_LIST)),$(MAKEFILE_LIST))
MK_DIR       := $(shell dirname $(call where-am-i))
FILES_DIR    ?= $(ROOT_DIR)/files
SHELL        := /bin/bash

default: help

check-paths:
	$(info ROOT_DIR: $(ROOT_DIR))
	$(info MK_DIR: $(MK_DIR))
	$(info FILES_DIR: $(FILES_DIR))

make:
	@vagrant ssh -c"cd /var/www/html/d8 && sudo drush -y make /vagrant/dev.build.yml"

include $(MK_DIR)/mk/*/*.mk

