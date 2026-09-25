
## 1.0.12

### 🐛 Bug Fixes

#### Android
- Changed `FileProvider` authority from `${applicationId}.fileprovider` to `${applicationId}.github_release_apk_updater.fileprovider`
- Fixes manifest merger conflict when host app declares its own `FileProvider` with a different `android:resource` (error: `Failed to find configured root that contains ...`)
- No changes required in the host app `AndroidManifest.xml`

---

## 1.0.11

### 🐛 Bug Fixes

#### Android
- Removed `FileProvider` declaration from plugin `AndroidManifest.xml` to fix manifest merger conflict with host apps that declare their own `FileProvider` (error: `Attribute meta-data#android.support.FILE_PROVIDER_PATHS@resource ... is also present`)
- The plugin no longer owns a `FileProvider`; the host app is responsible for declaring it with its own `provider_paths`

---

## 1.0.10

### 🛠️ Improvements

#### Android
- Added `provider_paths.xml` with FileProvider path configuration: `external-path`, `external-files-path`, `files-path`, and `cache-path` to support secure APK sharing across storage locations

---

## 1.0.9

### 🛠️ Improvements

#### Android
- Refactored `GithubReleaseApkUpdaterPlugin.kt`: simplified to core MethodChannel scaffold, removed temporary `installApk` and `getSupportedAbis` implementations
- Updated Android Gradle Plugin to `9.1.0`
- Updated Kotlin to `2.4.0`

### 🔧 Configuration
- Added `analyzer` excludes for `build/**` and `android/**` in `analysis_options.yaml`

### 📱 Example
- Added `MainActivity.kt` for example app (`blog.guidocutipa` and `bo.endesyc` package variants)

---

## 1.0.8

### ✨ Features

#### Android
- Added required permissions to `AndroidManifest.xml`: `INTERNET`, `REQUEST_INSTALL_PACKAGES`, and `READ_EXTERNAL_STORAGE`
- Registered `androidx.core.content.FileProvider` for secure APK file sharing during installation

### 🛠️ Improvements

#### GitHub API
- Added `X-GitHub-Api-Version: 2022-11-28` header to APK download requests for GitHub API versioning compliance
- Added `X-GitHub-Api-Version: 2026-03-10` header to release metadata requests

### 📦 Build & Distribution
- Added `/build` to `.pubignore` to exclude build artifacts from published package

---

## 1.0.7

- Modernize Android build configuration with Gradle 9.1.0 and AGP 9.0.1

## 1.0.6

### 🐛 Bug Fixes

#### Android
- Fixed build errors with `Nullability and flow analysis for Kotlin` (ConstraintSystem.proposalDue)
- Fixed `android/build.gradle.kts` plugin configuration issues

### 🛠️ Build System

#### Android
- Migrated to modern Android Gradle Plugin configuration
- Cleaned up deprecated `buildscript` and `allprojects` blocks
- Added `compileSdk = 36` for compatibility with latest Gradle versions
- Updated `android-compile-sdk-version.txt` to 36

## 1.0.5

### 🐛 Bug Fixes

#### Android
- Fixed build errors with `Nullability and flow analysis for Kotlin` (ConstraintSystem.proposalDue)
- Fixed `android/build.gradle.kts` plugin configuration issues

### 🛠️ Build System

#### Android
-Migrated to modern Android Gradle Plugin configuration
- Cleaned up deprecated `buildscript` and `allprojects` blocks
- Added `compileSdk = 36` for compatibility with latest Gradle versions

## 1.0.4

* Updated package metadata and documentation for the latest release.
* Improved changelog formatting and release note consistency.

## 1.0.3

* Fixed issue where the plugin was not able to find the APK file in the GitHub releases.
* Update example project to use the plugin

## 1.0.2

* Fixed issue where the plugin was not able to find the APK file in the GitHub releases.
* Added support download APK for multiple ABIs (CPU architectures).

## 1.0.1

* Fixed dependency conflict with `win32` between `geolocator` and `device_info_plus` in the project environment.

## 1.0.0

* Initial release of `github_release_apk_updater`.
* Added functionality to fetch the latest release from a GitHub repository.
* Implemented APK downloading from GitHub assets to local device storage.
* Added native Android support for launching APK installations.
* Included a version comparison utility to detect available updates.
* Provided a sample application demonstrating the full update lifecycle.

