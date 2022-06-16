.PHONY: first-run clean splash prepare icon google-localizations setup format

first-run: prepare run

splash: pub-get
	@echo "* Generating Splash screens *"
	@flutter pub run flutter_native_splash:create

prepare: pub-get gen-build-delete icon splash

icon: pub-get
	@echo "* Generating app icons *"
	@flutter pub run flutter_launcher_icons:main -f flutter_launcher_icons.yaml

google-localizations:
	@echo "* Getting dependencies for google localizer *"
	@fvm dart pub get --directory=./tool/google_localizer
	@echo "* Generating automated localizations *"
	@fvm dart ./tool/google_localizer/main.dart "./lib/src/core/l10n/"

format:
	@dart fix --apply .
	@dart format -l 80 --fix .

setup:
	@echo "* Getting dependencies for setup tool *"
	fvm dart pub get --directory=./tool/setup_clone
	@echo "* Setting up the project *"
	@fvm dart ./tool/setup_clone/main.dart $(NAME)
