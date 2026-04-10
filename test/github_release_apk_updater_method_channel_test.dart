import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:github_release_apk_updater/github_release_apk_updater_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelGithubReleaseApkUpdater platform =
      MethodChannelGithubReleaseApkUpdater();
  const MethodChannel channel = MethodChannel('github_release_apk_updater');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
          return '42';
        });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
