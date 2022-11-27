.PHONY: build-android build-web build-ios

build-android: clean
	@echo "Building Android APK"
	@fvm flutter build apk --no-pub --no-shrink

build-web: clean
	@echo "Building Web app"
	@fvm flutter build web --dart-define=FLUTTER_WEB_USE_SKIA=true --no-pub --no-source-maps --pwa-strategy offline-first

build-ios: clean
	@echo "Building iOS IPA"
	@fvm flutter build ipa --no-pub