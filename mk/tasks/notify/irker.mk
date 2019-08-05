IRKER_MESSAGE ?= test
IRKER_SERVER  ?= irc://chat.freenode.net
IRKER_CHANNEL ?=
IRKER_HOST    ?=
IRKER_PORT    ?= 6659
IRKER_TIMEOUT ?= 1

irker-message:
	@echo -ne '{"to": "$(IRKER_SERVER)/$(IRKER_CHANNEL)", "privmsg": "$(IRKER_MESSAGE)"}\n' | nc $(IRKER_HOST) $(IRKER_PORT) -w $(IRKER_TIMEOUT)
