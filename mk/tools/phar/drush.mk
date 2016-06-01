drush_NAME         = Drush
drush_OPTIONS      = --include=$(MK_DIR)/.local/drush
drush_RELEASE      = 8.1.2
drush_DOWNLOAD_URL = https://github.com/drush-ops/drush/releases/download/$(drush_RELEASE)/drush.phar
drush_DEPENDENCIES = git php5-mysql php5-cli php5-gd

# vi:syntax=makefile
