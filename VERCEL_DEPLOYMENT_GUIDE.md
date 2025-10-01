# 🚀 Vercel Deployment Guide

## Flutter Sports Assessment App - Vercel Deployment

This guide will walk you through deploying your Flutter web app to Vercel with full Convex backend integration.

### 📋 Prerequisites

1. **Vercel Account**: Sign up at [vercel.com](https://vercel.com)
2. **Git Repository**: Your code should be in a Git repository (GitHub, GitLab, etc.)
3. **Flutter SDK**: Ensure Flutter is installed and web support is enabled
4. **Node.js**: Required for Vercel CLI (optional but recommended)

### 🛠️ Pre-Deployment Setup

#### 1. Install Vercel CLI (Optional)
```bash
npm install -g vercel
```

#### 2. Test Local Build
```bash
# Clean and build for web
flutter clean
flutter pub get
flutter build web --release

# Test the build locally
cd build/web
python -m http.server 8000
# Visit http://localhost:8000
```

### 🌐 Vercel Deployment Steps

#### Method 1: Web Interface (Recommended for first-time users)

1. **Connect Repository**
   - Go to [vercel.com](https://vercel.com)
   - Click "New Project"
   - Import your Git repository

2. **Configure Build Settings**
   - **Framework Preset**: None (or Other)
   - **Build Command**: `flutter build web --release`
   - **Output Directory**: `build/web`
   - **Install Command**: `flutter pub get`

3. **Environment Variables**
   Add these in Vercel dashboard:
   ```
   FLUTTER_WEB=true
   CONVEX_URL=https://pleasant-mandrill-295.convex.cloud
   FIREBASE_API_KEY=AIzaSyAPifHu945t_OZ9HkFkLW9hlHRyFRy8Kug
   FIREBASE_PROJECT_ID=ai-sport-assessment
   RESEND_API_KEY=your_resend_api_key
   ```

4. **Deploy**
   - Click "Deploy"
   - Wait for build to complete

#### Method 2: Vercel CLI

1. **Login to Vercel**
   ```bash
   vercel login
   ```

2. **Initialize Project**
   ```bash
   vercel
   # Follow the prompts
   ```

3. **Deploy**
   ```bash
   vercel --prod
   ```

### ⚙️ Configuration Files

The following files are already configured for Vercel:

#### `vercel.json`
- Build configuration
- API routing for Convex proxy
- Headers for security and caching
- Rewrites for SPA routing

#### `api/convex/[functionName].js`
- Proxy endpoint for Convex functions
- Handles CORS issues
- Provides fallback mock data

#### `build.sh` / `build.bat`
- Build scripts for different platforms
- Optimized Flutter web build

### 🔧 Troubleshooting

#### Common Issues and Solutions

1. **Build Failures**
   ```bash
   # Clear cache and rebuild
   flutter clean
   flutter pub get
   flutter build web --release
   ```

2. **CORS Issues**
   - API proxy is configured in `api/convex/[functionName].js`
   - Ensure proper headers are set

3. **Route Not Found (404)**
   - Check `vercel.json` rewrites configuration
   - Ensure SPA routing is properly configured

4. **Environment Variables**
   - Set in Vercel dashboard under Project Settings > Environment Variables
   - Use `process.env.VARIABLE_NAME` in API functions

#### Performance Optimization

1. **Enable Compression**
   ```json
   // In vercel.json
   "headers": [
     {
       "source": "/(.*)",
       "headers": [
         {
           "key": "Content-Encoding",
           "value": "gzip"
         }
       ]
     }
   ]
   ```

2. **Asset Caching**
   - Already configured in `vercel.json`
   - Static assets cached for 1 year

3. **Bundle Size**
   ```bash
   # Analyze bundle size
   flutter build web --analyze-size
   ```

### 🌍 Custom Domain Setup

1. **Add Domain in Vercel**
   - Go to Project Settings > Domains
   - Add your custom domain

2. **DNS Configuration**
   - Point your domain to Vercel servers
   - Follow Vercel's DNS instructions

### 📊 Monitoring and Analytics

1. **Vercel Analytics**
   - Automatically enabled for performance monitoring
   - View in Vercel dashboard

2. **Error Tracking**
   - Check Function Logs in Vercel dashboard
   - Monitor API endpoint performance

### 🔐 Security Considerations

1. **Environment Variables**
   - Never commit sensitive keys to Git
   - Use Vercel environment variables

2. **API Security**
   - CORS properly configured
   - Rate limiting can be added to API functions

3. **HTTPS**
   - Automatically enabled by Vercel
   - All traffic encrypted

### 🚀 Deployment Checklist

- [ ] Repository connected to Vercel
- [ ] Build configuration set correctly
- [ ] Environment variables configured
- [ ] Test local build
- [ ] Deploy to staging
- [ ] Test all features
- [ ] Deploy to production
- [ ] Set up custom domain (optional)
- [ ] Configure monitoring

### 📱 Testing After Deployment

1. **Basic Functionality**
   - App loads correctly
   - Navigation works
   - Authentication functions

2. **API Integration**
   - Convex functions working
   - Data loading properly
   - Error handling

3. **Performance**
   - Page load times
   - Mobile responsiveness
   - PWA features

### 🔄 Continuous Deployment

Vercel automatically deploys when you push to your connected Git repository:

1. **Automatic Deployments**
   - Push to main branch = production deployment
   - Push to other branches = preview deployments

2. **Preview Deployments**
   - Each pull request gets a unique URL
   - Perfect for testing features

### 📞 Support

If you encounter issues:

1. **Vercel Documentation**: [vercel.com/docs](https://vercel.com/docs)
2. **Flutter Web Docs**: [flutter.dev/web](https://flutter.dev/web)
3. **Check Function Logs**: Vercel Dashboard > Functions tab
4. **Community**: Vercel Discord, Flutter Discord

---

## 🎉 Your App is Live!

Once deployed, your Flutter Sports Assessment app will be available at:
- **Vercel URL**: `https://your-project-name.vercel.app`
- **Custom Domain**: `https://your-domain.com` (if configured)

The app includes:
- ✅ Real-time Convex backend integration
- ✅ Firebase authentication and storage
- ✅ Resend email service
- ✅ AI-powered features
- ✅ Mobile-responsive design
- ✅ PWA capabilities

### Next Steps

1. **Monitor Performance**: Use Vercel Analytics
2. **Set up Alerts**: Configure monitoring alerts
3. **Scale if Needed**: Upgrade Vercel plan for higher limits
4. **Add Features**: Continue developing with automatic deployments