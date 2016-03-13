user   = $(shell whoami)
utils  = screen htop strace tree

fix-time:
	@sudo ntpdate -s time.nist.gov

deps-utils:
	@echo Installing some utilities
	@sudo DEBIAN_FRONTEND=noninteractive apt-get -y -qq install $(utils)

# vi:syntax=makefile
