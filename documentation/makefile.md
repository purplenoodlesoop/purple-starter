# Makefile documentation

This file is auto-generated
## Index

- [Build](#build)
- [Build web](#build-web)
- [Clean](#clean)
- [Coverage](#coverage)
- [Dependency validator](#dependency-validator)
- [Doc](#doc)
- [Doctor](#doctor)
- [Emulator](#emulator)
- [First run](#first-run)
- [Format](#format)
- [Gen build](#gen-build)
- [Gen build delete](#gen-build-delete)
- [Gen clean](#gen-clean)
- [Gen watch](#gen-watch)
- [Google localizations](#google-localizations)
- [Help](#help)
- [Icon](#icon)
- [Install apk](#install-apk)
- [Install pods](#install-pods)
- [Integration](#integration)
- [Ios deep clean](#ios-deep-clean)
- [Logs](#logs)
- [Metrics analyze](#metrics-analyze)
- [Metrics unused code](#metrics-unused-code)
- [Metrics unused files](#metrics-unused-files)
- [Metrics unused l10n](#metrics-unused-l10n)
- [Pana](#pana)
- [Prepare](#prepare)
- [Pub get](#pub-get)
- [Pub outdated](#pub-outdated)
- [Pub upgrade](#pub-upgrade)
- [Pub upgrade major](#pub-upgrade-major)
- [Run](#run)
- [Run develop](#run-develop)
- [Run production](#run-production)
- [Run staging](#run-staging)
- [Setup](#setup)
- [Simulator](#simulator)
- [Splash](#splash)
- [Stats](#stats)
- [Test](#test)
- [Version](#version)

## Targets

### Build

#### Name

`build`

#### Perquisites

- `pub-get`

#### Recipe

```Makefile
@echo "Building Android APK"
@make clean
@fvm flutter build apk --release --tree-shake-icons --no-shrink
```

### Build web

#### Name

`build-web`

#### Perquisites

- `pub-get`

#### Recipe

```Makefile
@echo "Building Web app"
@make clean
@fvm flutter build web --release --dart-define=FLUTTER_WEB_USE_SKIA=true --no-source-maps --pwa-strategy offline-first
```

### Clean

#### Name

`clean`

#### Used by

- [Build](#build)
- [Build web](#build-web)

#### Recipe

```Makefile
@echo "* Cleaning the project *"
@rm -rf build .flutter-plugins .flutter-plugins-dependencies coverage .dart_tool .packages pubspec.lock
@fvm flutter clean
@git clean -d
@make pub-get
```

### Coverage

Run tests and generate coverage report
#### Name

`coverage`

#### Perquisites

- `test`

#### Recipe

```Makefile
@ #mv coverage/lcov.info coverage/lcov.base.info
@ #lcov -r coverage/lcov.base.info -o coverage/lcov.base.info "lib/**.freezed.dart" "lib/**.g.dart"
@ #mv coverage/lcov.base.info coverage/lcov.info
@ #dart run coverage:format_coverage --lcov --in=coverage --out=coverage/lcov.info --packages=.packages --report-on=lib
@ #lcov --list coverage/lcov.info
@lcov --summary coverage/lcov.info
@genhtml -o coverage coverage/lcov.info
```

### Dependency validator

#### Name

`dependency-validator`

#### Recipe

```Makefile
@pub run dependency_validator
```

### Doc

#### Name

`doc`

#### Recipe

```Makefile
@fvm dart doc
```

### Doctor

#### Name

`doctor`

#### Recipe

```Makefile
@fvm flutter doctor
```

### Emulator

#### Name

`emulator`

#### Recipe

```Makefile
@echo "* Opening an Android emulator *"
@emulator @Pixel_XL_API_30
```

### First run

#### Name

`first-run`

#### Perquisites

- `prepare`
- `run`


### Format

#### Name

`format`

#### Recipe

```Makefile
@fvm dart fix --apply .
@fvm dart format -l 80 --fix .
```

### Gen build

#### Name

`gen-build`

#### Perquisites

- `pub-get`

#### Recipe

```Makefile
@echo "* Running build runner *"
@fvm flutter pub run build_runner build
```

### Gen build delete

#### Name

`gen-build-delete`

#### Used by

- [Prepare](#prepare)

#### Perquisites

- `pub-get`

#### Recipe

```Makefile
@echo "* Running build runner with deletion of conflicting outputs *"
@fvm flutter pub run build_runner build --delete-conflicting-outputs
```

### Gen clean

#### Name

`gen-clean`

#### Recipe

```Makefile
@echo "* Cleaning build runner *"
@fvm flutter pub run build_runner clean
```

### Gen watch

#### Name

`gen-watch`

#### Recipe

```Makefile
@echo "* Running build runner in watch mode *"
@fvm flutter pub run build_runner watch
```

### Google localizations

#### Name

`google-localizations`

#### Recipe

```Makefile
@echo "* Getting dependencies for google localizer *"
@fvm dart pub get --directory=./tool/google_localizer
@echo "* Generating automated localizations *"
@fvm dart ./tool/google_localizer/main.dart "./lib/src/core/l10n/"
```

### Help

Script description and usage through `make` or `make help` commands
#### Name

`help`

#### Recipe

```Makefile
@echo "Make something good"
@echo " or something worse"
@echo "  or something else"
@echo "   with this script"
```

### Icon

#### Name

`icon`

#### Used by

- [Prepare](#prepare)

#### Perquisites

- `pub-get`

#### Recipe

```Makefile
@echo "* Generating app icons *"
@fvm flutter pub run flutter_launcher_icons:main -f flutter_launcher_icons.yaml
```

### Install apk

#### Name

`install-apk`

#### Recipe

```Makefile
@adb install build\app\outputs\flutter-apk\app-release.apk
```

### Install pods

#### Name

`install-pods`

#### Used by

- [Ios deep clean](#ios-deep-clean)

#### Recipe

```Makefile
@echo "* Installing pods *"
@pod install --project-directory=./ios
```

### Integration

Run integration tests
#### Name

`integration`

#### Recipe

```Makefile
@fvm flutter test \
--flavor integration \
--dart-define=environment=integration \
--coverage \
integration_test/app_test.dart
```

### Ios deep clean

#### Name

`ios-deep-clean`

#### Recipe

```Makefile
@echo "* Performing a deep clean for iOS *"
@grind clean-ios
@make pub-get
@make install-pods
```

### Logs

#### Name

`logs`

#### Recipe

```Makefile
@fvm flutter logs
```

### Metrics analyze

#### Name

`metrics-analyze`

#### Recipe

```Makefile
@grind code-metrics-analyze
```

### Metrics unused code

#### Name

`metrics-unused-code`

#### Recipe

```Makefile
@grind code-metrics-unused-code
```

### Metrics unused files

#### Name

`metrics-unused-files`

#### Recipe

```Makefile
@grind code-metrics-unused-files
```

### Metrics unused l10n

#### Name

`metrics-unused-l10n`

#### Recipe

```Makefile
@grind code-metrics-unused-l10n
```

### Pana

#### Name

`pana`

#### Recipe

```Makefile
@pana --json --no-warning --line-length 80
```

### Prepare

Prepares the application for the first run.  Fetches latest dependencies, and generates code, icon and splash screen.
#### Name

`prepare`

#### Used by

- [First run](#first-run)

#### Perquisites

- `pub-get`
- `gen-build-delete`
- `icon`
- `splash`

#### Recipe

```Makefile
@echo "* Prepared the application *"
```

### Pub get

Fetches latest dependencies using Flutter Version Manager.
#### Name

`pub-get`

#### Used by

- [Build](#build)
- [Build web](#build-web)
- [Clean](#clean)
- [Gen build](#gen-build)
- [Gen build delete](#gen-build-delete)
- [Icon](#icon)
- [Ios deep clean](#ios-deep-clean)
- [Prepare](#prepare)
- [Splash](#splash)

#### Recipe

```Makefile
@echo "* Getting latest dependencies *"
@fvm flutter pub get
```

### Pub outdated

#### Name

`pub-outdated`

#### Perquisites

- `pub-upgrade`

#### Recipe

```Makefile
@echo "* Checking for outdated dependencies *"
@fvm flutter pub outdated
```

### Pub upgrade

#### Name

`pub-upgrade`

#### Used by

- [Pub outdated](#pub-outdated)

#### Recipe

```Makefile
@echo "* Upgrading dependencies *"
@fvm flutter pub upgrade
```

### Pub upgrade major

#### Name

`pub-upgrade-major`

#### Recipe

```Makefile
@echo "* Upgrading dependencies --major-versions *"
@fvm flutter pub upgrade --major-versions
```

### Run

#### Name

`run`

#### Used by

- [First run](#first-run)

#### Recipe

```Makefile
@echo "* Running app *"
@fvm flutter run
```

### Run develop

Development/Trunk
#### Name

`run-develop`

#### Recipe

```Makefile
@fvm flutter run --flavor development --dart-define=environment=development
```

### Run production

Production/Live
#### Name

`run-production`

#### Recipe

```Makefile
@fvm flutter run --flavor production --dart-define=environment=production
```

### Run staging

Staging/Stage/Model/Pre-production
#### Name

`run-staging`

#### Recipe

```Makefile
@fvm flutter run --flavor staging --dart-define=environment=staging
```

### Setup

#### Name

`setup`

#### Recipe

```Makefile
@echo "* Getting dependencies for setup tool *"
@fvm dart pub get --directory=./tool/setup_clone
@echo "* Setting up the project *"
@fvm dart ./tool/setup_clone/main.dart $(NAME)
```

### Simulator

#### Name

`simulator`

#### Recipe

```Makefile
@echo "* Opening an iOS simulator *"
@open -a Simulator
```

### Splash

#### Name

`splash`

#### Used by

- [Prepare](#prepare)

#### Perquisites

- `pub-get`

#### Recipe

```Makefile
@echo "* Generating Splash screens *"
@fvm flutter pub run flutter_native_splash:create
```

### Stats

#### Name

`stats`

#### Recipe

```Makefile
@echo "* Running cloc *"
@cloc .
```

### Test

Run tests
#### Name

`test`

#### Used by

- [Coverage](#coverage)

#### Recipe

```Makefile
@time flutter test --concurrency=6 --dart-define=environment=testing --coverage test/
```

### Version

#### Name

`version`

#### Recipe

```Makefile
@fvm flutter --version
```



