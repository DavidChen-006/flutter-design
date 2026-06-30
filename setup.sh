#!/usr/bin/env bash
# Set up the scaffold: enable macOS desktop support and install dependencies.
set -euo pipefail

flutter config --enable-macos-desktop
flutter pub get
