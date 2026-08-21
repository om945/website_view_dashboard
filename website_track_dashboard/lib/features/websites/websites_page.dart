import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../app/theme/colors.dart';
import '../../app/theme/typography.dart';
import '../../core/config/dashboard_config.dart';
import '../../core/errors/api_exception.dart';
import '../../core/utils/domain.dart';
import '../../data/models/models.dart';
import '../../data/repositories/repositories.dart';
import '../../shared/widgets/app_button.dart';
import '../../shared/widgets/dashboard_scaffold.dart';
import '../../shared/icons/dashboard_icons.dart';

class WebsitesPage extends StatefulWidget {
  const WebsitesPage({
    super.key,
    required this.websites,
    required this.sites,
    required this.selectedSite,
    required this.onCreated,
    required this.onSelected,
    required this.onDeleted,
    required this.onRefresh,
    this.initiallyShowForm = false,
  });

  final WebsiteRepository websites;
  final List<Site> sites;
  final Site? selectedSite;
  final ValueChanged<Site> onCreated;
  final ValueChanged<Site> onSelected;
  final Future<void> Function(String siteId) onDeleted;
  final VoidCallback onRefresh;
  final bool initiallyShowForm;

  @override
  State<WebsitesPage> createState() => _WebsitesPageState();
}

class _WebsitesPageState extends State<WebsitesPage> {
  final _nameController = TextEditingController();
  final _domainController = TextEditingController();
  late bool _showForm;
  bool _creating = false;
  String? _message;
  bool _messageIsError = false;

  @override
  void initState() {
    super.initState();
    _showForm = widget.initiallyShowForm;
  }

  @override
  void didUpdateWidget(covariant WebsitesPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initiallyShowForm && !oldWidget.initiallyShowForm) {
      _showForm = true;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _domainController.dispose();
    super.dispose();
  }

  Future<void> _create() async {
    if (_creating) return;

    final name = _nameController.text.trim();
    final domainRaw = _domainController.text.trim();
    if (name.isEmpty || domainRaw.isEmpty) {
      setState(() {
        _message = 'Enter both a website name and domain.';
        _messageIsError = true;
      });
      return;
    }
    if (!domainOk(domainRaw)) {
      setState(() {
        _message = 'Enter a valid domain like example.com';
        _messageIsError = true;
      });
      return;
    }

    setState(() {
      _creating = true;
      _message = null;
    });

    try {
      final site = await widget.websites.createSite(
        name: name,
        domain: domainRaw,
      );
      if (!mounted) return;
      setState(() {
        _creating = false;
        _showForm = false;
        _message = 'Created ${site.domain}.';
        _messageIsError = false;
        _nameController.clear();
        _domainController.clear();
      });
      widget.onCreated(site);
      await _showCreated(site);
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _creating = false;
        _message = friendlyError(error);
        _messageIsError = true;
      });
    }
  }

  Future<void> _showCreated(Site site) async {
    final script = DashboardConfig.trackingScript(site.siteKey);
    await showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Website created'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Your backend-generated site key:'),
              const SizedBox(height: 8),
              SelectableText(site.siteKey, style: AppTypography.code),
              const SizedBox(height: 18),
              const Text('Tracking script:'),
              const SizedBox(height: 8),
              SelectableText(script, style: AppTypography.code),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () =>
                Clipboard.setData(ClipboardData(text: site.siteKey)),
            child: const Text('Copy site key'),
          ),
          TextButton(
            onPressed: () => Clipboard.setData(ClipboardData(text: script)),
            child: const Text('Copy script'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  Future<void> _delete(Site site) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Delete ${site.domain}?'),
        content: const Text(
          'This will remove this website from your account and stop its analytics from appearing in your dashboard.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Delete',
              style: TextStyle(color: AppColors.accent),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await widget.websites.deleteSite(site.id);
      await widget.onDeleted(site.id);
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _message = friendlyError(error);
        _messageIsError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return PageFrame(
      title: 'Websites',
      subtitle: 'Create and manage the sites connected to your account.',
      action: AppButton(
        label: _showForm ? 'Cancel' : 'Add website',
        icon: _showForm ? DashboardIcons.close : DashboardIcons.add,
        variant: AppButtonVariant.secondary,
        onPressed: () => setState(() {
          _showForm = !_showForm;
          _message = null;
        }),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_message != null) ...[
            Text(
              _message!,
              style: AppTypography.bodyMedium.copyWith(
                color: _messageIsError ? AppColors.accent : AppColors.emerald,
              ),
            ),
            const SizedBox(height: 14),
          ],
          if (_showForm)
            DashboardPanel(
              title: 'Add a website',
              child: Column(
                children: [
                  TextField(
                    controller: _nameController,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Website name',
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _domainController,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => _create(),
                    decoration: const InputDecoration(
                      labelText: 'Domain',
                      hintText: 'example.com',
                    ),
                  ),
                  const SizedBox(height: 18),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: AppButton(
                      label: 'Create website',
                      icon: DashboardIcons.arrowForward,
                      isLoading: _creating,
                      onPressed: _creating ? null : _create,
                    ),
                  ),
                ],
              ),
            ),
          if (_showForm) const SizedBox(height: 18),
          if (widget.sites.isEmpty && !_showForm)
            const EmptyState(
              icon: DashboardIcons.websites,
              title: 'No websites yet',
              body: 'Create your first website to start tracking visitors.',
            ),
          ...widget.sites.map(
            (site) => WebsiteCard(
              site: site,
              selected: site.id == widget.selectedSite?.id,
              onSelect: () => widget.onSelected(site),
              onDelete: () => _delete(site),
            ),
          ),
        ],
      ),
    );
  }
}

class WebsiteCard extends StatefulWidget {
  const WebsiteCard({
    super.key,
    required this.site,
    required this.selected,
    required this.onSelect,
    required this.onDelete,
  });

  final Site site;
  final bool selected;
  final VoidCallback onSelect;
  final VoidCallback onDelete;

  @override
  State<WebsiteCard> createState() => _WebsiteCardState();
}

class _WebsiteCardState extends State<WebsiteCard> {
  bool _hovered = false;
  bool _deleteHovered = false;

  @override
  Widget build(BuildContext context) {
    final borderColor = widget.selected
        ? AppColors.accentBorder
        : _hovered
        ? AppColors.borderStrong
        : AppColors.border;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Semantics(
        button: !widget.selected,
        label: '${widget.site.name}, ${widget.site.domain}',
        child: MouseRegion(
          onEnter: (_) => setState(() => _hovered = true),
          onExit: (_) => setState(() {
            _hovered = false;
            _deleteHovered = false;
          }),
          child: GestureDetector(
            onTap: widget.selected ? null : widget.onSelect,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 140),
              curve: Curves.easeOut,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: widget.selected
                    ? AppColors.surfaceElevated
                    : _hovered
                    ? AppColors.surfaceHover
                    : AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: borderColor),
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final compact = constraints.maxWidth < 520;
                  final details = Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          widget.site.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.bodyMedium.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          widget.site.domain,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.site.siteKey,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.code.copyWith(
                            fontSize: 10.5,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  );

                  final actions = Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (!widget.selected)
                        TextButton(
                          onPressed: widget.onSelect,
                          style: TextButton.styleFrom(
                            visualDensity: VisualDensity.compact,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                          ),
                          child: const Text('Select'),
                        )
                      else
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 9,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.accentSoft,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: AppColors.accentBorder),
                          ),
                          child: Text('Selected', style: AppTypography.chip),
                        ),
                      const SizedBox(width: 8),
                      MouseRegion(
                        onEnter: (_) => setState(() => _deleteHovered = true),
                        onExit: (_) => setState(() => _deleteHovered = false),
                        child: Tooltip(
                          message: 'Delete website',
                          child: Material(
                            color: _deleteHovered
                                ? AppColors.accentSoft
                                : AppColors.surfaceActive,
                            borderRadius: BorderRadius.circular(8),
                            child: InkWell(
                              onTap: widget.onDelete,
                              borderRadius: BorderRadius.circular(8),
                              child: SizedBox(
                                width: 40,
                                height: 40,
                                child: Center(
                                  child: Icon(
                                    DashboardIcons.delete,
                                    size: 19,
                                    color: _deleteHovered
                                        ? AppColors.accentHover
                                        : AppColors.textPrimary,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );

                  if (compact) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              DashboardIcons.websites,
                              size: 19,
                              color: AppColors.accent,
                            ),
                            const SizedBox(width: 12),
                            details,
                          ],
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: actions,
                          ),
                        ),
                      ],
                    );
                  }

                  return Row(
                    children: [
                      const Icon(
                        DashboardIcons.websites,
                        size: 19,
                        color: AppColors.accent,
                      ),
                      const SizedBox(width: 12),
                      details,
                      const SizedBox(width: 16),
                      actions,
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
