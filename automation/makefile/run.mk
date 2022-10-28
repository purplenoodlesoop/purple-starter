.PHONY: run emulator install-apk

run:
	@echo "* Running app *"
	@fvm flutter run

emulator:
	@echo "* Opening an Android emulator *"
	@emulator @Pixel_XL_API_30

install-apk:
	@adb install build\app\outputs\flutter-apk\app-release.apk

logs:
	@fvm flutter logs

# Development/Trunk
run-develop:
	@fvm flutter run --flavor development --dart-define=environment=development

# Staging/Stage/Model/Pre-production
run-staging:
	@fvm flutter run --flavor staging --dart-define=environment=staging

# Production/Live
run-production:
	@fvm flutter run --flavor production --dart-define=environment=production
