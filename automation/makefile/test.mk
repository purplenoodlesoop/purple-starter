.PHONY: test coverage

# Run tests
test:
	@grind run-tests

# Run tests and generate coverage report
coverage: test
	@ #mv coverage/lcov.info coverage/lcov.base.info
	@ #lcov -r coverage/lcov.base.info -o coverage/lcov.base.info "lib/**.freezed.dart" "lib/**.g.dart"
	@ #mv coverage/lcov.base.info coverage/lcov.info
	@ #dart run coverage:format_coverage --lcov --in=coverage --out=coverage/lcov.info --packages=.packages --report-on=lib
	@ #lcov --list coverage/lcov.info
	@lcov --summary coverage/lcov.info
	@genhtml -o coverage coverage/lcov.info

# Run integration tests
integration:
	@fvm flutter test \
		--flavor integration \
		--dart-define=environment=integration \
		--coverage \
		integration_test/app_test.dart