SELF_DIR := $(dir $(lastword $(MAKEFILE_LIST)))
include $(SELF_DIR)services/*.mk

.PHONY: services

services: groups hosts ## Ensure all services and applications are installed and configured on all groups and hosts.
