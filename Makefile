.PHONY: get run upgrade upgrade-major gen-delete deep-clean set-icon google-localizations setup emulator simulator

get:
	@echo "* Getting latest dependencies *"
	@flutter pub get

run:
	@echo "* Running app *"
	@flutter run

upgrade: get
	@echo "* Upgrading dependencies *"
	@flutter pub upgrade

upgrade-major: get
	@echo "* Upgrading dependencies --major-versions *"
	@flutter pub upgrade --major-versions

gen: get
	@echo "* Running build runner *"
	@flutter pub run build_runner build

gen-delete: get
	@echo "* Running build runner with deletion of conflicting outputs *"
	@flutter pub run build_runner build --delete-conflicting-outputs

deep-clean:
	@echo "* Performing a deep clean *"
	@sh ./script/clean_ios.sh
	@make get

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
