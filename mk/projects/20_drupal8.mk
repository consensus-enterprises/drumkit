MK_FILES = $(MK_D)/20_lando.mk $(MK_D)/30_build.mk $(MK_D)/40_install.mk

COMPOSER_BASE_PROJECT         ?= drupal/recommended-project
COMPOSER_BASE_PROJECT_VERSION ?= "^8.8"

drumkit-drupal8.conf.yml:
	@echo "Please provide the following information so we can create your project:"
	@echo "---" >> drumkit-drupal8.conf.yml
	@read -p "Project name (NO SPACES, press enter for 'mydrupalsite'): " project_name && echo "PROJECT_NAME=$${project_name:-mydrupalsite}" >> drumkit-drupal8.conf.yml
	@read -p "Site name (drupal name, press enter for 'My Drupal Site'): " site_name && echo "SITE_NAME=$${site_name:-My Drupal Site}" >> drumkit-drupal8.conf.yml
	@read -p "Database user (press enter for 'drupal8'): " db_user && echo "DB_USER=$${db_user:-drupal8}" >> drumkit-drupal8.conf.yml
	@read -p "Database name (press enter for 'drupal8'): " db_name && echo "DB_NAME=$${db_name:-drupal8}" >> drumkit-drupal8.conf.yml
	@read -p "Database pass (press enter for 'drupal8'): " db_pass && echo "DB_PASS=$${db_pass:-drupal8}" >> drumkit-drupal8.conf.yml
	@read -p "Admin username (press enter for 'dev'): " admin_user && echo "ADMIN_USER=$${admin_user:-dev}" >> drumkit-drupal8.conf.yml
	@read -p "Admin password (press enter for 'pwd'): " admin_pass && echo "ADMIN_PASS=$${admin_pass:-pwd}" >> drumkit-drupal8.conf.yml

clean-drumkit-drupal8.conf.yml:
	@rm drumkit-drupal8.conf.yml
init-project-drupal8-deps: deps-php mustache behat docker lando
init-project-drupal8: drumkit-drupal8.conf.yml drupal8-composer-codebase drupal8-drumkit-dir ## Initialize a project for developing Drupal 8 with Lando.
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

drupal8-drumkit-dir: $(MK_D) $(MK_D)/10_variables.mk $(MK_FILES) .lando.yml $(BOOTSTRAP_D)/40_lando.sh
.env:
	@echo "COMPOSER_CACHE_DIR=tmp/composer-cache/" > .env
$(BOOTSTRAP_D)/40_lando.sh: .env
	@echo "Setting up drumkit directory."
	@echo 'export $$(cat .env | xargs)' > $(BOOTSTRAP_D)/40_lando.sh

.gitignore:
	@echo "Creating .gitignore"
	@cp $(FILES_DIR)/drupal8/dotgitignore .gitignore

.lando.yml:
	@echo "Initializing .lando.yml"
	@mustache drumkit-drupal8.conf.yml $(FILES_DIR)/drupal8/lando.yml.mustache  > $@

$(MK_D)/10_variables.mk:
	@echo "Initializing $@"
	@mustache drumkit-drupal8.conf.yml $(FILES_DIR)/drupal8/10_variables.mk.mustache  > $@

$(MK_FILES):
	@echo "Initializing $@"
	@cp $(FILES_DIR)/drupal8/$(notdir $@) $@
