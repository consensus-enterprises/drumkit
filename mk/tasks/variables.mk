# Set some variables for use across commands.
TIMESTAMP = $(shell date +%s)
TMP_DIR   = tmp

# Suppress Make-specific output, but allow for greater verbosity.
VERBOSE := 1
QUIET   :=
ifeq ($(VERBOSE), 0)
    MAKE-QUIET = $(MAKE) -s
    QUIET      = > /dev/null
    DRUSH_VERBOSE =
else
    MAKE-QUIET = $(MAKE)
    DRUSH_VERBOSE = --verbose
endif

# Allow debug output
DEBUG := 0
ifeq ($(DEBUG), 0)
    DRUSH_DEBUG =
else
    DRUSH_DEBUG = --debug
endif

# Colour output. See 'help' for example usage.
ECHO       = @echo -e
BOLD       = \033[1m
RESET      = \033[0m
make_color = \033[38;5;$1m  # defined for 1 through 255
GREEN      = $(strip $(call make_color,22))
GREY       = $(strip $(call make_color,241))
RED        = $(strip $(call make_color,124))
WHITE      = $(strip $(call make_color,255))
YELLOW     = $(strip $(call make_color,94))

