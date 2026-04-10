import 'package:flutter_test/flutter_test.dart';
import 'package:github_release_apk_updater/src/github_api_service.dart';
import 'package:dio/dio.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'github_api_service_test.mocks.dart';

@GenerateMocks([Dio])
void main() {
  group('GithubApiService', () {
    late MockDio mockDio;
    late GithubApiService apiService;

    setUp(() {
      mockDio = MockDio();
      apiService = GithubApiService(dio: mockDio);
    });

    test('getLatestGithubRelease returns GithubRelease on success', () async {
      when(mockDio.get(any, options: anyNamed('options'))).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: ''),
          statusCode: 200,
          data: {
            'tag_name': 'v1.0.0',
            'body': 'Initial release',
            'assets': [
              {
                'name': 'app-release.apk',
                'browser_download_url': 'http://example.com/app-release.apk',
              },
            ],
          },
        ),
      );

      final result = await apiService.getLatestGithubAPKRelease(
        ownerGithub: 'test',
        repositoryGithub: 'test',
        apkKeyName: '',
      );

      expect(result, isNotNull);
      expect(result?.version, '1.0.0');
      expect(result?.apkUrl, 'http://example.com/app-release.apk');
      expect(result?.releaseNote, 'Initial release');
    });
  });
}
