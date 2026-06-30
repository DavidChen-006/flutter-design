#!/usr/bin/env bash
# Run the scaffold on macOS (installs dependencies first).
set -euo pipefail

flutter pub get
flutter run -d macos
