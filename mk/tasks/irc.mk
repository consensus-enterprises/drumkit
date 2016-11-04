IRC_USER    ?= drumkit
IRC_SERVER  ?= irc.freenode.net
IRC_PORT    ?= 6667
IRC_CHANNEL ?= \#drumk.it
IRC_COMMIT  ?= "Commit: $$(git log -1 --oneline --no-decorate)"
IRC_STATUS  ?= "succeeded"
IRC_PROJECT ?= "drumkit"
IRC_GIT_URL ?= "https://gitlab.com/$(IRC_PROJECT)/$$(basename $$(pwd))"
IRC_REF_URL ?= "$(IRC_GIT_URL)/commit/$$(git rev-parse --short HEAD)/builds"
IRC_MSG     ?= "\\e[32mBuild on \\e[33m$$(git rev-parse --abbrev-ref HEAD)\\e[32m $(IRC_STATUS).\\e[0m See $(IRC_REF_URL)"

irc-message:
	echo -e "NICK $(IRC_USER)\nUSER $(IRC_USER) 8 * : $(IRC_USER)\nJOIN $(IRC_CHANNEL)\nPRIVMSG $(IRC_CHANNEL) : $(IRC_MSG)\nPRIVMSG $(IRC_CHANNEL) : $(IRC_COMMIT)\nQUIT\n" | nc $(IRC_SERVER) $(IRC_PORT)
