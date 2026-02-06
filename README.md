# The Contract - iOS App

A SwiftUI application by Savage By Design with automated TestFlight deployment.

## TestFlight Deployment

### Triggering from Mobile Device

You can deploy directly to TestFlight from your phone:

1. Open GitHub mobile app or browser at: `https://github.com/<your-username>/SBD-The-Contract`
2. Navigate to **Actions** tab
3. Select **TestFlight Deployment** workflow
4. Tap **Run workflow** button
5. (Optional) Add build notes in the text field
6. Tap green **Run workflow** to start
7. Monitor progress in the Actions tab
8. Build appears in TestFlight within 10-15 minutes after completion

### Required GitHub Secrets

Configure these secrets in your repository settings (`Settings` → `Secrets and variables` → `Actions` → `New repository secret`):

| Secret Name | Description | Example/Format |
|-------------|-------------|----------------|
| `APPLE_TEAM_ID` | Your Apple Developer Team ID | `A1B2C3D4E5` |
| `APP_IDENTIFIER` | App bundle identifier | `com.savagesbydesign.thecontract` |
| `MATCH_GIT_URL` | Certificate repository URL | `https://github.com/username/ios-certificates` |
| `MATCH_GIT_TOKEN` | GitHub Personal Access Token | `ghp_xxxxxxxxxxxx` |
| `MATCH_PASSWORD` | Encryption password for certificates | `your-secure-password` |
| `ASC_KEY_ID` | App Store Connect API Key ID | `ABCD1234EF` |
| `ASC_ISSUER_ID` | App Store Connect Issuer ID | `12345678-1234-1234-1234-123456789012` |
| `ASC_KEY` | App Store Connect Private Key (base64 or PEM) | `-----BEGIN PRIVATE KEY-----\n...` |
| `IOS_SCHEME` | Xcode scheme name | `TheContract` |

### Setting Up Secrets

**Getting App Store Connect API Keys:**
1. Go to [App Store Connect](https://appstoreconnect.apple.com)
2. Navigate to Users and Access → Keys
3. Create new key with App Manager access
4. Download the `.p8` file immediately (only available once)
5. Note the Key ID and Issuer ID
6. Convert to base64: `base64 -i AuthKey_KEYID.p8 | pbcopy`

**Setting Up Match (Certificate Management):**
1. Create a private GitHub repository for certificates
2. Generate a Personal Access Token with `repo` scope
3. Run locally once: `bundle exec fastlane match init`
4. Choose git storage and provide repository URL
5. Set a strong encryption password

### Local Development

```bash
# Install dependencies
bundle install
brew install xcodegen

# Generate Xcode project
xcodegen generate --spec project.yml

# Open project
open TheContractApp.xcodeproj

# Build and run
xcodebuild -scheme TheContract -configuration Debug
```

### Project Structure

```
├── ApplicationBootstrap.swift    # Main app entry point
├── ContractAssets.xcassets       # App icons and assets
├── LaunchScreen.storyboard       # Launch screen UI
├── PrivacyInfo.xcprivacy         # Privacy manifest
├── project.yml                   # XcodeGen specification
├── Gemfile                       # Ruby dependencies
├── fastlane/
│   └── Fastfile                  # Deployment automation
└── .github/workflows/
    └── ios-testflight.yml        # GitHub Actions workflow
```

### Troubleshooting

**Build fails with "No code signing identities found":**
- Verify `MATCH_GIT_URL` points to valid repository
- Ensure `MATCH_GIT_TOKEN` has correct permissions
- Check `MATCH_PASSWORD` is correct
- Run `bundle exec fastlane match appstore` locally to verify setup

**API authentication errors:**
- Confirm `ASC_KEY` is properly formatted (base64 or PEM with newlines)
- Verify `ASC_KEY_ID` and `ASC_ISSUER_ID` match your key
- Ensure key hasn't been revoked in App Store Connect

**Build succeeds but doesn't appear in TestFlight:**
- Check App Store Connect for processing status
- Verify app has been created in App Store Connect
- Ensure `APP_IDENTIFIER` matches exactly
- Review App Store Connect email for compliance issues

### Version Management

- Marketing Version: `1.0.0` (set in `project.yml`)
- Build Number: Auto-generated timestamp format `YYYYMMDDHHmm`
- Each deployment creates unique build number to avoid conflicts

### Technical Details

- **iOS Deployment Target:** 17.0
- **Swift Version:** 5.9
- **Code Signing:** Manual with Fastlane Match
- **CI/CD:** GitHub Actions on macOS runners
- **Project Generation:** XcodeGen for reproducible project files

---

**Savage By Design** © 2024
