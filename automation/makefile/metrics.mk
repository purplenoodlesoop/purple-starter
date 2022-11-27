.PHONY: metrics-analyze metrics-unused-files metrics-unused-l10n metrics-unused-code stats dependency-validator pana

metrics-analyze:
	@grind code-metrics-analyze

metrics-unused-files:
	@grind code-metrics-unused-files

metrics-unused-l10n:
	@grind code-metrics-unused-l10n

metrics-unused-code:
	@grind code-metrics-unused-code

dependency-validator:
	@pub run dependency_validator

pana:
	@pana --json --no-warning --line-length 80
