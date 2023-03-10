# Check if a variable is set, and fail if not.
# See http://stackoverflow.com/a/7367903/436063
# and https://gist.github.com/brimston3/fc43658bdb6882ed13d942fa584dd2de
.checkvar-%: .checkvar ## .checkvar-VARIABLENAME fails unless VARIABLENAME is set.
	@if [ "${${*}}" = "" ]; then \
        echo "Variable $* not set"; \
        exit 1; \
    fi

.PHONY: .checkvar
.checkvar:
