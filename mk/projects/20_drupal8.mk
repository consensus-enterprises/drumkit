MK_FILES = 20_lando.mk 30_build.mk 40_install.mk

init-project-drupal8-intro:
	@echo "Initializing Drumkit Drupal 8 project."
	@[ -d web ] && read -p "It looks like you already have a Drupal project here. If you continue, some or all of it may be overwritten, and/or the project initialization process may only partially work, leaving your project in an inconsistent state. Press 'Enter' to continue anyway or Ctrl-C to abort:" dummy_variable || true

drumkit-drupal8.conf:
	@echo "Please provide the following information so we can create your project:"
	@read -p "Project name (NO SPACES, press enter for 'mydrupalsite'): " project_name && echo "PROJECT_NAME=$${project_name:-mydrupalsite}" >> drumkit-drupal8.conf
	@read -p "Site name (drupal name, press enter for 'My Drupal Site'): " site_name && echo "SITE_NAME=$${site_name:-My Drupal Site}" >> drumkit-drupal8.conf
	@read -p "Database user (press enter for 'drupal8'): " db_user && echo "DB_USER=$${db_user:-drupal8}" >> drumkit-drupal8.conf
	@read -p "Database name (press enter for 'drupal8'): " db_name && echo "DB_NAME=$${db_name:-drupal8}" >> drumkit-drupal8.conf
	@read -p "Database pass (press enter for 'drupal8'): " db_pass && echo "DB_PASS=$${db_pass:-drupal8}" >> drumkit-drupal8.conf
	@read -p "Admin username (press enter for 'dev'): " admin_user && echo "ADMIN_USER=$${admin_user:-dev}" >> drumkit-drupal8.conf
	@read -p "Admin password (press enter for 'pwd'): " admin_pass && echo "ADMIN_PASS=$${admin_pass:-pwd}" >> drumkit-drupal8.conf

clean-drumkit-drupal8.conf:
	@rm drumkit-drupal8.conf

init-project-drupal8: drumkit-drupal8.conf init-project-drupal8-intro install-python-deps install-php-deps behat docker lando init-composer-drupal8-project init-drupal8-drumkit-dir
	@echo "Finished initializing Drupal 8 drumkit."
	@echo "You can now spin up your project using the following commands:"
	@echo "  make start"
	@echo "  make build"
	@echo "  make install"
	@groups|grep docker > /dev/null || echo "NOTE: it looks like you are not in the docker group. You probably need to log out and log back in again before proceeding."

init-composer-drupal8-project:
	@echo "Creating Composer project from drupal-project template."
	@which composer > /dev/null || . d  && composer create-project drupal-composer/drupal-project:8.x-dev tmpdir --stability dev --no-interaction # we have to bootstrap drumkit if it hasn't been done yet, to get composer in our path
	@shopt -s dotglob && mv tmpdir/* .
	@rmdir tmpdir

init-drupal8-drumkit-dir: $(MK_D)/10_variables.mk $(MK_FILES) .lando.yml
	@echo "Setting up drumkit directory."
	@echo "COMPOSER_CACHE_DIR=tmp/composer-cache/" >> .env
	@echo 'export $$(cat .env | xargs)' > $(BOOTSTRAP_D)/40_lando.sh

.lando.yml:
	@echo "Initializing .lando.yml"
	@echo jinja2 `perl -n < drumkit-drupal8.conf -e 'chomp and print " -D " and print "\"$$_\""'` -o $@ $(FILES_DIR)/drupal8/lando.yml.j2  > .drumkit-drupal8-init-lando.cmd
	@ . .drumkit-drupal8-init-lando.cmd
	@rm .drumkit-drupal8-init-lando.cmd

$(MK_D)/10_variables.mk: $(MK_D)
	@echo "Initializing $@"
	@echo jinja2 `perl -n < drumkit-drupal8.conf -e 'chomp and print " -D " and print "\"$$_\""'` -o $@ $(FILES_DIR)/drupal8/10_variables.mk.j2  > .drumkit-drupal8-init-variables.cmd
	@ . .drumkit-drupal8-init-variables.cmd
	@rm .drumkit-drupal8-init-variables.cmd

$(MK_FILES):
	@echo "Initializing $@"
	@cp $(FILES_DIR)/drupal8/$@ $(MK_D)/
