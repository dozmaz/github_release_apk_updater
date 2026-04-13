import 'package:flutter_test/flutter_test.dart';
import 'package:github_release_apk_updater/src/models.dart';

void main() {
  group('GithubAPKRelease', () {
    final mockJson = {
      'tag_name': 'v1.0.0',
      'body': 'Release notes',
      'assets': [
        {
          'name': 'app-arm64-v8a-release.apk',
          'browser_download_url': 'http://example.com/arm64.apk',
          'url': 'http://api.example.com/arm64',
        },
        {
          'name': 'app-armeabi-v7a-release.apk',
          'browser_download_url': 'http://example.com/armv7.apk',
          'url': 'http://api.example.com/armv7',
        },
        {
          'name': 'app-release.apk',
          'browser_download_url': 'http://example.com/generic.apk',
          'url': 'http://api.example.com/generic',
        },
      ],
    };

    test('fromJson selects arm64 if it is the first supported ABI', () {
      final release = GithubAPKRelease.fromJson(
        mockJson,
        '',
        supportedAbis: ['arm64-v8a', 'armeabi-v7a'],
      );
      expect(release.apkUrl, 'http://example.com/arm64.apk');
    });

    test(
      'fromJson selects armv7 if arm64 is missing and armv7 is supported',
      () {
        final jsonWithOnlyArmv7 = {
          'tag_name': 'v1.0.0',
          'body': '',
          'assets': [
            {
              'name': 'app-armeabi-v7a-release.apk',
              'browser_download_url': 'http://example.com/armv7.apk',
            },
            {
              'name': 'app-release.apk',
              'browser_download_url': 'http://example.com/generic.apk',
            },
          ],
        };
        final release = GithubAPKRelease.fromJson(
          jsonWithOnlyArmv7,
          '',
          supportedAbis: ['arm64-v8a', 'armeabi-v7a'],
        );
        expect(release.apkUrl, 'http://example.com/armv7.apk');
      },
    );

    test(
      'fromJson falls back to generic apk if no ABI-specific matches fond',
      () {
        final release = GithubAPKRelease.fromJson(
          mockJson,
          '',
          supportedAbis: ['x86_64'],
        );
        expect(release.apkUrl, 'http://example.com/generic.apk');
      },
    );

    test('fromJson respects apkKey along with ABI', () {
      final jsonWithMultiple = {
        'tag_name': 'v1.0.0',
        'body': '',
        'assets': [
          {
            'name': 'pro-arm64-v8a-release.apk',
            'browser_download_url': 'http://example.com/pro-arm64.apk',
          },
          {
            'name': 'free-arm64-v8a-release.apk',
            'browser_download_url': 'http://example.com/free-arm64.apk',
          },
        ],
      };
      final release = GithubAPKRelease.fromJson(
        jsonWithMultiple,
        'pro',
        supportedAbis: ['arm64-v8a'],
      );
      expect(release.apkUrl, 'http://example.com/pro-arm64.apk');
    });

    test('fromJson throws exception if no APK found at all', () {
      final jsonNoApk = {
        'tag_name': 'v1.0.0',
        'body': '',
        'assets': [
          {'name': 'source.zip', 'url': 'http://example.com/src.zip'},
        ],
      };
      expect(() => GithubAPKRelease.fromJson(jsonNoApk, ''), throwsException);
    });
  });
}
