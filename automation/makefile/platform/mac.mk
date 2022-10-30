.PHONY: install-pods simulator ios-deep-clean

CFLAGS += -D osx

_echo_os:
	@echo "Running Makefile on macOS"

install-pods:
	@echo "* Installing pods *"
	@pod install --project-directory=./ios

simulator:
	@echo "* Opening an iOS simulator *"
	@open -a Simulator

ios-deep-clean:
	@echo "* Performing a deep clean for iOS *"
	@grind clean-ios
	@make pub-get
	@make install-pods
