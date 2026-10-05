# App Signing Guide for Mai Doctor Hub

This guide explains how to set up release signing for the Android app.

## Requirements

You need:
- A private keystore file (`.jks`) with your signing key
- The keystore password
- The key alias
- The key password

## Step 1: Generate a Release Keystore

If you don't have a keystore yet, generate one:

```bash
keytool -genkey -v -keystore ~/mai-doctor-hub-release.jks \
  -keyalg RSA -keysize 2048 -validity 10950 \
  -alias mai_doctor_hub -storetype JKS
```

You'll be prompted for:
- Keystore password (remember this)
- Key password (can be same as keystore password)
- Your name, organization, location, etc.

**Important:** Store this keystore file securely and back it up. Without it, you cannot update your app on Play Store.

## Step 2: Configure Gradle

Create `android/key.properties` with your keystore details:

```properties
storeFile=path/to/your/mai-doctor-hub-release.jks
storePassword=your-keystore-password
keyAlias=mai_doctor_hub
keyPassword=your-key-password
```

**Security Note:** Do NOT commit `key.properties` to version control. Add it to `.gitignore`:

```bash
echo "android/key.properties" >> .gitignore
```

## Step 3: Update build.gradle.kts

The app is already configured to use `key.properties` if it exists. Build signing is automatically enabled when the file is present.

## Step 4: Build Signed Release APK

```bash
flutter build apk --release
```

Output: `build/app/outputs/flutter-app.apk`

## Step 5: Build Signed Bundle (for Play Store)

```bash
flutter build appbundle --release
```

Output: `build/app/outputs/bundle/release/app-release.aab`

## Upload to Play Store

1. Go to [Google Play Console](https://play.google.com/console)
2. Create or select your app
3. Navigate to "Release" → "Production"
4. Upload the `.aab` bundle
5. Review the changes and publish

## Verification

To verify your app is properly signed:

```bash
jarsigner -verify -verbose build/app/outputs/flutter-app.apk
```

## Troubleshooting

### "key.properties not found"
Make sure the file is at `android/key.properties` relative to the project root.

### "Invalid keystore format"
Ensure the keystore file path in `key.properties` is correct and the file is not corrupted.

### "Wrong password"
Double-check both `storePassword` and `keyPassword` in `key.properties`.

## AppBundle Signing Details

When uploading to Play Store, Google performs additional signing:
- You sign with your app signing key (in `.jks`)
- Google re-signs with the "app signing certificate" before distribution
- Users receive the app signed by Google's certificate

This separation allows:
- Secure key management (your key stays with you)
- Fast Play Store deployment (Google handles re-signing)
- Key rotation without app updates (advanced feature)

## Certificate Validity

The example keystore above is valid for 10,950 days (~30 years). Before expiry:

1. Generate a new keystore
2. Upload key rotation certificate to Play Store (requires owner/admin access)
3. Future builds use the new key; users receive seamlessly updated app

For details, see [Google Play key rotation](https://developer.android.com/studio/publish/app-signing#key-rotation).
