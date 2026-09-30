import 'package:flutter/material.dart';

import '../../../l10n/generated/app_localizations.dart';

class CguPage extends StatelessWidget {
  const CguPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.cguTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            l10n.cguTitle,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.cguIntro,
            style: const TextStyle(color: Color(0xFF6B7280), height: 1.6),
          ),
          const SizedBox(height: 20),
          _SectionTitle(title: l10n.cguSection1Title),
          _SectionText(l10n.cguSection1Body),
          const SizedBox(height: 12),
          _SectionTitle(title: l10n.cguSection2Title),
          _SectionText(l10n.cguSection2Body),
          const SizedBox(height: 12),
          _SectionTitle(title: l10n.cguSection3Title),
          _SectionText(l10n.cguSection3Body),
          const SizedBox(height: 12),
          _SectionTitle(title: l10n.cguSection4Title),
          _SectionText(l10n.cguSection4Body),
          const SizedBox(height: 12),
          _SectionTitle(title: l10n.cguSection5Title),
          _SectionText(l10n.cguSection5Body),
          const SizedBox(height: 12),
          _SectionTitle(title: l10n.cguSection6Title),
          _SectionText(l10n.cguSection6Body),
          const SizedBox(height: 20),
          Text(
            l10n.cguConclusion,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
      ),
    );
  }
}

class _SectionText extends StatelessWidget {
  const _SectionText(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(color: Color(0xFF6B7280), height: 1.6),
    );
  }
}
