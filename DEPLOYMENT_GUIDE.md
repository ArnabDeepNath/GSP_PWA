# GSTSync - PWA Deployment Guide

This guide explains how to deploy your GSTSync Flutter app as a Progressive Web App (PWA) on GitHub Pages.

## 📋 Prerequisites

1. **GitHub Account**: Make sure you have a GitHub account
2. **Flutter SDK**: Ensure Flutter is installed on your local machine
3. **Git**: Have Git installed and configured

## 🚀 Step-by-Step Deployment

### 1. Create a GitHub Repository

1. Go to [GitHub](https://github.com) and create a new repository
2. Name it (e.g., `gstsync-app`)
3. Make it **public** (required for free GitHub Pages)
4. Don't initialize with README (since you already have the code)

### 2. Initialize Git and Push Your Code

Open a terminal in your project directory and run:

```bash
# Initialize git repository (if not already done)
git init

# Add all files
git add .

# Commit the changes
git commit -m "Initial commit - PWA setup complete"

# Add your GitHub repository as remote (replace with your repository URL)
git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPO_NAME.git

# Push to GitHub
git branch -M main
git push -u origin main
```

### 3. Enable GitHub Pages

1. Go to your repository on GitHub
2. Click on **Settings** tab
3. Scroll down to **Pages** section in the left sidebar
4. Under **Source**, select:
   - Source: **GitHub Actions**
5. The workflow will automatically trigger on push to main branch

### 4. Wait for Deployment

1. Go to the **Actions** tab in your repository
2. You'll see the "Deploy to GitHub Pages" workflow running
3. Wait for it to complete (usually 2-5 minutes)
4. Once complete, your app will be live at: `https://YOUR_USERNAME.github.io/YOUR_REPO_NAME/`

## 🔧 Building Locally

To test the web build locally before deploying:

```bash
# Build the web app
flutter build web --release

# The output will be in build/web directory
# You can serve it locally using:
flutter run -d chrome
# or
cd build/web
python -m http.server 8000
# Then open http://localhost:8000 in your browser
```

## 🌐 Accessing Your PWA

After successful deployment, your app will be available at:

```
https://YOUR_USERNAME.github.io/YOUR_REPO_NAME/
```

### Installing as PWA

Users can install your app on their devices:

**Desktop (Chrome/Edge):**

1. Visit your app URL
2. Look for the install icon in the address bar (⊕)
3. Click "Install"

**Mobile (Android/iOS):**

1. Visit your app URL in Chrome/Safari
2. Tap the browser menu (⋮ or Share icon)
3. Select "Add to Home Screen" or "Install App"

## 🔄 Updating Your App

When you make changes to your app:

```bash
# Make your changes, then:
git add .
git commit -m "Description of your changes"
git push

# The GitHub Action will automatically rebuild and redeploy
```

## ⚙️ Configuration Details

### Base URL Configuration

The app is configured to work with GitHub Pages subdirectory hosting. The build command includes:

```
--base-href "/${{ github.event.repository.name }}/"
```

This ensures all assets load correctly from the subdirectory.

### Firebase Configuration

**Important:** Make sure your Firebase project is properly configured:

1. **Firebase Console**:

   - Go to Firebase Console
   - Select your project
   - Go to Authentication → Settings → Authorized domains
   - Add your GitHub Pages domain: `YOUR_USERNAME.github.io`

2. **Firestore Security Rules**:
   - Ensure your security rules allow web access
   - Update if needed for production use

## 🔐 Security Considerations

1. **API Keys**: Your Firebase configuration is public in the web build. This is normal for web apps, but ensure:

   - Firebase Security Rules are properly configured
   - API key restrictions are set in Google Cloud Console
   - Only allow your domain in Firebase authorized domains

2. **HTTPS**: GitHub Pages serves over HTTPS by default ✓

## 🛠️ Troubleshooting

### Build Fails

- Check the Actions tab for error details
- Ensure all dependencies in `pubspec.yaml` are web-compatible
- Verify Firebase configuration is correct

### App Doesn't Load

- Check browser console for errors
- Verify the base-href is correct
- Ensure Firebase domains are authorized

### Icons Don't Show

- Make sure `assets/images/logo.png` exists
- Run `flutter pub run flutter_launcher_icons` before pushing

## 📱 PWA Features Enabled

Your app now includes:

- ✅ Install to home screen capability
- ✅ Offline fallback page
- ✅ App manifest for metadata
- ✅ Service worker for caching
- ✅ Responsive design optimizations
- ✅ iOS and Android PWA support

## 🎨 Customization

### Change App Name/Colors

Edit `web/manifest.json`:

```json
{
  "name": "Your App Name",
  "short_name": "Short Name",
  "theme_color": "#YOUR_COLOR",
  "background_color": "#YOUR_BG_COLOR"
}
```

### Update Meta Tags

Edit `web/index.html` to customize:

- Title
- Description
- Keywords
- Theme colors

## 📊 Analytics (Optional)

Consider adding:

- Google Analytics for web
- Firebase Analytics (already configured)

## 🌟 Next Steps

1. **Custom Domain** (Optional):

   - You can use a custom domain instead of github.io
   - Configure in Repository Settings → Pages → Custom domain

2. **Performance Monitoring**:

   - Use Lighthouse in Chrome DevTools
   - Optimize images and assets
   - Monitor Firebase usage

3. **Testing**:
   - Test on multiple devices and browsers
   - Verify PWA installation works
   - Check offline functionality

## 📞 Support

If you encounter issues:

1. Check GitHub Actions logs
2. Review Firebase Console for authentication issues
3. Test locally with `flutter run -d chrome`
4. Check browser console for runtime errors

---

**Repository Structure:**

```
gspappv2/
├── .github/
│   └── workflows/
│       └── deploy.yml        # GitHub Actions workflow
├── web/
│   ├── index.html            # Enhanced PWA HTML
│   ├── manifest.json         # PWA manifest
│   ├── offline.html          # Offline fallback
│   └── icons/                # App icons
├── lib/                      # Flutter app code
└── pubspec.yaml             # Dependencies
```

Enjoy your PWA! 🎉
