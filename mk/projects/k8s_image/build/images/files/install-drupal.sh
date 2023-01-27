#!/bin/bash

mariadb_is_up () {
  echo "SELECT current_user" | mariadb --host=$DB_HOST --user=$DB_USER --password=$DB_PASSWORD $DB_NAME
  return $?
}

cd /var/www/html

echo "Waiting for database to be available."
until mariadb_is_up; do
   echo "Still waiting for database to be available.";
   sleep 2;
done

echo "Making Drupal files directory writeable by Nginx user."
chown application:application -R /var/www/html/web/sites/default/files

echo "Installing Drupal site."
./bin/drush site:install $INSTALL_PROFILE \
    --site-name="$SITE_NAME" \
    --yes --locale="en" \
    --db-url="mysql://$DB_USER:$DB_PASSWORD@$DB_HOST/$DB_NAME" \
    --account-name="$ADMIN_USER" \
    --account-mail="$ADMIN_EMAIL" \
    --account-pass="$ADMIN_PASSWORD"
