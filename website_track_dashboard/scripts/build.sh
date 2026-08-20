#!/bin/bash

echo "Installing Flutter..."

if [ -d "flutter" ]; then
  cd flutter
  git pull
  cd ..
else
  git clone https://github.com/flutter/flutter.git -b stable --depth 1
fi

# ADD FLUTTER TO PATH
export PATH="$PATH:`pwd`/flutter/bin"

echo "Flutter version:"
flutter --version

echo "Enable web..."
flutter config --enable-web

echo "Cleaning previous build output..."
rm -rf build/web

echo "Building Flutter Web..."

flutter clean
flutter pub get

# If you need to set API_BASE_URL from Vercel environment variables, you can add:
# --dart-define=API_BASE_URL="$API_BASE_URL" to the command below.
flutter build web --release --tree-shake-icons -O4 --source-maps --web-resources-cdn
