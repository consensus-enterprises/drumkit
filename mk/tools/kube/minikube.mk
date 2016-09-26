minikube_NAME         ?= minikube
minikube_RELEASE      ?= v0.10.0
minikube_DOWNLOAD_URL ?= https://storage.googleapis.com/$(minikube_NAME)/releases/$(minikube_RELEASE)/$(minikube_NAME)-$(MK_OS)-amd64
minikube_DEPENDENCIES ?= virtualbox

minikube: kubectl
# vi:syntax=makefile
