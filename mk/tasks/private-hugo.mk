# Build a private Hugo site.

ifdef SITE_PASSWORD
  PASSWORD_HASH := $(shell echo -n $$SITE_PASSWORD | sha1sum | awk '{print $$1}')
else
  PASSWORD_HASH :=
endif

ifndef SITE_URL
  SITE_URL := http://www.example.com
endif

private-site:
	@rm -rf .build public
	@hugo --baseURL=$(SITE_URL)/$(PASSWORD_HASH)/ --destination=.build
ifneq ($(PASSWORD_HASH),)
	@mkdir public
	@mv .build public/$(PASSWORD_HASH)
	@cp $(FILES_DIR)/hugo/password.html public/index.html
else
	@mv .build public
endif
