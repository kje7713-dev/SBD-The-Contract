#!/bin/bash
# Custom build orchestrator for The Contract iOS app

set -euo pipefail

log_step() {
    echo "▶ $1"
}

setup_build_environment() {
    log_step "Configuring build environment"
    export BUILD_TIMESTAMP=$(date +%Y%m%d%H%M%S)
    export IPA_OUTPUT_DIR="./dist"
    mkdir -p "$IPA_OUTPUT_DIR"
}

generate_xcode_workspace() {
    log_step "Generating Xcode workspace from spec"
    if command -v xcodegen &> /dev/null; then
        xcodegen generate --spec project_definition.yml
    else
        echo "Error: xcodegen not installed"
        exit 1
    fi
}

configure_signing() {
    log_step "Setting up code signing"
    
    # Create isolated keychain for CI
    KEYCHAIN_NAME="contract_build_chain"
    KEYCHAIN_PASS="${SIGNING_PASSPHRASE:-temp123}"
    
    security create-keychain -p "$KEYCHAIN_PASS" "$KEYCHAIN_NAME"
    security set-keychain-settings -lut 21600 "$KEYCHAIN_NAME"
    security unlock-keychain -p "$KEYCHAIN_PASS" "$KEYCHAIN_NAME"
    security list-keychains -d user -s "$KEYCHAIN_NAME"
    
    # Import certificates from match repo
    bundle exec fastlane run sync_code_signing \
        type:appstore \
        readonly:true \
        git_url:"$CERTS_GIT_URL" \
        git_basic_authorization:"$(echo -n "x:$CERTS_TOKEN" | base64)" \
        app_identifier:"com.savagesbydesign.thecontract" \
        keychain_name:"$KEYCHAIN_NAME" \
        keychain_password:"$KEYCHAIN_PASS"
}

compile_application() {
    log_step "Compiling application binary"
    
    # Update build number with timestamp
    /usr/libexec/PlistBuddy -c "Set :CFBundleVersion $BUILD_TIMESTAMP" "AppConfig.plist"
    
    xcodebuild archive \
        -scheme "ContractApp" \
        -archivePath "$IPA_OUTPUT_DIR/TheContract.xcarchive" \
        -configuration Release \
        CODE_SIGN_STYLE=Manual \
        CODE_SIGN_IDENTITY="Apple Distribution" \
        DEVELOPMENT_TEAM="$APPLE_DEV_TEAM" \
        PROVISIONING_PROFILE_SPECIFIER="match AppStore com.savagesbydesign.thecontract"
    
    log_step "Creating IPA package"
    xcodebuild -exportArchive \
        -archivePath "$IPA_OUTPUT_DIR/TheContract.xcarchive" \
        -exportPath "$IPA_OUTPUT_DIR" \
        -exportOptionsPlist export_config.plist
}

upload_to_testflight() {
    log_step "Uploading to TestFlight"
    
    xcrun altool --upload-app \
        --type ios \
        --file "$IPA_OUTPUT_DIR/TheContract.ipa" \
        --apiKey "$ASC_API_KEY_ID" \
        --apiIssuer "$ASC_API_ISSUER" \
        --verbose
}

cleanup_keychain() {
    log_step "Cleaning up build keychain"
    security delete-keychain "contract_build_chain" || true
}

main() {
    setup_build_environment
    generate_xcode_workspace
    configure_signing
    compile_application
    upload_to_testflight
    cleanup_keychain
    
    log_step "✓ Build and deployment complete"
}

trap cleanup_keychain EXIT
main
