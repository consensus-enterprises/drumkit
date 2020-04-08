terraform_NAME					?= terraform
terraform_RELEASE				?= 0.12.21
terraform_FILENAME			?= $(terraform_NAME)_$(terraform_RELEASE)_linux_amd64.zip
terraform_DOWNLOAD_URL	?= https://releases.hashicorp.com/terraform/$(terraform_RELEASE)/$(terraform_FILENAME)

# vi:syntax=makefile
