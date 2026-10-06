# Releasing to Google Play

Releases run in GitHub Actions (`.github/workflows/release.yml`) whenever a
version tag is pushed:

```sh
git tag v1.2.0
git push origin v1.2.0
```

The workflow runs analyze and tests, builds a signed app bundle (AAB) and
APK, checks that the bundle is signed with the upload key (not the debug
key), stores both as a workflow artifact and uploads the AAB to Google Play.

- **versionName** comes from the tag: `v1.2.0` → `1.2.0`.
- **versionCode** is derived from it: `major * 1 000 000 + minor * 1 000 + patch`
  (`v1.2.0` → `1002000`). Every release therefore needs a new, higher tag;
  minor and patch must stay below 1000. The `version:` in `pubspec.yaml`
  only applies to local builds.
- Default track is **internal**. Promoting to closed testing or production
  stays a manual step in the Play Console.

Nothing secret lives in the repository. The keystore and
`android/key.properties` are written from secrets into the runner at build
time and deleted afterwards (`key.properties`, `*.jks` and `*.keystore` are
git-ignored). GitHub masks secret values in logs.

## One-time setup

### 1. Play Console

1. Create a developer account at <https://play.google.com/console>.
2. Create the app with package name `space.mai.mai_doctor_hub`.
3. Complete the store listing, privacy policy URL, Data safety form and the
   health app declaration.
4. Upload the **first** AAB manually (Google requires this before the API
   can upload). Build it locally with the upload key or take it from the
   artifact of a first workflow run.
5. New personal developer accounts must run a closed test with at least
   12 testers for 14 days before production access is granted.

### 2. Upload key

Create the upload keystore once and keep it (and its passwords) safe,
e.g. in a password manager — never commit it:

```sh
keytool -genkeypair -v -keystore upload-keystore.jks -storetype JKS \
  -keyalg RSA -keysize 2048 -validity 10000 -alias upload
base64 -w0 upload-keystore.jks > upload-keystore.jks.b64   # macOS: base64 -i upload-keystore.jks
```

Use Play App Signing (default for new apps): Google keeps the app signing
key, this keystore is only the upload key and can be reset via Play support
if lost.

### 3. Service account for the Play API

1. In Google Cloud, create (or pick) a project and enable the
   **Google Play Android Developer API**.
2. Create a service account and a JSON key for it.
3. In the Play Console under **Users and permissions**, invite the service
   account's e-mail and grant it release permissions for this app.

### 4. GitHub secrets and variables

Repository → **Settings → Environments → New environment** `play-store`.
Optionally add **Required reviewers** so every upload needs an approval.
Add these as **environment secrets** (repository secrets work too):

| Secret | Content |
| --- | --- |
| `ANDROID_KEYSTORE_BASE64` | content of `upload-keystore.jks.b64` |
| `ANDROID_KEYSTORE_PASSWORD` | keystore password |
| `ANDROID_KEY_ALIAS` | key alias (`upload` in the example) |
| `ANDROID_KEY_PASSWORD` | key password |
| `PLAY_SERVICE_ACCOUNT_JSON` | full content of the service account JSON key |

Optional **variables** (not secret):

| Variable | Default | Meaning |
| --- | --- | --- |
| `PLAY_TRACK` | `internal` | `internal`, `alpha`, `beta` or `production` |
| `PLAY_RELEASE_STATUS` | `draft` | set to `completed` once the app has been published at least once; until then Play only accepts drafts |

Delete the local `.b64` file after saving the secret.

## Manual run

**Actions → Release → Run workflow**, choose the tag under
*Use workflow from* and optionally a track. Runs on a branch are rejected.
