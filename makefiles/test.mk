.PHONY: test coverage

# Запустить тесты
test:
	@time timeout 300 flutter test --concurrency=6 --dart-define=environment=testing --coverage test/

# Запустить все тесты и собрать общее покрытие
coverage: test
	@ #mv coverage/lcov.info coverage/lcov.base.info
	@ #lcov -r coverage/lcov.base.info -o coverage/lcov.base.info "lib/**.freezed.dart" "lib/**.g.dart"
	@ #mv coverage/lcov.base.info coverage/lcov.info
	@ #dart run coverage:format_coverage --lcov --in=coverage --out=coverage/lcov.info --packages=.packages --report-on=lib
	@ #lcov --list coverage/lcov.info
	@lcov --summary coverage/lcov.info
	@genhtml -o coverage coverage/lcov.info

# Интеграционные тесты
integration:
	@flutter test \
		--flavor integration \
		--dart-define=environment=integration \
		--coverage \
		integration_test/app_test.dart

# Запустить тесты на последней стейбл версии флатера с поддержкой веба
# https://hub.docker.com/r/plugfox/flutter/tags?page=1&name=stable-web
#
# Если необходимо добавить sqlite последней версии:
# ```
# echo "https://dl-cdn.alpinelinux.org/alpine/edge/main" > /etc/apk/repositories \
# echo "https://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories \
# echo "https://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
# apk update && apk --no-cache add sqlite sqlite-dev lcov
# ```
#
# Сконфигурировать git:
# ```
# git config --global user.email "developer@domain.tld" \
# git config --global user.name "Flutter Developer" \
# git config --global credential.helper store \
# git config --global --add safe.directory /opt/flutter
# ```
test-docker:
	@docker run --rm -it -v ${PWD}:/app --workdir /app \
		--user=root:root \
		--name flutter_testings \
			plugfox/flutter:stable-web /bin/bash -ci ' \
				set -eux; shopt -s dotglob \
				&& mkdir -p /app/build; touch /app/build/.docker.txt \
				&& echo "Testing inside docker container: started" > /app/build/.docker.txt 2>&1 \
				&& date >> /app/build/.docker.txt 2>&1 \
				&& echo "https://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
				&& apk update && apk --no-cache add lcov \
				&& export PUB_CACHE="/var/tmp/.pub_cache" \
				&& flutter config --no-analytics --no-color \
				&& time timeout 60 flutter pub get --suppress-analytics --verbose >> /app/build/.docker.txt 2>&1 \
				&& time timeout 300 flutter pub run build_runner build --delete-conflicting-outputs --release --verbose >> /app/build/.docker.txt 2>&1 \
				&& time timeout 300 flutter test --concurrency=6 --dart-define=environment=testing --coverage test/ >> /app/build/.docker.txt 2>&1 \
				&& lcov --summary coverage/lcov.info \
				&& genhtml -o coverage coverage/lcov.info \
				&& date >> /app/build/.docker.txt 2>&1 \
				&& echo "Testing inside docker container: completed" >> /app/build/.docker.txt 2>&1'