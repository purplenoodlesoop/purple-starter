ifeq ($(OS),Windows_NT)
	include automation/makefile/platform/win.mk
else
    _detected_OS := $(shell uname -s)
    ifeq ($(_detected_OS),Linux)
		include automation/makefile/platform/nix.mk
    else ifeq ($(_detected_OS),Darwin)
		include automation/makefile/platform/mac.mk
    endif
endif