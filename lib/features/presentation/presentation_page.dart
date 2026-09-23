import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../core/services/app_preferences_service.dart';
import '../../core/theme/app_colors.dart';

class PresentationPage extends StatefulWidget {
  const PresentationPage({super.key});

  @override
  State<PresentationPage> createState() => _PresentationPageState();
}

class _PresentationPageState extends State<PresentationPage> {
  static const String _presentationVideoAsset =
      'assets/videos/ligueypro_presentation.mp4';

  late final VideoPlayerController _controller;
  bool _autoPlayPresentation = true;
  bool _videoReady = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(_presentationVideoAsset)
      ..initialize().then((_) {
        if (!mounted) return;
        _controller.setLooping(true);
        setState(() {
          _videoReady = true;
        });
        if (_autoPlayPresentation) {
          _controller.play();
        }
      }).catchError((_) {
        if (!mounted) return;
        setState(() {
          _videoReady = false;
        });
      });
    _controller.addListener(_handleVideoStateChange);
    _loadAutoPlayPreference();
  }

  Future<void> _loadAutoPlayPreference() async {
    final autoPlayPresentation =
        await AppPreferencesService.getAutoPlayPresentation();

    if (!mounted) return;

    setState(() {
      _autoPlayPresentation = autoPlayPresentation;
    });

    if (_videoReady && _autoPlayPresentation) {
      await _controller.play();
    }
  }

  void _handleVideoStateChange() {
    if (!mounted) return;
    setState(() {});
  }

  Future<void> _togglePlayback() async {
    if (_controller.value.isPlaying) {
      await _controller.pause();
      return;
    }

    await _controller.play();
  }

  @override
  void dispose() {
    _controller.removeListener(_handleVideoStateChange);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Présentation de l’application'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Text(
              'LigueyPro 2.0',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Trouvez le bon service près de chez vous',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.muted, fontSize: 16),
            ),
            const SizedBox(height: 20),
            Container(
              height: 420,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.2),
                ),
              ),
              clipBehavior: Clip.antiAlias,
              child: _videoReady
                  ? Stack(
                      fit: StackFit.expand,
                      children: [
                        AspectRatio(
                          aspectRatio: _controller.value.aspectRatio,
                          child: VideoPlayer(_controller),
                        ),
                        Positioned(
                          right: 16,
                          bottom: 16,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.55),
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              onPressed: _togglePlayback,
                              icon: Icon(
                                _controller.value.isPlaying
                                    ? Icons.pause_rounded
                                    : Icons.play_arrow_rounded,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : Container(
                      color: const Color(0xFFF4F7FB),
                      child: const Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.videocam_outlined,
                                size: 48, color: AppColors.primary),
                            SizedBox(height: 12),
                            Text('Vidéo de présentation',
                                style: TextStyle(fontWeight: FontWeight.w700)),
                          ],
                        ),
                      ),
                    ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Pourquoi LigueyPro 2.0 ?',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 12),
            const _FeatureItem(
              icon: Icons.search,
              title: 'Recherche rapide',
              description:
                  'Trouvez un service adapté à votre besoin en quelques secondes.',
            ),
            const _FeatureItem(
              icon: Icons.star,
              title: 'Professionnels fiables',
              description:
                  'Consultez les avis, les évaluations et les profils disponibles.',
            ),
            const _FeatureItem(
              icon: Icons.notifications_active,
              title: 'Suivi simple',
              description:
                  'Suivez vos demandes et recevez des notifications utiles.',
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  const _FeatureItem({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 16)),
                const SizedBox(height: 4),
                Text(description,
                    style: const TextStyle(color: AppColors.muted)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
