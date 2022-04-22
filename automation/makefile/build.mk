.PHONY: build build-web pigeon

build: get
	@echo "Building Android APK"
	@flutter clean
	@flutter build apk --release --tree-shake-icons --no-shrink

build-web: get
	@echo "Building Web app"
	@flutter clean
	@flutter build web --release --dart-define=FLUTTER_WEB_USE_SKIA=true --no-source-maps --pwa-strategy offline-first

#pigeon: get
#	@echo "Running pigeon codegeneration"
#	flutter pub run pigeon \
#      --input pigeon/***.dart \
#      --copyright_header pigeon/copyright.txt \
#      --dart_out lib/***/***.pg.dart \
#      --objc_header_out ios/Runner/pigeon/***.h \
#      --objc_source_out ios/Runner/pigeon/***.m \
#      --java_out ./android/app/src/main/java/dev/pigeon/***.java \
#      --java_package "dev.flutter.pigeon" \
#      --dart_null_safety
 