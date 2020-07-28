MK_FILES = $(MK_D)/20_lando.mk $(MK_D)/30_build.mk $(MK_D)/40_install.mk

COMPOSER_BASE_PROJECT         ?= drupal/recommended-project
COMPOSER_BASE_PROJECT_VERSION ?= "^8.8"

# Explicitly export these vars to sub-makes; we use this for values
# initialized by user interaction, below:
export PROJECT_NAME SITE_NAME DB_USER DB_NAME DB_PASS ADMIN_USER ADMIN_PASS

init-project-drupal8-user-vars: $(MK_D) 
	@echo "Please provide the following information so we can create your project:"
	@read -p "Project name (NO SPACES, press enter for 'mydrupalsite'): " project_name && PROJECT_NAME=$${project_name:-mydrupalsite} && \
	read -p "Site name (drupal name, press enter for 'My Drupal Site'): " site_name && SITE_NAME=$${site_name:-My Drupal Site} && \
	read -p "Database user (press enter for 'drupal8'): " db_user && DB_USER=$${db_user:-drupal8} && \
	read -p "Database name (press enter for 'drupal8'): " db_name && DB_NAME=$${db_name:-drupal8} && \
	read -p "Database pass (press enter for 'drupal8'): " db_pass && DB_PASS=$${db_pass:-drupal8} && \
	read -p "Admin username (press enter for 'dev'): " admin_user && ADMIN_USER=$${admin_user:-dev} && \
	read -p "Admin password (press enter for 'pwd'): " admin_pass && ADMIN_PASS=$${admin_pass:-pwd} && \
	make -s .lando.yml && \
	make -s $(MK_D)/10_variables.mk

init-project-drupal8-deps: deps-php behat docker lando
init-project-drupal8: init-project-drupal8-user-vars init-project-drupal8-deps drupal8-drumkit-dir drupal8-composer-codebase ## Initialize a project for developing Drupal 8 with Lando.
	@grep "all:" Makefile > /dev/null || echo "all: start build install" >> Makefile
	@echo "Finished initializing Drupal 8 drumkit."
	@echo "You can spin up your project using the following commands:"
	@echo "  make start"
	@echo "  make build"
	@echo "  make install"
	@groups|grep docker > /dev/null || echo "NOTE: it looks like you are not in the docker group. You probably need to log out and log back in again before proceeding."

drupal8-composer-codebase: composer composer.json .gitignore .env
# N.B. Using `composer.json` as a target here may not work in the long run,
# since there are lots of project types that might want to initialize a
# Composer file. But we'll use it here for expediency.
composer.json:
	@echo "Initializing Drupal 8 Composer project."
	@composer create-project $(COMPOSER_BASE_PROJECT):$(COMPOSER_BASE_PROJECT_VERSION) tmpdir --no-interaction
	@mv tmpdir/composer.* .
	@rm -rf tmpdir

drupal8-drumkit-dir: $(MK_D) $(MK_FILES) $(BOOTSTRAP_D)/40_lando.sh

.env:
	@echo "COMPOSER_CACHE_DIR=tmp/composer-cache/" > .env
$(BOOTSTRAP_D)/40_lando.sh: .env
	@echo "Setting up drumkit directory."
	@echo 'export $$(cat .env | xargs)' > $(BOOTSTRAP_D)/40_lando.sh

.gitignore:
	@echo "Creating .gitignore"
	@cp $(FILES_DIR)/drupal8/dotgitignore .gitignore

.lando.yml: mustache
	@echo "Initializing $@"
	@mustache ENV $(FILES_DIR)/drupal8/lando.yml.tmpl > $@

$(MK_D)/10_variables.mk: mustache
	@echo "Initializing $@"
	@mustache ENV $(FILES_DIR)/drupal8/10_variables.mk.tmpl > $@

$(MK_FILES):
	@echo "Initializing $@"
	@cp $(FILES_DIR)/drupal8/$(notdir $@) $@
