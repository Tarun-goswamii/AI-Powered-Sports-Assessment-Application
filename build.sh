#!/bin/bash

# Vercel Build Script for Flutter Web App
echo "🚀 Starting Flutter Web Build for Vercel..."

# Install Flutter if not available
if ! command -v flutter &> /dev/null; then
    echo "📦 Installing Flutter..."
    git clone https://github.com/flutter/flutter.git -b stable --depth 1 /tmp/flutter
    export PATH="$PATH:/tmp/flutter/bin"
fi

# Verify Flutter installation
flutter --version

# Enable web support
flutter config --enable-web

# Get dependencies
echo "📦 Getting Flutter dependencies..."
flutter pub get

# Clean previous builds
flutter clean

# Build for web with optimizations
echo "🔨 Building Flutter web app..."
flutter build web \
  --release \
  --base-href "/" \
  --dart-define=FLUTTER_WEB_CANVASKIT_URL=https://unpkg.com/canvaskit-wasm@0.39.1/bin/ \
  --source-maps

echo "✅ Flutter web build completed!"
echo "📁 Build output: build/web/"

# List build contents for verification
ls -la build/web/