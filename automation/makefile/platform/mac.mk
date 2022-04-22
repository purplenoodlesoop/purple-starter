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

# Runes code generation in background
codegen-bg:
	@nohup time /bin/bash -c ' \
		flutter pub get \
		&& flutter pub run build_runner build --delete-conflicting-outputs \
		&& say "Code generation completed" || say "Code generation failed!" ' >/dev/null 2>&1 &
