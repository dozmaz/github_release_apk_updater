import 'package:flutter_test/flutter_test.dart';
import 'package:github_release_apk_updater/github_release_apk_updater.dart';
import 'package:github_release_apk_updater/github_release_apk_updater_platform_interface.dart';
import 'package:github_release_apk_updater/github_release_apk_updater_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockGithubReleaseApkUpdaterPlatform
    with MockPlatformInterfaceMixin
    implements GithubReleaseApkUpdaterPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Future<void> installApk(String filePath) => Future.value();
}

void main() {
  final GithubReleaseApkUpdaterPlatform initialPlatform =
      GithubReleaseApkUpdaterPlatform.instance;

  test('$MethodChannelGithubReleaseApkUpdater is the default instance', () {
    expect(
      initialPlatform,
      isInstanceOf<MethodChannelGithubReleaseApkUpdater>(),
    );
  });

  test('getPlatformVersion', () async {
    GithubReleaseApkUpdater githubReleaseApkUpdaterPlugin =
        GithubReleaseApkUpdater();
    MockGithubReleaseApkUpdaterPlatform fakePlatform =
        MockGithubReleaseApkUpdaterPlatform();
    GithubReleaseApkUpdaterPlatform.instance = fakePlatform;

    expect(await githubReleaseApkUpdaterPlugin.getPlatformVersion(), '42');
  });
}
