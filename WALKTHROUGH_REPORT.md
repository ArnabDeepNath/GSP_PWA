# GSTSync (GSP PWA) - User Walkthrough & Documentation

## 1. Introduction

GSTSync is a comprehensive Progressive Web App (PWA) designed to simplify GST filing, invoice management, and business reporting. As a PWA, it combines the reach of the web with the capabilities of a native app, allowing users to install it on desktops, tablets, and mobile devices directly from the browser.

**Live Application:** [https://ArnabDeepNath.github.io/GSP_PWA/](https://ArnabDeepNath.github.io/GSP_PWA/)

## 2. Key Features

- **Cross-Platform Accessibility:** Works seamlessly on Windows, macOS, Android, and iOS.
- **Offline Capability:** Core features remain accessible even without an active internet connection.
- **Invoice Management:** Create, edit, and manage GST-compliant invoices.
- **Party Management:** Maintain a database of customers and suppliers.
- **Inventory & Items:** Track products, services, HSN/SAC codes, and stock levels.
- **Reports:** Generate detailed financial reports and GST filing summaries.
- **Secure Authentication:** Firebase-powered secure login and data protection.

## 3. Getting Started

### 3.1 Installation

Since GSTSync is a PWA, installation is simple across all devices:

- **Chrome (Desktop/Android):** Look for the "Install GSTSync" icon in the address bar or select "Install App" / "Add to Home Screen" from the browser menu.
- **Safari (iOS):** Tap the "Share" button and select "Add to Home Screen."

### 3.2 Registration & Login

1.  Launch the app.
2.  If new, click **"Register"** to create an account with your email and password.
3.  Existing users can simply log in with their credentials.

## 4. Module Walkthrough

### 4.1 Dashboard (Home)

The landing page provides a quick snapshot of business health:

- **Quick Actions:** Shortcuts to Create Invoice, Add Party, etc.
- **Recent Activity:** List of recently created invoices or updated parties.
- **Financial Summary:** Quick view of sales, purchases, and outstanding amounts.

### 4.2 Party Management

Located in the "Parties" tab:

- **Add Party:** Click the "+" button to add a new customer or supplier.
- **Details:** Capture Name, GSTIN, Address, Contact details.
- **Party Ledger:** View transaction history and outstanding balance for each party.

### 4.3 Item Master

Manage your product catalog in the "Items" section:

- **Add Item:** Define Name, Unit, Purchase Price, Selling Price, Tax Rate, and HSN Code.
- **Inventory:** Track current stock levels (if enabled).

### 4.4 Invoicing

The core feature for daily operations:

- **Create Invoice:** Select a Party, add Items (auto-calc tax & totals), set Invoice Date.
- **Preview:** View the invoice in a professional format before finalizing.
- **Save/Print:** Save to database or print/download as PDF.

### 4.5 Reports

Access critical business insights:

- **GSTR Reports:** Generate data for GSTR-1 (Sales) and GSTR-3B filings.
- **Sales/Purchase Registers:** Detailed lists of all transactions for a specific period.
- **Stock Reports:** Current inventory valuation and status.

## 5. Technical Overview for Developers

### 5.1 Architecture

- **Framework:** Flutter (Web)
- **State Management:** BLoC / Provider
- **Backend:** Firebase (Firestore, Authentication)
- **Hosting:** GitHub Pages via GitHub Actions

### 5.2 Deployment Pipeline

The project uses automated CI/CD:

1.  Code is pushed to the `main` branch.
2.  GitHub Action `deploy.yml` triggers.
3.  Flutter builds the web release (`flutter build web --release`).
4.  Artifacts are deployed to the `gh-pages` branch.

## 6. Support & Feedback

For issues, feature requests, or support, please open an issue in the GitHub repository or contact the administration team.

---

_Generated: February 09, 2026_
