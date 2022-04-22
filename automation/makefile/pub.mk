.PHONY: pub-get pub-outdated pub-upgrade pub-upgrade-major

clean:
	@echo "* Cleaning the project *"
	@rm -rf build .flutter-plugins .flutter-plugins-dependencies coverage .dart_tool .packages pubspec.lock
	@flutter clean
	@ #git clean -fdx

pub-get:
	@echo "* Getting latest dependencies *"
	@flutter pub get

pub-upgrade:
	@echo "* Upgrading dependencies *"
	@flutter pub upgrade

pub-upgrade-major:
	@echo "* Upgrading dependencies --major-versions *"
	@flutter pub upgrade --major-versions

pub-outdated: pub-upgrade
	@echo "* Checking for outdated dependencies *"
	@flutter pub outdated