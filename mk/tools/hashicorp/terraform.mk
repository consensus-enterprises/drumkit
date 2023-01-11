# We are assuming that all Mac users are on ARM and all Linux users are on AMD64.
# Override terraform_ARCH if not.
ifeq ($(local_OS),Darwin)
    terraform_ARCH ?= arm64
else
    terraform_ARCH ?= amd64
endif

terraform_NAME          ?= terraform
terraform_RELEASE       ?= 1.3.7
terraform_FILENAME      ?= $(terraform_NAME)_$(terraform_RELEASE)_$(call lc,$(local_OS))_$(terraform_ARCH).zip
terraform_DOWNLOAD_URL  ?= https://releases.hashicorp.com/terraform/$(terraform_RELEASE)/$(terraform_FILENAME)

# vi:syntax=makefile
