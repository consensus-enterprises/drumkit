#!/bin/bash

kubectl get pods --selector "component=drupal" | grep drupal-deployment | grep Running | cut -d' ' -f 1
