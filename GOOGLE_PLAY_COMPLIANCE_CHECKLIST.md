# Google Play Compliance Checklist

## ✅ Changes Completed

### AndroidManifest.xml

- [x] Removed `MANAGE_EXTERNAL_STORAGE` permission
- [x] Removed `READ_MEDIA_IMAGES`, `READ_MEDIA_VIDEO`, `READ_MEDIA_AUDIO` permissions
- [x] Limited `READ_EXTERNAL_STORAGE` to Android 12 and below (maxSdkVersion="32")
- [x] Limited `WRITE_EXTERNAL_STORAGE` to Android 10 and below (maxSdkVersion="29")
- [x] Removed `android:requestLegacyExternalStorage="true"`
- [x] Removed `android:preserveLegacyExternalStorage="true"`

### Dart Code (home_page.dart)

- [x] Updated `_requestStoragePermission()` to remove MANAGE_EXTERNAL_STORAGE requests
- [x] Updated permission logic to use scoped storage for Android 10+
- [x] Maintained compatibility with Android 9 and below using basic storage permission

## 📋 Pre-Submission Checklist

### Build & Test

- [ ] Run `flutter clean`
- [ ] Run `flutter pub get`
- [ ] Build release APK: `flutter build apk --release`
- [ ] Build release AAB: `flutter build appbundle --release`

### Testing on Different Android Versions

- [ ] Test on Android 13+ (API 33+): File import/export should work without permission prompts
- [ ] Test on Android 11-12 (API 30-32): System file picker should open for file operations
- [ ] Test on Android 10 (API 29): Scoped storage should work seamlessly
- [ ] Test on Android 9 and below (API 28-): Should request storage permission only when needed

### Functional Testing

- [ ] Import CSV files (parties)
- [ ] Import CSV files (invoices)
- [ ] Export sample CSV files
- [ ] Download generated PDFs
- [ ] Share files via share_plus

### Verify Manifest

- [ ] Open `android/app/src/main/AndroidManifest.xml`
- [ ] Confirm NO `MANAGE_EXTERNAL_STORAGE` permission exists
- [ ] Confirm NO media permissions (IMAGES/VIDEO/AUDIO) exist
- [ ] Confirm storage permissions have maxSdkVersion attributes

## 📤 Google Play Submission

### Response to Google Play Team (if needed)

Use this template when responding to the review:

```
Dear Google Play Review Team,

We have updated our app to comply with the storage permission policy:

CHANGES MADE:
1. Removed MANAGE_EXTERNAL_STORAGE permission completely
2. Removed unnecessary media permissions (READ_MEDIA_IMAGES, READ_MEDIA_VIDEO, READ_MEDIA_AUDIO)
3. Updated to use scoped storage and Storage Access Framework (SAF)
4. Limited legacy storage permissions to appropriate SDK versions

FILE ACCESS IMPLEMENTATION:
- Our app works with CSV files (not media files)
- We use the system file picker (Storage Access Framework) for all file operations
- Users explicitly select files/folders through the system picker
- No broad file system access is requested or needed

PERMISSIONS NOW USED:
- READ_EXTERNAL_STORAGE (only for Android 12 and below, maxSdkVersion="32")
- WRITE_EXTERNAL_STORAGE (only for Android 9 and below, maxSdkVersion="29")
- For Android 10+: No storage permissions needed, uses scoped storage and SAF

The app's core functionality (GST filing and invoice management with CSV import/export) works perfectly with these changes.

Thank you for your review.
```

## 🔍 Verification Commands

Run these commands to verify the build:

```bash
# Clean build
flutter clean

# Get dependencies
flutter pub get

# Build release bundle for Google Play
flutter build appbundle --release

# Check the output file
# Location: build/app/outputs/bundle/release/app-release.aab
```

## 📱 Manual Verification

After building, manually verify the AndroidManifest.xml in the APK/AAB:

1. Extract the AAB file (it's a zip file)
2. Navigate to `base/manifest/AndroidManifest.xml`
3. Use Android Studio or aapt2 to read the binary XML
4. Confirm MANAGE_EXTERNAL_STORAGE is NOT present

Alternative using bundletool:

```bash
bundletool dump manifest --bundle=app-release.aab
```

## ✅ Ready for Submission

When all checkboxes above are completed, your app is ready for Google Play submission!

## 📚 Additional Resources

- [Android Scoped Storage Guide](https://developer.android.com/training/data-storage)
- [Storage Access Framework](https://developer.android.com/guide/topics/providers/document-provider)
- [Google Play Storage Permissions Policy](https://support.google.com/googleplay/android-developer/answer/10467955)
