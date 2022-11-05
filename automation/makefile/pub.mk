.PHONY: pub-get pub-outdated pub-upgrade pub-upgrade-major

# Fetches latest dependencies using Flutter Version Manager.
pub-get:
	@echo "* Getting latest dependencies *"
	@fvm flutter pub get

pub-upgrade:
	@echo "* Upgrading dependencies *"
	@fvm flutter pub upgrade

pub-upgrade-major:
	@echo "* Upgrading dependencies --major-versions *"
	@fvm flutter pub upgrade --major-versions

pub-outdated: pub-upgrade
	@echo "* Checking for outdated dependencies *"
	@fvm flutter pub outdated