IRC_USER    ?= drumkit
IRC_SERVER  ?= irc.freenode.net
IRC_PORT    ?= 6667
IRC_CHANNEL ?= \#drumk.it
IRC_COMMIT  ?= Commit: $$(git log -1 --oneline --no-decorate)
IRC_PROJECT ?= drumkit
IRC_GIT_URL ?= https://gitlab.com/$(IRC_PROJECT)/$$(basename $$(pwd))
IRC_REF_URL ?= $(IRC_GIT_URL)/commit/$$(git rev-parse --short HEAD)/builds
IRC_BRANCH  ?= master
IRC_MSG     ?= Test message from Drumkit.
IRC_SUCCESS ?= \\e[32mSuccess building \\e[33m$(IRC_BRANCH)\\e[32m branch.\\e[0m See $(IRC_REF_URL)
IRC_FAILURE ?= \\e[31mFailure building \\e[33m$(IRC_BRANCH)\\e[31m branch.\\e[0m See: $(IRC_REF_URL)

irc-message:
	echo -e "NICK $(IRC_USER)\nUSER $(IRC_USER) 8 * : $(IRC_USER)\nJOIN $(IRC_CHANNEL)\nPRIVMSG $(IRC_CHANNEL) : $(IRC_MSG)\nQUIT\n" | nc $(IRC_SERVER) $(IRC_PORT)

irc-ci-success:
	echo -e "NICK $(IRC_USER)\nUSER $(IRC_USER) 8 * : $(IRC_USER)\nJOIN $(IRC_CHANNEL)\nPRIVMSG $(IRC_CHANNEL) : $(IRC_SUCCESS)\nPRIVMSG $(IRC_CHANNEL) : $(IRC_COMMIT)\nQUIT\n" | nc $(IRC_SERVER) $(IRC_PORT)

irc-ci-failure:
	echo -e "NICK $(IRC_USER)\nUSER $(IRC_USER) 8 * : $(IRC_USER)\nJOIN $(IRC_CHANNEL)\nPRIVMSG $(IRC_CHANNEL) : $(IRC_FAILURE)\nPRIVMSG $(IRC_CHANNEL) : $(IRC_COMMIT)\nQUIT\n" | nc $(IRC_SERVER) $(IRC_PORT)
