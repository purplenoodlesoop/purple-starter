ifeq ($(OS),Windows_NT)
	include makefiles/platform/win.mk
else
    _detected_OS := $(shell uname -s)
    ifeq ($(_detected_OS),Linux)
		include makefiles/platform/nix.mk
    else ifeq ($(_detected_OS),Darwin)
		include makefiles/platform/mac.mk
    endif
endif