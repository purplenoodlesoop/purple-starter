.PHONY: test coverage

test:
	@dart test --concurrency=6 --platform vm --coverage=coverage test/*

coverage: test
	@dart run coverage:format_coverage --lcov --in=coverage --out=coverage/lcov.info --packages=.packages --report-on=lib
	@genhtml -o coverage coverage/lcov.info