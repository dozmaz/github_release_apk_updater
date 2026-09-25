

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

