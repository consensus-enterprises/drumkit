MK_FILES = $(MK_D)/20_ddev.mk $(MK_D)/30_build.mk $(MK_D)/40_install.mk $(MK_D)/50_backup.mk $(MK_D)/60_test.mk

COMPOSER_BASE_PROJECT         ?= drupal/recommended-project
COMPOSER_BASE_PROJECT_VERSION ?= "10.5.1"

# We expect the 2 variables PROJECT_NAME and SITE_NAME to be passed in.
init-project-drupal-user-vars: .checkvar-PROJECT_NAME
init-project-drupal-user-vars: .checkvar-SITE_NAME
init-project-drupal-user-vars: mustache
	make -s .ddev/config.yaml && \
	make -s $(MK_D)/10_variables.mk

.ddev/config.yaml:
	$(ECHO) "Initializing DDEV config file."
	ddev config --project-type=drupal10 --project-name=$(PROJECT_NAME) --docroot=web --create-docroot

$(MK_D)/10_variables.mk:
	@echo "Initializing drumkit variables file."
	@mkdir -p $(MK_D)
	@mustache ENV $(FILES_DIR)/drupal-project/10_variables.mk.tmpl > $@

init-project-drupal-deps: docker ddev
	ddev start

# Call as: make init-project-drupal PROJECT_NAME=foo SITE_NAME="foo bar"
init-project-drupal: init-project-drupal-user-vars init-project-drupal-deps drupal-drumkit-dir drupal-composer-codebase ##@projects@drupal Initialize a project for developing Drupal 8 with DDEV.
	@grep "all:" Makefile > /dev/null || echo "all: start build install" >> Makefile
	@groups|grep docker > /dev/null || echo "NOTE: it looks like you are not in the docker group. You probably need to log out and log back in again before proceeding."
	$(ECHO) "Finished initializing Drupal drumkit."
	$(ECHO) "You can spin up your project using the following commands:"
	$(ECHO) "  make start"
	$(ECHO) "  make build"
	$(ECHO) "  make install"

drupal-docs: ##@drupal Get link to online documentation
	@echo "For detailed documentation on using DDEV Drupal projects with Drumkit, see https://drumk.it/usage/drupal/"

drupal-composer-codebase: composer.json .gitignore .env
# N.B. Using `composer.json` as a target here may not work in the long run,
# since there are lots of project types that might want to initialize a
# Composer file. But we'll use it here for expediency.
composer.json:
	@echo "Initializing Drupal Composer project."
	# Calling exec composer here allows us to initiate the composer.json in a subdirectory (which DDEV disallows)
	ddev exec composer create-project $(COMPOSER_BASE_PROJECT):$(COMPOSER_BASE_PROJECT_VERSION) tmpdir --no-interaction
	@mv tmpdir/composer.* .
	@rm -rf tmpdir
	# We presume to install a site-local drush, because it's used to do a `make install`
	ddev composer require drush/drush

drupal-drumkit-dir: $(MK_D) $(MK_FILES) $(BOOTSTRAP_D)/50_ddev.sh

.env: tmp/composer-cache
	@echo "COMPOSER_CACHE_DIR=tmp/composer-cache/" > .env

$(BOOTSTRAP_D)/50_ddev.sh: .env
	@echo "Setting up drumkit directory."
	@echo 'export $$(cat .env | xargs)' > $(BOOTSTRAP_D)/50_ddev.sh

.gitignore:
	@echo "Creating .gitignore"
	@cp $(FILES_DIR)/drupal-project/dotgitignore .gitignore

$(MK_FILES):
	@echo "Initializing $@"
	@cp $(FILES_DIR)/drupal-project/$(notdir $@) $@

tmp/composer-cache:
	@mkdir -p tmp/composer-cache
