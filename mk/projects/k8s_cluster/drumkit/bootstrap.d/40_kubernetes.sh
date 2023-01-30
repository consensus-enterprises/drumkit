#!/usr/bin/env bash

CWD=`pwd`
KUBECONFIG="$CWD/.kube/config"
export KUBECONFIG

alias kc=kubectl
