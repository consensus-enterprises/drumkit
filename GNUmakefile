# Find the path to the originally called Makefile.
orig-mk       = $(CURDIR)/$(word $(words $(MAKEFILE_LIST)),$(MAKEFILE_LIST))
# Set the absolute path to the directory in which `make` was called.
MK_DIR       := $(shell dirname $(call orig-mk))
PROJECT_ROOT ?= $(CURDIR)
FILES_DIR    ?= $(MK_DIR)/files
SHELL        := /bin/bash

default: help

include $(MK_DIR)/lib/gmsl/gmsl
include $(MK_DIR)/mk/tools.mk
include $(MK_DIR)/mk/projects/*.mk
include $(MK_DIR)/mk/tasks/*.mk

ifeq ($(MK_D_EXISTS), 1)
  ifeq ($(MK_D_NONEMPTY), 1)
    include $(MK_D)/*.mk
  endif
endif

