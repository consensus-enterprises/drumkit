IRC_USER    ?= drumkit
IRC_SERVER  ?= irc.freenode.net
IRC_PORT    ?= 6667
IRC_CHANNEL ?= \#drumk.it
IRC_MSG     ?= Testing Drumkit\'s irc-message target

irc-message:
	echo -e "NICK $(IRC_USER)\nUSER $(IRC_USER) 8 * : $(IRC_USER)\nJOIN $(IRC_CHANNEL)\nPRIVMSG $(IRC_CHANNEL) : $(IRC_MSG)\nQUIT\n" | nc $(IRC_SERVER) $(IRC_PORT)
