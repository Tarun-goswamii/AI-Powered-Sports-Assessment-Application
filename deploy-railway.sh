#!/bin/bash
# deploy-railway.sh - Deploy ML Server to Railway

echo "🚀 Deploying Sports Assessment ML Server to Railway..."

# Check if Railway CLI is installed
if ! command -v railway &> /dev/null; then
    echo "❌ Railway CLI not found. Installing..."
    npm install -g @railway/cli
fi

# Login to Railway (if not already logged in)
echo "🔐 Logging in to Railway..."
railway login

# Initialize Railway project (if not already done)
if [ ! -f "railway.toml" ]; then
    echo "🏗️ Initializing Railway project..."
    railway init
fi

# Deploy to Railway
echo "📦 Deploying to Railway..."
railway up

echo "✅ Deployment complete!"
echo "🌐 Your ML server will be available at: https://[your-project].railway.app"
echo "📝 Update AppConfig.mlServerUrlProd with your actual Railway URL"