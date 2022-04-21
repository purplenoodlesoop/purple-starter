.PHONY: help

# Описание скрипта по `make` или `make help`
help:
	@echo "Make something good"
	@echo " or something worse"
	@echo "  or something else"
	@echo "   with this script"

-include makefiles/*.mk

version:
	@flutter --version

doctor:
	@flutter doctor