.PHONY: pub-get pub-outdated pub-upgrade pub-upgrade-major install-pods run clean ios-deep-clean gen-build gen-build-delete gen-clean gen-watch create-splash prepare first-run metrics-analyze metrics-unused-files metrics-unused-l10n metrics-unused-code set-icon google-localizations emulator simulator stats


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

install-pods:
	@echo "* Installing pods *"
	@pod install --project-directory=./ios

run:
	@echo "* Running app *"
	@fvm flutter run

clean:
	@echo "* Cleaning project *"
	@fvm flutter clean

ios-deep-clean:
	@echo "* Performing a deep clean for iOS *"
	@grind clean-project
	@make pub-get
	@make install-pods

gen-build: pub-get
	@echo "* Running build runner *"
	@fvm flutter pub run build_runner build

gen-build-delete: pub-get
	@echo "* Running build runner with deletion of conflicting outputs *"
	@fvm flutter pub run build_runner build --delete-conflicting-outputs

gen-clean:
	@echo "* Cleaning build runner *"
	@fvm flutter pub run build_runner clean

gen-watch:
	@echo "* Running build runner in watch mode *"
	@fvm flutter pub run build_runner watch

create-splash: pub-get
	@echo "* Generating Splash screens *"
	@fvm flutter pub run flutter_native_splash:create

prepare: pub-get gen-build-delete create-splash

first-run: prepare run

define run_metrics
	@echo "* $(1) using Dart Code Metrics *"
	@fvm flutter pub run dart_code_metrics:metrics $(2) lib \
			--exclude={/**.g.dart,/**.gr.dart,/**.gen.dart,/**.freezed.dart,/**.template.dart,}
endef

define run_metrics_unused
	$(call run_metrics,Checking for unused $(1),check-unused-$(1))
endef

metrics-analyze:
	$(call run_metrics,Analyzing the codebase,analyze)

metrics-unused-files:
	$(call run_metrics_unused,files)

metrics-unused-l10n:
	$(call run_metrics_unused,l10n)

metrics-unused-code:
	$(call run_metrics_unused,code)

set-icon: pub-get
	@echo "* Generating app icons *"
	@fvm flutter pub run flutter_launcher_icons:main -f flutter_icons.yaml

google-localizations:
	@echo "* Getting dependencies for google localizer *"
	@fvm dart pub get --directory=./tool/google_localizer
	@echo "* Generating automated localizations *"
	@fvm dart ./tool/google_localizer/main.dart "./lib/src/core/l10n/"

#setup:
#	@echo "* Getting dependencies for setup tool *"
#	fvm dart pub get --directory=./tool/setup_clone
#	@echo "* Setting up the project *"
#	@fvm dart ./tool/setup_clone/main.dart $(NAME)

emulator:
	@echo "* Opening an android emulator *"
	@emulator @Pixel_XL_API_30

simulator:
	@echo "* Opening an iOS simulator *"
	@open -a Simulator

stats:
	@echo "* Running cloc *"
	@cloc .
