import 'package:flutter_test/flutter_test.dart';
import 'package:github_release_apk_updater/src/apk_downloader_service.dart';

import 'github_api_service_test.mocks.dart';

void main() {
  group('ApkDownloaderService', () {
    late MockDio mockDio;
    late ApkDownloaderService downloaderService;

    setUp(() {
      mockDio = MockDio();
      downloaderService = ApkDownloaderService(dio: mockDio);
    });

    test('is created successfully', () {
      expect(downloaderService, isNotNull);
    });
  });
}
