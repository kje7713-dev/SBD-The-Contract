# Unity License Activation Guide

## Overview

This repository uses GitHub Actions for Unity CI/CD. To use Unity in automated builds, you need to activate a Unity license.

## Activation Process

### Option 1: Using the Workflow (Automated ALF Generation)

This method uses the deprecated but still functional workflow to generate an activation file.

1. **Generate Activation File**
   - Go to the "Actions" tab in your repository
   - Select "Unity Activation (Generate ALF)" workflow
   - Click "Run workflow"
   - Wait for the workflow to complete

2. **Download the Activation File**
   - Once the workflow completes, download the artifact (`.alf` file)
   
3. **Request License from Unity**
   - Visit https://license.unity3d.com/manual
   - Upload the `.alf` file
   - Select your license type (Personal/Plus/Pro)
   - Download the returned `.ulf` license file

4. **Add License to Repository Secrets**
   - Open the `.ulf` file in a text editor
   - Copy the entire contents
   - Go to your repository's Settings → Secrets and variables → Actions
   - Create a new secret named `UNITY_LICENSE`
   - Paste the `.ulf` file contents as the value

### Option 2: Manual Activation (Recommended for New Projects)

The modern approach recommended by GameCI:

1. **Install Unity Hub** on your local machine

2. **Activate Unity Locally**
   - Open Unity Hub
   - Sign in with your Unity account
   - Activate your license (Personal/Plus/Pro)

3. **Locate the License File**
   - **Windows**: `C:\ProgramData\Unity\Unity_lic.ulf`
   - **macOS**: `/Library/Application Support/Unity/Unity_lic.ulf`
   - **Linux**: `~/.local/share/unity3d/Unity/Unity_lic.ulf`

4. **Add License to Repository Secrets**
   - Open the `.ulf` file in a text editor
   - Copy the entire contents
   - Go to your repository's Settings → Secrets and variables → Actions
   - Create a new secret named `UNITY_LICENSE`
   - Paste the `.ulf` file contents as the value

## Additional Required Secrets

For Unity activation to work properly in CI/CD (especially with GameCI v4+), you also need to set:

- `UNITY_EMAIL`: Your Unity account email
- `UNITY_PASSWORD`: Your Unity account password

These should be added as repository secrets alongside `UNITY_LICENSE`.

## Important Notes

- **Personal Licenses**: Unity has deprecated manual activation for Personal licenses. If you encounter issues with the automated workflow, use Option 2 (manual activation).
- **Professional Licenses**: Both methods work, but you'll need your serial key.
- **License Expiration**: Licenses need to be renewed periodically. Update your secrets when your license changes.

## Troubleshooting

### Workflow Fails to Generate ALF File

The automated workflow uses a deprecated action that may not work with all Unity versions or in all scenarios. If it fails:
- Try Option 2 (manual activation) instead
- Check the [GameCI documentation](https://game.ci/docs/github/activation) for the latest guidance

### Build Fails with License Error

If your builds fail with license-related errors:
- Verify that `UNITY_LICENSE`, `UNITY_EMAIL`, and `UNITY_PASSWORD` secrets are set correctly
- Ensure the license matches the Unity version in your project
- Check that your license hasn't expired

## More Information

- [GameCI Official Documentation](https://game.ci/docs)
- [GameCI Activation Guide](https://game.ci/docs/github/activation)
- [Unity License Types](https://unity.com/products/compare-plans)
