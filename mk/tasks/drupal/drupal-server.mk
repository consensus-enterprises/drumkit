PHP_SERVER_PORT ?= 8888

.PHONY: drupal-start-server-help drupal-start-server drupal-kill-server-help drupal-kill-server

drupal-start-server-help:
	@echo "make drupal-start-server"
	@echo "  Start an embedded PHP server."
drupal-start-server:
	@echo "Starting PHP server."
	@cd $(PLATFORM_ROOT) && php -S 0.0.0.0:$(PHP_SERVER_PORT) &> runserver.log &
	@echo "Giving PHP server a chance to start."
	@sleep 3

drupal-kill-server-help:
	@echo "make drupal-kill-server"
	@echo "  Stop the PHP server."
drupal-kill-server:
	@echo "Stopping any running PHP servers."
	@ps aux|grep "[p]hp -S" > /dev/null; if [ "$?" == 0 ]; then pkill -f "php -S"; fi
	@echo "Giving PHP servers a chance to stop."
	@sleep 3

# vi:syntax=makefile
