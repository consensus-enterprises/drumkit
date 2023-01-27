kubectl_NAME         ?= kubectl
kubectl_RELEASE      ?= v1.21.1
kubectl_DOWNLOAD_URL ?= https://storage.googleapis.com/kubernetes-release/release/$(kubectl_RELEASE)/bin/$(MK_OS)/amd64/$(kubectl_NAME)
kubectl_DEPENDENCIES ?= 

# vi:syntax=makefile
