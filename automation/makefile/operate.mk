.PHONY: first-run clean splash prepare icon google-localizations setup format clean version doctor

first-run: prepare run

splash: pub-get
	@echo "* Generating Splash screens *"
	@fvm flutter pub run flutter_native_splash:create

# Prepares the application for the first run.
#
# Fetches latest dependencies, and generates code, icon and splash screen.
prepare: pub-get gen-build-delete icon splash
	@echo "* Prepared the application *"

icon: pub-get
	@echo "* Generating app icons *"
	@fvm flutter pub run flutter_launcher_icons:main -f flutter_launcher_icons.yaml

google-localizations:
	@echo "* Getting dependencies for google localizer *"
	@fvm dart pub get --directory=./tool/google_localizer
	@echo "* Generating automated localizations *"
	@fvm dart ./tool/google_localizer/main.dart "./lib/src/core/l10n/"

format:
	@fvm dart fix --apply .
	@fvm dart format -l 80 --fix .

setup:
	@echo "* Getting dependencies for setup tool *"
	@fvm dart pub get --directory=./tool/setup_clone
	@echo "* Setting up the project *"
	@fvm dart ./tool/setup_clone/main.dart $(NAME)

clean:
	@echo "* Cleaning the project *"
	@grind delete-flutter-artifacts
	@grind clean
	@git clean -d
	@make pub-get

version:
	@fvm flutter --version

doctor:
	@fvm flutter doctor