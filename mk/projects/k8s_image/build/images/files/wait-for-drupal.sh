#!/bin/bash

drupal_is_ready () {
  drush status
  return $?
}

cd /var/www/html

timeout=120
wait_increment=2

echo "Waiting for drupal to be ready."
until drupal_is_ready; do
   if [[ $SECONDS >= $timeout ]]; then
      echo "Timed out waiting for drupal to be ready.";
      exit 1;
   fi
   sleep $wait_increment;
   echo "Still waiting for drupal to be ready.";
done

