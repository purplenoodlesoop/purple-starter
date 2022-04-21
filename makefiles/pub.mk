.PHONY: pub-get pub-outdated pub-upgrade pub-upgrade-major

clean:
	@echo "* Cleaning project *"
	@rm -rf build .flutter-plugins .flutter-plugins-dependencies coverage .dart_tool .packages pubspec.lock
	@fvm flutter clean
	@ #git clean -fdx

pub-get:
	@echo "* Getting latest dependencies *"
	@timeout 60 fvm flutter pub get

pub-upgrade:
	@echo "* Upgrading dependencies *"
	@timeout 60 fvm flutter pub upgrade

pub-upgrade-major:
	@echo "* Upgrading dependencies --major-versions *"
	@timeout 60 fvm flutter pub upgrade --major-versions

pub-outdated: pub-upgrade
	@echo "* Checking for outdated dependencies *"
	@timeout 120 fvm flutter pub outdated