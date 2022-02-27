.PHONY: get install-pods run upgrade upgrade-major deep-clean gen-build gen-build-delete gen-clean gen-watch create-splash prepare first-run set-icon google-localizations setup emulator simulator stats


get:
	@echo "* Getting latest dependencies *"
	@fvm flutter pub get

install-pods:
	@echo "* Installing pods *"
	@(cd ./ios; pod install)

run:
	@echo "* Running app *"
	@fvm flutter run

upgrade: get
	@echo "* Upgrading dependencies *"
	@fvm flutter pub upgrade

upgrade-major: get
	@echo "* Upgrading dependencies --major-versions *"
	@fvm flutter pub upgrade --major-versions

deep-clean:
	@echo "* Performing a deep clean *"
	@echo "* Running flutter clean *"
	@fvm flutter clean
	@echo "* Cleaning iOS specific files *"
	@sh ./script/clean_ios.sh
	@make get
	@make install-pods

gen-build: get
	@echo "* Running build runner *"
	@fvm flutter pub run build_runner build

gen-build-delete: get
	@echo "* Running build runner with deletion of conflicting outputs *"
	@fvm flutter pub run build_runner build --delete-conflicting-outputs

gen-clean:
	@echo "* Cleaning build runner *"
	@fvm flutter pub run build_runner clean

gen-watch:
	@echo "* Running build runner in watch mode *"
	@fvm flutter pub run build_runner watch

create-splash: get
	@echo "* Generating Splash screens *"
	@fvm flutter pub run flutter_native_splash:create

prepare: get gen-build-delete create-splash

first-run: prepare run 

set-icon: get
	@echo "* Removing alpha chanel from icon *"
	@sh ./script/icon_remove_alpha.sh
	@echo "* Generating app icons *"
	@fvm flutter pub run flutter_launcher_icons:main -f flutter_icons.yaml

google-localizations:
	@echo "* Getting dependencies for google localizer *"
	@(cd ./tool/google_localizer; fvm dart pub get)
	@echo "* Generating automated localizations *"
	@fvm dart ./tool/google_localizer/main.dart "./lib/common/l10n/"

setup:
	@echo "* Getting dependencies for setup tool *"
	@(cd ./tool/setup_clone; fvm dart pub get)
	@echo "* Setting up the project *"
	@fvm dart ./tool/setup_clone/main.dart $(NAME)

emulator:
	@echo "* Opening an android emulator *"
	@emulator @Pixel_XL_API_30

simulator:
	@echo "* Opening an iOS simulator *"
	@open -a Simulator

stats:
	@echo "* Running cloc *"
	@cloc .
