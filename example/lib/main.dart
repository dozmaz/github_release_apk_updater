import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:github_release_apk_updater/github_release_apk_updater.dart';

void main() {
  runApp(const MyApp());
}

/// The example application demonstrates how to use the
/// `github_release_apk_updater` plugin to implement an update flow.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GitHub Release APK Updater Demo',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),
      home: const MyHomePage(),
    );
  }
}

/// The home page containing the UI for checking and installing updates.
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _githubReleaseApkUpdaterPlugin = GithubReleaseApkUpdater();
  final _apiService = GithubApiService();
  final _downloaderService = ApkDownloaderService();
  final _versionComparator = VersionComparator();

  // IMPORTANT: Set your repository information here
  final ownerGithub = 'guido-cutipa'; // Replace with your owner
  final repositoryGithub = 'dummy-repo'; // Replace with your repository
  final apkKeyName = '';
  dynamic tokenGithub; // optional: only needed for private repos

  String _platformVersion = 'Unknown';
  String _currentAppVersion = 'Unknown';
  bool _isChecking = false;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    String platformVersion;
    String appVersion;
    try {
      platformVersion =
          await _githubReleaseApkUpdaterPlugin.getPlatformVersion() ??
          'Unknown platform version';
      appVersion = await _githubReleaseApkUpdaterPlugin.getCurrentAppVersion();
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
      appVersion = 'Failed to get app version.';
    }

    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
      _currentAppVersion = appVersion;
    });
  }

  /// Logic to check for updates against the GitHub repository.
  Future<void> _checkForUpdate() async {
    setState(() {
      _isChecking = true;
    });

    try {
      // 1. Fetch latest release info from GitHub API
      final release = await _apiService.getLatestGithubAPKRelease(
        ownerGithub: ownerGithub,
        repositoryGithub: repositoryGithub,
        apkKeyName: apkKeyName,
        tokenGithub: tokenGithub,
      );

      if (release != null) {
        // 2. Compare versions (Release Tag vs Installed App Version)
        final isNewer = _versionComparator.isNewerVersion(
          release.version,
          _currentAppVersion,
        );
        if (isNewer && mounted) {
          // 3. Show dialog if a new version is available
          _showUpdateDialog(release);
        } else if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('App is up to date.')));
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No release found or error contacting github.'),
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('Error checking for updates: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isChecking = false;
        });
      }
    }
  }

  void _showUpdateDialog(GithubAPKRelease release) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return UpdateDialog(
          release: release,
          tokenGithub: tokenGithub,
          downloaderService: _downloaderService,
          updaterPlugin: _githubReleaseApkUpdaterPlugin,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Plugin example app')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Running on: $_platformVersion\n'),
            Text('Current App Version: $_currentAppVersion\n'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isChecking ? null : _checkForUpdate,
              child: _isChecking
                  ? const CircularProgressIndicator()
                  : const Text('Check for Updates'),
            ),
          ],
        ),
      ),
    );
  }
}

class UpdateDialog extends StatefulWidget {
  final GithubAPKRelease release;
  final String? tokenGithub;
  final ApkDownloaderService downloaderService;
  final GithubReleaseApkUpdater updaterPlugin;

  const UpdateDialog({
    super.key,
    required this.release,
    required this.tokenGithub,
    required this.downloaderService,
    required this.updaterPlugin,
  });

  @override
  State<UpdateDialog> createState() => _UpdateDialogState();
}

class _UpdateDialogState extends State<UpdateDialog> {
  bool _isDownloading = false;
  double _progress = 0.0;

  Future<void> _startDownloadAndInstall() async {
    setState(() {
      _isDownloading = true;
    });

    final filePath = await widget.downloaderService.downloadAPK(
      widget.release.apkUrl,
      widget.tokenGithub,
      (received, total) {
        if (total != -1) {
          setState(() {
            _progress = received / total;
          });
        }
      },
    );

    setState(() {
      _isDownloading = false;
    });

    if (filePath != null) {
      await widget.updaterPlugin.installApk(filePath);
      if (mounted) {
        Navigator.of(context).pop();
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to download update.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('New Update Available'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Version ${widget.release.version} is available.'),
          const SizedBox(height: 10),
          Text('Release Notes:\n${widget.release.releaseNote}'),
          const SizedBox(height: 20),
          if (_isDownloading) ...[
            const Text('Downloading...'),
            const SizedBox(height: 10),
            LinearProgressIndicator(value: _progress),
          ],
        ],
      ),
      actions: [
        if (!_isDownloading)
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Later'),
          ),
        if (!_isDownloading)
          ElevatedButton(
            onPressed: _startDownloadAndInstall,
            child: const Text('Update Now'),
          ),
      ],
    );
  }
}
