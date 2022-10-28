.PHONY: build build-web pigeon

build: get
	@echo "Building Android APK"
	@make clean
	@fvm flutter build apk --release --tree-shake-icons --no-shrink

build-web: get
	@echo "Building Web app"
	@make clean
	@fvm flutter build web --release --dart-define=FLUTTER_WEB_USE_SKIA=true --no-source-maps --pwa-strategy offline-first

 