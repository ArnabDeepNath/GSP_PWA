# 📱 GSTSync - GST Filing & Invoice Management PWA

[![Deploy to GitHub Pages](https://github.com/ArnabDeepNath/GSP_PWA/actions/workflows/deploy.yml/badge.svg)](https://github.com/ArnabDeepNath/GSP_PWA/actions/workflows/deploy.yml)

A Progressive Web App (PWA) built with Flutter for managing GST filing, invoices, parties, items, and generating comprehensive reports.

## 🌐 Live Demo

**Access the app:** [https://YOUR_USERNAME.github.io/YOUR_REPO_NAME/](https://YOUR_USERNAME.github.io/YOUR_REPO_NAME/)

## ✨ Features

- 📊 **Dashboard** - Overview of your business metrics
- 🧾 **Invoice Management** - Create and manage invoices
- 👥 **Party Management** - Manage customers and suppliers
- 📦 **Item Management** - Track products and services
- 📈 **Reports & Analytics** - GST reports, sales analysis
- 💾 **Cloud Sync** - Firebase integration for data backup
- 📱 **PWA Support** - Install on any device
- 🔒 **Secure** - Firebase authentication

## 🚀 Installation

### As a Web App

Simply visit the URL and start using immediately!

### As a Progressive Web App

**Desktop (Chrome/Edge/Brave):**

1. Visit the app URL
2. Click the install icon (⊕) in the address bar
3. Click "Install"

**Mobile (Android):**

1. Open in Chrome
2. Tap menu (⋮) → "Add to Home screen"

**Mobile (iOS):**

1. Open in Safari
2. Tap Share → "Add to Home Screen"

## 🛠️ Technology Stack

- **Framework:** Flutter 3.24.0
- **Backend:** Firebase (Auth, Firestore)
- **State Management:** flutter_bloc, Provider
- **UI Components:** Material Design
- **Charts:** fl_chart, syncfusion_flutter_charts
- **PDF Generation:** pdf, printing packages
- **Storage:** Cloud Firestore, Shared Preferences

## 📖 Documentation

- [Deployment Guide](DEPLOYMENT_GUIDE.md) - Complete deployment instructions
- [Quick Start](QUICK_START.md) - Quick reference for common tasks

## 🔧 Development

### Prerequisites

- Flutter SDK (>=3.1.3)
- Dart SDK
- Firebase account
- Git

### Setup

```bash
# Clone the repository
git clone https://github.com/ArnabDeepNath/GSP_PWA.git
cd YOUR_REPO_NAME

# Install dependencies
flutter pub get

# Run on Chrome
flutter run -d chrome

# Build for web
flutter build web --release
```

### Project Structure

```
lib/
├── config/          # App configuration
├── core/            # Core utilities and widgets
├── features/        # Feature modules
│   ├── auth/        # Authentication
│   ├── home/        # Dashboard
│   ├── invoice/     # Invoice management
│   ├── party/       # Party management
│   ├── item/        # Item management
│   ├── reports/     # Reports & analytics
│   └── settings/    # App settings
└── main.dart        # App entry point
```

## 🔐 Firebase Configuration

This app uses Firebase for:

- User authentication
- Cloud data storage
- Real-time synchronization

**Important:** Configure Firebase authorized domains:

1. Go to Firebase Console
2. Authentication → Settings → Authorized domains
3. Add your GitHub Pages domain

## 📱 PWA Features

- ✅ Offline fallback page
- ✅ Installable on all platforms
- ✅ App manifest with metadata
- ✅ Service worker for caching
- ✅ Responsive design
- ✅ Fast loading times

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 📞 Support

For issues and questions:

- Open an issue on GitHub
- Check the [Deployment Guide](DEPLOYMENT_GUIDE.md)
- Review [Quick Start](QUICK_START.md)

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Firebase for backend services
- All open-source package contributors

---

**Built with ❤️ using Flutter**

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)
![PWA](https://img.shields.io/badge/PWA-5A0FC8?style=for-the-badge&logo=pwa&logoColor=white)
