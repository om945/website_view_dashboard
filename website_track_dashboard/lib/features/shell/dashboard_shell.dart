import 'package:flutter/material.dart';
import '../../app/theme/colors.dart';
import '../../core/responsive/responsive.dart';
import '../../data/api/api_client.dart';
import '../../data/models/models.dart';
import '../../shared/widgets/app_button.dart';
import '../../shared/widgets/dashboard_scaffold.dart';
import '../overview/overview_page.dart';
import '../pages/pages_page.dart';
import '../realtime/realtime_page.dart';
import '../settings/settings_page.dart';
import '../tracking/tracking_page.dart';
import '../unsupported/unsupported_page.dart';
import '../websites/websites_page.dart';
import 'dashboard_sidebar.dart';
import 'dashboard_top_bar.dart';

class DashboardShell extends StatefulWidget {
  const DashboardShell({
    super.key,
    required this.api,
    required this.user,
    required this.onLoggedOut,
  });

  final ApiClient api;
  final User user;
  final VoidCallback onLoggedOut;

  @override
  State<DashboardShell> createState() => _DashboardShellState();
}

class _DashboardShellState extends State<DashboardShell> {
  List<Site> _sites = [];
  Site? _selectedSite;
  DashboardSection _section = DashboardSection.overview;
  bool _loading = true;
  Object? _error;

  @override
  void initState() {
    super.initState();
    _loadSites();
  }

  Future<void> _loadSites() async {
    try {
      final sites = await widget.api.listSites();
      if (!mounted) return;
      setState(() {
        _sites = sites;
        _selectedSite = _resolveSelectedSite(sites, _selectedSite);
        _loading = false;
        _error = null;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _error = error;
        _loading = false;
      });
    }
  }

  Site? _resolveSelectedSite(List<Site> sites, Site? current) {
    if (sites.isEmpty) return null;
    if (current != null && sites.any((site) => site.id == current.id)) {
      return sites.firstWhere((site) => site.id == current.id);
    }
    return sites.first;
  }

  Future<void> _logout() async {
    await widget.api.logout();
    if (!mounted) return;
    widget.onLoggedOut();
  }

  void _navigate(DashboardSection section) {
    setState(() => _section = section);
  }

  @override
  Widget build(BuildContext context) {
    final mobile = Responsive.isMobile(context);
    final scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: AppColors.background,
      drawer: mobile
          ? Drawer(
              backgroundColor: AppColors.surface,
              child: SafeArea(
                child: DashboardSidebar(
                  current: _section,
                  onTap: (section) {
                    _navigate(section);
                    Navigator.pop(context);
                  },
                ),
              ),
            )
          : null,
      body: Row(
        children: [
          if (!mobile)
            SizedBox(
              width: 248,
              child: DashboardSidebar(
                current: _section,
                onTap: _navigate,
              ),
            ),
          Expanded(
            child: Column(
              children: [
                DashboardTopBar(
                  user: widget.user,
                  sites: _sites,
                  selectedSite: _selectedSite,
                  mobile: mobile,
                  onMenuTap: () => scaffoldKey.currentState?.openDrawer(),
                  onSiteChanged: (site) => setState(() => _selectedSite = site),
                  onLogout: _logout,
                ),
                Expanded(
                  child: _loading
                      ? const LoadingState()
                      : _error != null
                          ? ErrorState(
                              message: 'Unable to load your websites.',
                              onRetry: () {
                                setState(() {
                                  _loading = true;
                                  _error = null;
                                });
                                _loadSites();
                              },
                            )
                          : _buildContent(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (_selectedSite == null) {
      return PageFrame(
        title: 'Welcome',
        subtitle: 'Create your first website to start collecting analytics.',
        child: EmptyState(
          icon: Icons.language_rounded,
          title: 'No websites yet',
          body:
              'Add a website, copy the tracking script, and your first visitor will appear here.',
          action: AppButton(
            label: 'Add website',
            icon: Icons.add_rounded,
            onPressed: () => _navigate(DashboardSection.websites),
          ),
        ),
      );
    }

    final site = _selectedSite!;
    return KeyedSubtree(
      key: ValueKey('${_section.name}-${site.id}'),
      child: switch (_section) {
        DashboardSection.overview => OverviewPage(api: widget.api, site: site),
        DashboardSection.websites => WebsitesPage(
            api: widget.api,
            sites: _sites,
            selectedSite: site,
            onRefresh: _loadSites,
          ),
        DashboardSection.realtime => RealtimePage(api: widget.api, site: site),
        DashboardSection.pages => PagesPage(api: widget.api, site: site),
        DashboardSection.visitors => const UnsupportedPage(
            title: 'Visitors',
            body:
                'The current API exposes anonymous visitor aggregates, not individual visitor records.',
            icon: Icons.groups_2_outlined,
          ),
        DashboardSection.events => const UnsupportedPage(
            title: 'Events',
            body:
                'Event ingestion exists, but aggregate event analytics are not exposed by the current API.',
            icon: Icons.bolt_outlined,
          ),
        DashboardSection.tracking => TrackingPage(site: site),
        DashboardSection.settings => SettingsPage(
            api: widget.api,
            user: widget.user,
            site: site,
          ),
      },
    );
  }
}
