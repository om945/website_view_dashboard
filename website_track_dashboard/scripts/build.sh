#!/usr/bin/env bash
set -euo pipefail

# Vercel runs this script from the Flutter project root. The source checkout is
# the deployment input; build/web is always regenerated from that checkout.
FLUTTER_DIR="${FLUTTER_DIR:-.flutter-sdk}"
API_BASE_URL="${API_BASE_URL:-https://website-view-api-1.onrender.com}"
APP_ENV="${APP_ENV:-production}"

echo "Preparing Flutter SDK..."
if [ ! -x "$FLUTTER_DIR/bin/flutter" ]; then
  rm -rf "$FLUTTER_DIR"
  git clone --depth 1 --branch stable https://github.com/flutter/flutter.git "$FLUTTER_DIR"
fi

export PATH="$PWD/$FLUTTER_DIR/bin:$PATH"

flutter --version
flutter config --enable-web

echo "Cleaning release output..."
flutter clean
rm -rf build/web

echo "Installing Dart dependencies..."
flutter pub get

echo "Building Flutter Web release..."
flutter build web \
  --release \
  --tree-shake-icons \
  --source-maps \
  --web-resources-cdn \
  --dart-define=API_BASE_URL="$API_BASE_URL" \
  --dart-define=APP_ENV="$APP_ENV"
