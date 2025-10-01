#!/bin/bash

# Vercel Build Script for Flutter Web App
echo "🚀 Starting Flutter Web Build for Vercel..."

# Set Flutter version
FLUTTER_VERSION="3.24.3"
FLUTTER_CHANNEL="stable"

# Install Flutter
echo "📦 Installing Flutter ${FLUTTER_VERSION}..."
cd /tmp
git clone https://github.com/flutter/flutter.git -b ${FLUTTER_CHANNEL} --depth 1
export PATH="$PATH:/tmp/flutter/bin"

# Verify Flutter installation
echo "✅ Verifying Flutter installation..."
flutter --version

# Go back to project directory
cd $VERCEL_PROJECT_ROOT

# Configure Flutter for web
echo "🌐 Configuring Flutter for web..."
flutter config --enable-web

# Get dependencies
echo "📚 Getting Flutter dependencies..."
flutter pub get

# Build web app
echo "🔨 Building Flutter web app..."
flutter build web --release --web-renderer html

echo "✅ Flutter web build completed successfully!"
echo "📁 Build output in: build/web"

# List build contents for verification
ls -la build/web/