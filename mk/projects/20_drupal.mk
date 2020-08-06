MK_FILES = $(MK_D)/20_lando.mk $(MK_D)/30_build.mk $(MK_D)/40_install.mk $(MK_D)/50_backup.mk $(MK_D)/60_test.mk

COMPOSER_BASE_PROJECT         ?= drupal/recommended-project
COMPOSER_BASE_PROJECT_VERSION ?= "^8.8"

# We export vars into the environment as we collect them from the user so that
# a) we can take advantage of bash's default value syntax, and
# b) we can use them when we do template interpolation at the end:
init-project-drupal-user-vars:
	@echo "Please provide the following information so we can create your project:"
	@read -p "Project name (NO SPACES, press enter for 'mydrupalsite'): " project_name && export PROJECT_NAME=$${project_name:-mydrupalsite} && \
	read -p "Site name (drupal name, press enter for 'My Drupal Site'): " site_name && export SITE_NAME=$${site_name:-My Drupal Site} && \
	read -p "Database user (press enter for 'drupal8'): " db_user && export DB_USER=$${db_user:-drupal8} && \
	read -p "Database name (press enter for 'drupal8'): " db_name && export DB_NAME=$${db_name:-drupal8} && \
	read -p "Database pass (press enter for 'drupal8'): " db_pass && export DB_PASS=$${db_pass:-drupal8} && \
	read -p "Admin username (press enter for 'dev'): " admin_user && export ADMIN_USER=$${admin_user:-dev} && \
	read -p "Admin password (press enter for 'pwd'): " admin_pass && export ADMIN_PASS=$${admin_pass:-pwd} && \
	make -s .lando.yml && \
	make -s $(MK_D)/10_variables.mk

.lando.yml: mustache
	@echo "Initializing lando config file." 
	@mustache ENV $(FILES_DIR)/drupal-project/lando.yml.tmpl > $@

$(MK_D)/10_variables.mk: $(MK_D) mustache
	@echo "Initializing drumkit variables file."
	@mustache ENV $(FILES_DIR)/drupal-project/10_variables.mk.tmpl > $@

init-project-drupal-deps: deps-php behat docker lando
init-project-drupal: init-project-drupal-user-vars init-project-drupal-deps drupal-drumkit-dir drupal-composer-codebase ## Initialize a project for developing Drupal 8 with Lando.
	@grep "all:" Makefile > /dev/null || echo "all: start build install" >> Makefile
	@echo "Finished initializing Drupal drumkit."
	@echo "You can spin up your project using the following commands:"
	@echo "  make start"
	@echo "  make build"
	@echo "  make install"
	@groups|grep docker > /dev/null || echo "NOTE: it looks like you are not in the docker group. You probably need to log out and log back in again before proceeding."

drupal-composer-codebase: composer composer.json .gitignore .env
# N.B. Using `composer.json` as a target here may not work in the long run,
# since there are lots of project types that might want to initialize a
# Composer file. But we'll use it here for expediency.
composer.json:
	@echo "Initializing Drupal Composer project."
	@composer create-project $(COMPOSER_BASE_PROJECT):$(COMPOSER_BASE_PROJECT_VERSION) tmpdir --no-interaction
	@mv tmpdir/composer.* .
	@rm -rf tmpdir

drupal-drumkit-dir: $(MK_D) $(MK_FILES) $(BOOTSTRAP_D)/40_lando.sh
.env:
	@echo "COMPOSER_CACHE_DIR=tmp/composer-cache/" > .env
$(BOOTSTRAP_D)/40_lando.sh: .env
	@echo "Setting up drumkit directory."
	@echo 'export $$(cat .env | xargs)' > $(BOOTSTRAP_D)/40_lando.sh

.gitignore:
	@echo "Creating .gitignore"
	@cp $(FILES_DIR)/drupal-project/dotgitignore .gitignore

$(MK_FILES):
	@echo "Initializing $@"
	@cp $(FILES_DIR)/drupal-project/$(notdir $@) $@
