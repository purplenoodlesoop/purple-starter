.PHONY: get upgrade upgrade-major gen-delete deep-clean set-icon google-localizations emulator simulator

get:
	@echo "* Getting latest dependencies *"
	@flutter pub get

upgrade: get
	@echo "* Upgrading dependencies *"
	@flutter pub upgrade

upgrade-major: get
	@echo "* Upgrading dependencies --major-versions *"
	@flutter pub upgrade --major-versions

gen-delete:
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
	@echo "* Getting dependencies form google localizer *"
	@(cd ./tool/google_localizer; dart pub get)
	@echo "* Generating automated localizations *"
	@dart ./tool/google_localizer/main.dart "./lib/common/l10n/"

emulator:
	@echo "* Opening an android emulator *"
	@emulator @Pixel_XL_API_30

simulator:
	@echo "* Opening an iOS simulator *"
	@open -a Simulator
