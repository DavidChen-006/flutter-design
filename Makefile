# Scaffold helper commands.
#   make setup  -> install dependencies and enable macOS desktop support
#   make run    -> run the app on macOS (installs deps first)

.PHONY: setup run

setup:
	flutter config --enable-macos-desktop
	flutter pub get

run:
	flutter pub get
	flutter run -d macos
