packer_NAME         ?= packer
packer_RELEASE      ?= 1.13.1
packer_DOWNLOAD_URL ?= https://releases.hashicorp.com/$(packer_NAME)/$(packer_RELEASE)/$(packer_NAME)_$(packer_RELEASE)_$(MK_OS)_amd64.zip

packer: install-docker-plugin
install-docker-plugin:
	packer plugins install github.com/hashicorp/docker

# vi:syntax=makefile
