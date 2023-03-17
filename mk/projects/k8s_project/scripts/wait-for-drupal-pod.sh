#!/bin/bash

drupal_pod_is_ready () {
  CURRENT_DIR=$(dirname $0)
  DRUPAL_POD_RUNNING=$($CURRENT_DIR/get-running-drupal-pod-id.sh)
  [ "$DRUPAL_POD_RUNNING" != "" ]
}

timeout=120
wait_increment=2

until drupal_pod_is_ready; do
   if (($SECONDS >= $timeout)); then
      echo "Timed out waiting for drupal pod to be ready.";
      exit 1;
   fi
   sleep $wait_increment;
   echo "Waiting for drupal pod to be ready.";
done

