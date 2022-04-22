.PHONY: help version doctor

flutter = (fvm flutter || flutter)

# Script description and usage through `make` or `make help` commands
help:
	@echo "Make something good"
	@echo " or something worse"
	@echo "  or something else"
	@echo "   with this script"

-include automation/makefile/*.mk

version:
	@flutter --version

doctor:
	@flutter doctor