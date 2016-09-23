kubectl_NAME         ?= kubectl
kubectl_RELEASE      ?= v1.3.0
kubectl_OS           ?= linux
kubectl_ARCH         ?= amd64
kubectl_DOWNLOAD_URL ?= https://storage.googleapis.com/kubernetes-release/release/$(kubectl_RELEASE)/bin/$(kubectl_OS)/$(kubectl_ARCH)/$(kubectl_NAME)
kubectl_DEPENDENCIES ?= 

# vi:syntax=makefile
