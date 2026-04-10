import 'package:flutter_test/flutter_test.dart';
import 'package:github_release_apk_updater/src/version_comparator.dart';

void main() {
  group('VersionComparator', () {
    final comparator = VersionComparator();

    test('isNewerVersion returns true when server is newer', () {
      expect(comparator.isNewerVersion('1.0.1', '1.0.0'), isTrue);
      expect(comparator.isNewerVersion('1.1.0', '1.0.9'), isTrue);
      expect(comparator.isNewerVersion('2.0.0', '1.9.9'), isTrue);
      expect(comparator.isNewerVersion('1.0.0.1', '1.0.0'), isTrue);
    });

    test('isNewerVersion returns false when server is older', () {
      expect(comparator.isNewerVersion('1.0.0', '1.0.1'), isFalse);
      expect(comparator.isNewerVersion('0.9.9', '1.0.0'), isFalse);
      expect(comparator.isNewerVersion('1.0', '1.0.1'), isFalse);
    });

    test('isNewerVersion returns false when versions are equal', () {
      expect(comparator.isNewerVersion('1.0.0', '1.0.0'), isFalse);
      expect(comparator.isNewerVersion('2.1', '2.1'), isFalse);
    });

    test('isNewerVersion handles malformed versions gracefully', () {
      expect(
        comparator.isNewerVersion('v1.0.1', '1.0.0'),
        isFalse,
      ); // 'v1' parses to 0
      expect(
        comparator.isNewerVersion('1.0.1', 'invalid'),
        isTrue,
      ); // 'invalid' parses to 0
    });
  });
}
