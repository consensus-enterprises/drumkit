minikube_NAME         ?= minikube
minikube_RELEASE      ?= v0.10.0
minikube_OS           ?= linux
minikube_ARCH         ?= amd64
minikube_DOWNLOAD_URL ?= https://storage.googleapis.com/$(minikube_NAME)/releases/$(minikube_RELEASE)/$(minikube_NAME)-$(minikube_OS)-$(minikube_ARCH)
minikube_DEPENDENCIES ?= virtualbox

minikube: kubectl
# vi:syntax=makefile
