import 'package:flutter/material.dart';

import '../../../l10n/generated/app_localizations.dart';

class HelpSupportPage extends StatelessWidget {
  const HelpSupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.profileHelpSupport)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            l10n.helpSupportHowItWorks,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 12),
          _HelpCard(
            icon: Icons.search,
            title: l10n.helpSupportFindServiceTitle,
            description: l10n.helpSupportFindServiceDescription,
          ),
          const SizedBox(height: 12),
          _HelpCard(
            icon: Icons.edit_note,
            title: l10n.helpSupportCreateRequestTitle,
            description: l10n.helpSupportCreateRequestDescription,
          ),
          const SizedBox(height: 12),
          _HelpCard(
            icon: Icons.notifications_active,
            title: l10n.helpSupportTrackRequestTitle,
            description: l10n.helpSupportTrackRequestDescription,
          ),
          const SizedBox(height: 20),
          Text(
            l10n.helpSupportFaqTitle,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 12),
          _FaqItem(
            question: l10n.helpSupportFaqEditQuestion,
            answer: l10n.helpSupportFaqEditAnswer,
          ),
          _FaqItem(
            question: l10n.helpSupportFaqNoReplyQuestion,
            answer: l10n.helpSupportFaqNoReplyAnswer,
          ),
          _FaqItem(
            question: l10n.helpSupportFaqContactQuestion,
            answer: l10n.helpSupportFaqContactAnswer,
          ),
          const SizedBox(height: 20),
          _HelpCard(
            icon: Icons.support_agent,
            title: l10n.helpSupportNeedHelpTitle,
            description: l10n.helpSupportNeedHelpDescription,
          ),
        ],
      ),
    );
  }
}

class _HelpCard extends StatelessWidget {
  const _HelpCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFF0B3157).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: const Color(0xFF0B3157)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    description,
                    style:
                        const TextStyle(color: Color(0xFF6B7280), height: 1.5),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FaqItem extends StatelessWidget {
  const _FaqItem({required this.question, required this.answer});

  final String question;
  final String answer;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        title:
            Text(question, style: const TextStyle(fontWeight: FontWeight.w700)),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              answer,
              style: const TextStyle(color: Color(0xFF6B7280), height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}
