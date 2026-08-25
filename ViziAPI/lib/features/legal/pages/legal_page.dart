import 'package:flutter/material.dart';

import '../../../app/theme/colors.dart';
import '../../../app/theme/radii.dart';
import '../../../app/theme/typography.dart';
import '../../../core/config/dashboard_config.dart';
import '../../../core/platform/platform.dart';
import '../../../core/responsive/responsive.dart';
import '../legal_route.dart';
import '../../../shared/widgets/viziapi_brand.dart';

class LegalPage extends StatefulWidget {
  const LegalPage({super.key, required this.type});

  final LegalPageType type;

  @override
  State<LegalPage> createState() => _LegalPageState();
}

class _LegalPageState extends State<LegalPage> {
  final _scrollController = ScrollController();

  LegalDocument get _document => widget.type == LegalPageType.privacy
      ? _privacyDocument
      : _termsDocument;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(covariant LegalPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.type != widget.type && _scrollController.hasClients) {
      _scrollController.jumpTo(0);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = Responsive.width(context);
    final mobile = width < 768;
    final horizontal = Responsive.horizontalPadding(context);

    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            padding: EdgeInsets.only(top: mobile ? 72 : 84),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    horizontal,
                    mobile ? 34 : 62,
                    horizontal,
                    mobile ? 42 : 72,
                  ),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxWidth: 1120,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _LegalHeader(document: _document),
                          const SizedBox(height: 40),
                          if (mobile)
                            _MobileContents(sections: _document.sections)
                          else
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 220,
                                  child: _Contents(sections: _document.sections),
                                ),
                                const SizedBox(width: 56),
                                Expanded(
                                  child: _LegalBody(
                                    sections: _document.sections,
                                  ),
                                ),
                              ],
                            ),
                          if (mobile) ...[
                            const SizedBox(height: 28),
                            _LegalBody(sections: _document.sections),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
                const _LegalFooter(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LegalHeader extends StatelessWidget {
  const _LegalHeader({required this.document});

  final LegalDocument document;

  @override
  Widget build(BuildContext context) {
    final mobile = Responsive.isMobile(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ViziApiBrand(),
        const SizedBox(height: 34),
        Text(document.eyebrow, style: AppTypography.eyebrow),
        const SizedBox(height: 12),
        Text(
          document.title,
          style: AppTypography.h1.copyWith(fontSize: mobile ? 34 : 46),
        ),
        const SizedBox(height: 16),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: Text(document.introduction, style: AppTypography.bodyLarge),
        ),
        const SizedBox(height: 18),
        Text(
          'Last updated: August 21, 2026',
          style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }
}

class _MobileContents extends StatelessWidget {
  const _MobileContents({required this.sections});
  final List<LegalSection> sections;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadii.radiusMd,
        border: Border.all(color: AppColors.border),
      ),
      child: _Contents(sections: sections),
    );
  }
}

class _Contents extends StatelessWidget {
  const _Contents({required this.sections});
  final List<LegalSection> sections;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('ON THIS PAGE', style: AppTypography.eyebrow),
        const SizedBox(height: 14),
        ...sections.map(
          (section) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text(
              section.title,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _LegalBody extends StatelessWidget {
  const _LegalBody({required this.sections});
  final List<LegalSection> sections;

  @override
  Widget build(BuildContext context) {
    return SelectionArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: sections
            .map(
              (section) => Padding(
                padding: const EdgeInsets.only(bottom: 34),
                child: _LegalSectionView(section: section),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _LegalSectionView extends StatelessWidget {
  const _LegalSectionView({required this.section});
  final LegalSection section;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(section.title, style: AppTypography.h2),
        const SizedBox(height: 12),
        ...section.paragraphs.map(
          (paragraph) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text(paragraph, style: AppTypography.bodyMedium),
          ),
        ),
        if (section.bullets.isNotEmpty) ...[
          const SizedBox(height: 2),
          ...section.bullets.map(
            (bullet) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 8, right: 10),
                    child: Icon(Icons.circle, size: 5, color: AppColors.accent),
                  ),
                  Expanded(child: Text(bullet, style: AppTypography.bodyMedium)),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _LegalFooter extends StatelessWidget {
  const _LegalFooter();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 34),
      decoration: const BoxDecoration(
        color: AppColors.backgroundElevated,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Center(
        child: Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 12,
          children: [
            Text(
              '© 2026 ViziAPI. All rights reserved.',
              style: AppTypography.bodySmall,
            ),
            TextButton(
              onPressed: () => openUrl(DashboardConfig.privacyPolicyUrl),
              child: const Text('Privacy Policy'),
            ),
            TextButton(
              onPressed: () => openUrl(DashboardConfig.termsOfServiceUrl),
              child: const Text('Terms of Service'),
            ),
          ],
        ),
      ),
    );
  }
}

class LegalDocument {
  const LegalDocument({
    required this.path,
    required this.eyebrow,
    required this.title,
    required this.introduction,
    required this.sections,
  });

  final String path;
  final String eyebrow;
  final String title;
  final String introduction;
  final List<LegalSection> sections;
}

class LegalSection {
  const LegalSection(this.title, {this.paragraphs = const [], this.bullets = const []});
  final String title;
  final List<String> paragraphs;
  final List<String> bullets;
}

const _privacyDocument = LegalDocument(
  path: '/privacy',
  eyebrow: 'LEGAL / PRIVACY',
  title: 'Privacy Policy',
  introduction:
      'This Privacy Policy explains how ViziAPI handles information when you use our developer-first website analytics platform, dashboard, API, and related services.',
  sections: [
    LegalSection('1. Introduction', paragraphs: [
      'ViziAPI is designed to help website and application owners understand traffic and product usage. We distinguish between information about an account and analytics data that customers collect through their own websites or applications.',
      'By using ViziAPI, you acknowledge this policy. If you do not agree with it, please do not use the service.',
    ]),
    LegalSection('2. Information We Collect', paragraphs: [
      'The information we process depends on how you use ViziAPI and how a customer configures its analytics implementation. We seek to collect information that is reasonably necessary to provide, secure, maintain, and improve the service.',
    ], bullets: [
      'Account information, such as name, email address, profile identifier, profile image where available, and account or website identifiers.',
      'Analytics information submitted by customers or collected by the tracking implementation, such as IP address, approximate location derived from IP, browser, operating system, device type, referring URL, pages visited, timestamps, sessions, events, and performance or usage information.',
      'Information you provide when contacting support or communicating with us.',
    ]),
    LegalSection('3. Account and Authentication Information', paragraphs: [
      'We use account information to create and identify your ViziAPI account, maintain sessions, provide dashboard access, communicate about the service, and protect the service from abuse. Account information is separate from analytics data belonging to a customer website or project, although the account may control access to that project.',
    ]),
    LegalSection('4. Google Sign-In and Google User Data', paragraphs: [
      'ViziAPI may use Google Sign-In or Google OAuth to authenticate users. Depending on the authentication scopes selected and made available, ViziAPI may receive basic Google account information such as your name, email address, profile identifier, and profile image where applicable.',
      'We use this information only for authentication, account creation, account identification, session management, and providing ViziAPI services. We do not sell Google user data, and we do not use Google user data for advertising purposes.',
      'Google user data is not transferred to third parties except where necessary to provide the service, comply with law, protect security, or as otherwise disclosed in this policy. ViziAPI does not access Gmail, Google Drive, Google Calendar, Google Photos, YouTube, or other Google services unless the requested scopes and implementation explicitly require it.',
      'ViziAPI’s use of Google user data is intended to comply with the applicable Google API Services User Data Policy and Limited Use requirements. This statement is not a certification or approval by Google.',
    ]),
    LegalSection('5. Website Analytics Data', paragraphs: [
      'ViziAPI processes analytics data for customer websites and applications at the customer’s direction. Customers are responsible for configuring tracking lawfully, providing appropriate notices, obtaining consent where required, and avoiding sensitive personal information unless ViziAPI explicitly supports and permits that use.',
      'Analytics data may include website or project identifiers, page views, sessions, events, referrals, device and browser information, approximate geographic information, performance data, and other information submitted by a customer’s implementation.',
    ]),
    LegalSection('6. Automatically Collected Information', paragraphs: [
      'When you access ViziAPI, we may automatically process technical information needed to operate and secure the service, such as request information, device or browser information, timestamps, and diagnostic information. The exact information depends on the request and the service feature being used.',
    ]),
    LegalSection('7. How We Use Information', bullets: [
      'Provide, operate, maintain, and improve ViziAPI.',
      'Authenticate users, maintain sessions, and provide account and project access.',
      'Provide analytics, API, and tracking features requested by customers.',
      'Monitor reliability, prevent abuse, investigate security incidents, and enforce agreements.',
      'Communicate about service operation, support, and material policy or product changes.',
      'Comply with legal obligations and respond to lawful requests.',
    ]),
    LegalSection('8. How We Share Information', paragraphs: [
      'We do not sell personal information or Google user data. We may share information with service providers acting on our behalf, when necessary to provide the service, comply with law, protect rights and security, investigate abuse, or in connection with a business transfer. We do not authorize third parties to use information for purposes inconsistent with providing the requested service or the disclosures in this policy.',
    ]),
    LegalSection('9. Service Providers and Third-Party Services', paragraphs: [
      'ViziAPI may rely on infrastructure, hosting, authentication, monitoring, communications, and other service providers. Their handling of information is governed by their own terms and privacy practices where applicable. We do not list a provider as a subprocessors or make a data-location claim unless confirmed for the relevant service.',
      'Google authentication is provided through Google’s services and is also subject to Google’s terms and privacy policies.',
    ]),
    LegalSection('10. Data Storage and Retention', paragraphs: [
      'Information may be retained for as long as reasonably necessary to provide the service, maintain security, comply with legal obligations, resolve disputes, and enforce agreements. Specific retention can depend on the account, customer configuration, data type, and operational requirements.',
      '[DATA RETENTION PERIOD / POLICY TO BE CONFIRMED]',
    ]),
    LegalSection('11. Data Security', paragraphs: [
      'ViziAPI uses reasonable technical and organizational measures designed to protect information against unauthorized access, loss, misuse, alteration, or disclosure. No method of transmission or storage is guaranteed to be completely secure.',
    ]),
    LegalSection('12. Cookies and Similar Technologies', paragraphs: [
      'ViziAPI may use cookies, local storage, session mechanisms, or similar technologies that are reasonably necessary for authentication, security, preferences, and service operation. Customer tracking implementations may use their own identifiers and technologies as configured by the customer.',
    ]),
    LegalSection('13. Your Privacy Rights', paragraphs: [
      'Depending on where you live, you may have rights to request access, correction, deletion, restriction, or portability of certain personal information, or to object to certain processing. We may need to verify your request and may retain information where required or permitted by law.',
    ]),
    LegalSection('14. Data Deletion and Account Deletion', paragraphs: [
      'You may request deletion of your ViziAPI account and associated personal information by contacting [PRIVACY / SUPPORT EMAIL]. Please include enough information for us to identify the account and describe the request. Deletion may be subject to legal, security, backup, dispute-resolution, or customer-project obligations.',
    ]),
    LegalSection('15. Children’s Privacy', paragraphs: [
      'ViziAPI is not directed to children who are not legally permitted to use the service. We do not knowingly collect personal information from children in violation of applicable law.',
    ]),
    LegalSection('16. International Data Transfers', paragraphs: [
      'Information may be processed in countries other than the country where you live. Where required, ViziAPI will seek to use appropriate safeguards for applicable transfers. Specific data-location details are not stated here unless confirmed for the relevant deployment.',
    ]),
    LegalSection('17. Changes to This Privacy Policy', paragraphs: [
      'We may update this policy as ViziAPI changes or as legal requirements develop. The updated version will be posted at this URL with a revised “Last updated” date. Material changes may also be communicated through the service where appropriate.',
    ]),
    LegalSection('18. Contact Us', paragraphs: [
      'For privacy questions, requests, or account deletion inquiries, contact [PRIVACY / SUPPORT EMAIL].',
    ]),
  ],
);

const _termsDocument = LegalDocument(
  path: '/terms',
  eyebrow: 'LEGAL / TERMS',
  title: 'Terms of Service',
  introduction:
      'These Terms of Service govern your access to and use of ViziAPI, including its dashboard, API, tracking tools, and related services.',
  sections: [
    LegalSection('1. Acceptance of Terms', paragraphs: [
      'By accessing or using ViziAPI, you agree to these Terms of Service. If you are using ViziAPI on behalf of an organization, you represent that you have authority to bind that organization.',
    ]),
    LegalSection('2. Description of ViziAPI', paragraphs: [
      'ViziAPI is a developer-first website analytics platform that helps website and application owners understand traffic, visitors, devices, geography, browsers, page views, sessions, referrals, events, performance, and related analytics through a dashboard and API.',
      'Features may change over time, and particular features may be limited by the account or deployment configuration.',
    ]),
    LegalSection('3. Eligibility', paragraphs: [
      'You may use ViziAPI only if you can form a binding contract under applicable law and are not prohibited from using the service. If you use the service for an organization, you must be authorized to do so.',
    ]),
    LegalSection('4. Accounts and Authentication', paragraphs: [
      'You are responsible for the accuracy of account information, protecting access to your account, and activity conducted through your account. Notify us promptly if you believe account access has been compromised.',
    ]),
    LegalSection('5. Google Sign-In', paragraphs: [
      'ViziAPI may allow authentication through Google. You remain responsible for the Google account you use to access ViziAPI. Google authentication is provided through Google’s services and is subject to Google’s own terms and policies. ViziAPI does not control Google’s services and does not imply that Google endorses, sponsors, certifies, or is affiliated with ViziAPI.',
      'ViziAPI requests only the permissions necessary for the functionality it provides.',
    ]),
    LegalSection('6. Customer Responsibilities', bullets: [
      'Have appropriate rights and a lawful basis to collect and process analytics data.',
      'Provide appropriate privacy notices and obtain consent where required.',
      'Configure tracking and API use in compliance with applicable laws and third-party rights.',
      'Avoid sending sensitive personal information to analytics endpoints unless ViziAPI explicitly supports and permits that use.',
      'Protect credentials, site keys, and other access information from unauthorized use.',
    ]),
    LegalSection('7. Acceptable Use', paragraphs: [
      'You may use ViziAPI for lawful website and application analytics, development, monitoring, and related activities consistent with these Terms and the service documentation.',
    ]),
    LegalSection('8. Prohibited Activities', bullets: [
      'Violating applicable law, regulation, or third-party rights.',
      'Attempting unauthorized access, probing, or bypassing security controls.',
      'Disrupting the service, generating malicious traffic, or interfering with other users.',
      'Uploading malware or using ViziAPI to distribute harmful code.',
      'Collecting data unlawfully or using the service to facilitate abuse, fraud, or harassment.',
      'Reverse engineering the service except to the extent such restriction is prohibited by law.',
    ]),
    LegalSection('9. Analytics Data and Customer Content', paragraphs: [
      'You retain responsibility for analytics data and other content submitted through your account. You grant ViziAPI the rights reasonably necessary to host, process, transmit, display, and secure that content to provide the service. You must not submit content that you lack the right to process or that violates these Terms.',
    ]),
    LegalSection('10. Intellectual Property', paragraphs: [
      'ViziAPI and its underlying software, interfaces, branding, documentation, and materials are owned by ViziAPI or its licensors and are protected by applicable law. These Terms grant you a limited right to use the service; they do not transfer ownership.',
    ]),
    LegalSection('11. Third-Party Services', paragraphs: [
      'ViziAPI may integrate with third-party services, including Google authentication and infrastructure providers. Third-party services are governed by their own terms and policies, and ViziAPI is not responsible for services it does not control.',
    ]),
    LegalSection('12. Availability and Service Changes', paragraphs: [
      'We work to keep ViziAPI available and reliable, but availability is not guaranteed. We may modify, suspend, or discontinue features, including for maintenance, security, legal, or operational reasons.',
    ]),
    LegalSection('13. Fees and Billing', paragraphs: [
      'Current pricing, if any, will be presented through the applicable ViziAPI purchasing or account flow. No fees are charged unless disclosed to you before purchase or use of a paid feature.',
    ]),
    LegalSection('14. Suspension and Termination', paragraphs: [
      'We may suspend or terminate access when reasonably necessary to address security, abuse, legal risk, non-payment, or a material breach of these Terms. You may stop using ViziAPI at any time. Following termination, provisions that should reasonably survive will remain in effect.',
    ]),
    LegalSection('15. Disclaimer of Warranties', paragraphs: [
      'To the extent permitted by law, ViziAPI is provided on an “as is” and “as available” basis without warranties of any kind, express or implied. We do not warrant that the service will be uninterrupted, error-free, or suitable for every particular purpose.',
    ]),
    LegalSection('16. Limitation of Liability', paragraphs: [
      'To the extent permitted by law, ViziAPI and its providers will not be liable for indirect, incidental, special, consequential, exemplary, or punitive damages, or for loss of data, profits, revenue, or business arising from or related to the service. Any remaining liability will be limited as required by applicable law.',
    ]),
    LegalSection('17. Indemnification', paragraphs: [
      'To the extent permitted by law, you agree to defend and hold harmless ViziAPI and its providers from claims, losses, liabilities, and expenses arising from your unlawful use of the service, your customer content, your breach of these Terms, or your violation of third-party rights.',
    ]),
    LegalSection('18. Governing Law', paragraphs: [
      'These Terms are governed by the laws of [GOVERNING JURISDICTION], without regard to conflict-of-law rules. The courts located in [GOVERNING JURISDICTION] will have jurisdiction unless applicable law requires otherwise.',
    ]),
    LegalSection('19. Changes to These Terms', paragraphs: [
      'We may update these Terms as the service or legal requirements change. The revised Terms will be posted at this URL with a new “Last updated” date. Continued use after an update means you accept the revised Terms to the extent permitted by law.',
    ]),
    LegalSection('20. Contact Information', paragraphs: [
      'For questions about these Terms, contact [PRIVACY / SUPPORT EMAIL].',
    ]),
  ],
);
