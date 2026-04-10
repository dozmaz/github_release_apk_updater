/// Represents a GitHub release asset that contains an APK.
///
/// This model is used to store the version information, download URL,
/// and release notes for a specific GitHub release.
class GithubAPKRelease {
  /// The semantic version of the release (e.g., "1.0.0").
  final String version;

  /// The direct API download URL for the APK asset.
  final String apkUrl;

  /// The body/notes of the GitHub release.
  final String releaseNote;

  GithubAPKRelease({
    required this.version,
    required this.apkUrl,
    required this.releaseNote,
  });

  /// Factory constructor to create a [GithubAPKRelease] from a GitHub API JSON response.
  ///
  /// The [apkKey] parameter is used to filter assets by name if the release
  /// contains multiple APK files. If empty, it returns the first APK found.
  ///
  /// Throws an [Exception] if no APK asset is found.
  factory GithubAPKRelease.fromJson(Map<String, dynamic> json, String apkKey) {
    // Implementation...
    final tagName = json['tag_name'] as String;
    final body = json['body'] as String? ?? '';
    final version = tagName.startsWith('v.')
        ? tagName.substring(2)
        : tagName.startsWith('v')
        ? tagName.substring(1)
        : tagName;

    final assets = json['assets'] as List<dynamic>? ?? [];
    String? apkUrl;

    for (final asset in assets) {
      final String name = asset['name'] as String;
      if (apkKey.isEmpty) {
        if (name.endsWith('.apk')) {
          apkUrl = asset['url'] as String;
          break;
        }
      } else {
        if (name.endsWith('.apk') && name.contains(apkKey)) {
          apkUrl = asset['url'] as String;
          break;
        }
      }
    }

    if (apkUrl == null) {
      throw Exception('APK asset not found for key: $apkKey');
    }

    return GithubAPKRelease(
      version: version,
      apkUrl: apkUrl,
      releaseNote: body,
    );
  }
}
