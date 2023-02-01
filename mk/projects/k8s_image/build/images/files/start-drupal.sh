# We need the Drupal files directory ownership changed, once the volume is
# mounted. We only need to run `chown` one time, but we cannot do it from the
# Drupal install job, because that container cannot mount the volume. Until we
# have multi-attach volumes (eg. ceph), we will need to intervene in the
# entrypoint here, to make our change, then proceed with the regular startup of
# the container (ie. startig Supervisor).

echo "Making Drupal files directory writeable by 'application' user."
chown application:application -R /var/www/html/web/sites/default/files

echo "Proceeding with Supervisor startup."
/opt/docker/bin/entrypoint.d/supervisord.sh
