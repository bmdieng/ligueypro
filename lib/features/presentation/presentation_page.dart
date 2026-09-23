import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../core/theme/app_colors.dart';

class PresentationPage extends StatefulWidget {
  const PresentationPage({super.key});

  @override
  State<PresentationPage> createState() => _PresentationPageState();
}

class _PresentationPageState extends State<PresentationPage> {
  static const String _presentationVideoUrl =
      'https://interactive-examples.mdn.mozilla.net/media/cc0-videos/flower.mp4';

  late final VideoPlayerController _controller;
  bool _videoReady = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(_presentationVideoUrl))
      ..initialize().then((_) {
        if (!mounted) return;
        setState(() {
          _videoReady = true;
        });
        _controller.setLooping(true);
        _controller.play();
      }).catchError((_) {
        if (!mounted) return;
        setState(() {
          _videoReady = false;
        });
      });
  }

  @override
  void dispose() {
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
              'LigueyPro',
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
                border: Border.all(color: AppColors.primary.withOpacity(0.2)),
              ),
              clipBehavior: Clip.antiAlias,
              child: _videoReady
                  ? AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    )
                  : Container(
                      color: const Color(0xFFF4F7FB),
                      child: const Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.videocam_outlined, size: 48, color: AppColors.primary),
                            SizedBox(height: 12),
                            Text('Vidéo de présentation', style: TextStyle(fontWeight: FontWeight.w700)),
                          ],
                        ),
                      ),
                    ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Pourquoi LigueyPro ?',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 12),
            const _FeatureItem(
              icon: Icons.search,
              title: 'Recherche rapide',
              description: 'Trouvez un service adapté à votre besoin en quelques secondes.',
            ),
            const _FeatureItem(
              icon: Icons.star,
              title: 'Professionnels fiables',
              description: 'Consultez les avis, les évaluations et les profils disponibles.',
            ),
            const _FeatureItem(
              icon: Icons.notifications_active,
              title: 'Suivi simple',
              description: 'Suivez vos demandes et recevez des notifications utiles.',
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
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                const SizedBox(height: 4),
                Text(description, style: const TextStyle(color: AppColors.muted)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
