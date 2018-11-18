packer_NAME         ?= packer
packer_RELEASE      ?= 1.1.3
packer_DOWNLOAD_URL ?= https://releases.hashicorp.com/$(packer_NAME)/$(packer_RELEASE)/$(packer_NAME)_$(packer_RELEASE)_$(MK_OS)_amd64.zip

# vi:syntax=makefile
