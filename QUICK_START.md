# GSTSync PWA - Quick Reference

## 🚀 Quick Deploy Commands

### First Time Setup

```bash
# 1. Create GitHub repository (do this on GitHub.com)
# 2. Initialize and push your code:

git init
git add .
git commit -m "Initial commit - PWA ready"
git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPO_NAME.git
git branch -M main
git push -u origin main
```

### Enable GitHub Pages

1. Go to repo **Settings** → **Pages**
2. Set Source to **GitHub Actions**
3. Done! Your app will deploy automatically

## 🔧 Local Testing

```bash
# Test web build locally
flutter run -d chrome

# Or build and serve
flutter build web --release
cd build/web
python -m http.server 8000
# Open http://localhost:8000
```

## 📝 Update & Redeploy

```bash
# After making changes:
git add .
git commit -m "Your changes description"
git push
# Auto-deploys via GitHub Actions!
```

## 🌐 Your App URLs

After deployment, your app will be at:

- **Live URL**: `https://YOUR_USERNAME.github.io/YOUR_REPO_NAME/`
- **GitHub Actions**: Check deploy status in Actions tab

## ⚡ Important Notes

### Firebase Setup

Add your GitHub Pages domain to Firebase:

1. Firebase Console → Authentication → Settings
2. Authorized domains → Add: `YOUR_USERNAME.github.io`

### Web Icons

Generate web icons (if you update logo.png):

```bash
flutter pub run flutter_launcher_icons
```

### Environment Check

```bash
# Verify Flutter web is enabled
flutter devices  # Should show Chrome/Edge

# Check dependencies
flutter doctor -v

# Clean and rebuild if issues
flutter clean
flutter pub get
flutter build web --release
```

## 📱 PWA Installation

Users can install your app:

**Desktop:**

- Visit your URL
- Click install icon in address bar (⊕)

**Mobile:**

- Visit in Chrome/Safari
- Menu → "Add to Home Screen"

## 🔍 Debugging

### Build locally first

```bash
flutter build web --release --base-href "/YOUR_REPO_NAME/"
```

### Check for errors

- Browser DevTools → Console
- GitHub Actions tab for build logs
- Firebase Console for auth issues

## 📊 Files Modified for PWA

- ✅ `web/manifest.json` - App metadata
- ✅ `web/index.html` - PWA features & SEO
- ✅ `web/offline.html` - Offline fallback
- ✅ `.github/workflows/deploy.yml` - Auto deployment
- ✅ `pubspec.yaml` - Web icon colors

## 🎯 Checklist

- [ ] Create GitHub repository
- [ ] Push code to GitHub
- [ ] Enable GitHub Pages (Actions)
- [ ] Add domain to Firebase authorized domains
- [ ] Wait for deployment (~3-5 min)
- [ ] Test your live app
- [ ] Install as PWA
- [ ] Share your URL!

## 🆘 Common Issues

**Build fails:**

```bash
flutter clean
flutter pub get
flutter build web --release
```

**Icons missing:**

```bash
flutter pub run flutter_launcher_icons
git add .
git commit -m "Update icons"
git push
```

**Firebase auth fails:**

- Add `YOUR_USERNAME.github.io` to Firebase authorized domains

**App doesn't load:**

- Check if base-href matches your repo name
- Verify in `.github/workflows/deploy.yml`

---

📖 For detailed guide, see [DEPLOYMENT_GUIDE.md](DEPLOYMENT_GUIDE.md)
