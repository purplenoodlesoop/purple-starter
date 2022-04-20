.PHONY: run emulator

run:
	@echo "* Running app *"
	@fvm flutter run

emulator:
	@echo "* Opening an android emulator *"
	@emulator @Pixel_XL_API_30