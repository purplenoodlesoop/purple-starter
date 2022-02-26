.PHONY: get install-pods run upgrade upgrade-major deep-clean gen-build gen-build-delete gen-clean gen-watch create-splash first-run set-icon google-localizations setup emulator simulator stats


get:
	@echo "* Getting latest dependencies *"
	@flutter pub get

install-pods:
	@echo "* Installing pods *"
	@(cd ./ios; pod install)

run:
	@echo "* Running app *"
	@flutter run

upgrade: get
	@echo "* Upgrading dependencies *"
	@flutter pub upgrade

upgrade-major: get
	@echo "* Upgrading dependencies --major-versions *"
	@flutter pub upgrade --major-versions

deep-clean:
	@echo "* Performing a deep clean *"
	@echo "* Running flutter clean *"
	@flutter clean
	@echo "* Cleaning iOS specific files *"
	@sh ./script/clean_ios.sh
	@make get
	@make install-pods

gen-build: get
	@echo "* Running build runner *"
	@flutter pub run build_runner build

gen-build-delete: get
	@echo "* Running build runner with deletion of conflicting outputs *"
	@flutter pub run build_runner build --delete-conflicting-outputs

gen-clean:
	@echo "* Cleaning build runner *"
	@flutter pub run build_runner clean

gen-watch:
	@echo "* Running build runner in watch mode *"
	@flutter pub run build_runner watch

create-splash: get
	@echo "* Generating Splash screens *"
	@flutter pub run flutter_native_splash:create

first-run: get gen-build-delete create-splash run 

set-icon: get
	@echo "* Removing alpha chanel from icon *"
	@sh ./script/icon_remove_alpha.sh
	@echo "* Generating app icons *"
	@flutter pub run flutter_launcher_icons:main -f flutter_icons.yaml

google-localizations:
	@echo "* Getting dependencies for google localizer *"
	@(cd ./tool/google_localizer; dart pub get)
	@echo "* Generating automated localizations *"
	@dart ./tool/google_localizer/main.dart "./lib/common/l10n/"

setup:
	@echo "* Getting dependencies for setup tool *"
	@(cd ./tool/setup_clone; dart pub get)
	@echo "* Setting up the project *"
	@dart ./tool/setup_clone/main.dart $(NAME)

emulator:
	@echo "* Opening an android emulator *"
	@emulator @Pixel_XL_API_30

simulator:
	@echo "* Opening an iOS simulator *"
	@open -a Simulator

stats:
	@echo "* Running cloc *"
	@cloc .
