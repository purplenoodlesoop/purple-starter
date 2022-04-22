.PHONY: gen-build gen-build-delete gen-clean gen-watch doc

gen-build: pub-get
	@echo "* Running build runner *"
	@time flutter pub run build_runner build

gen-build-delete: pub-get
	@echo "* Running build runner with deletion of conflicting outputs *"
	@time flutter pub run build_runner build --delete-conflicting-outputs

gen-clean:
	@echo "* Cleaning build runner *"
	@flutter pub run build_runner clean

gen-watch:
	@echo "* Running build runner in watch mode *"
	@flutter pub run build_runner watch

doc:
	@dart doc