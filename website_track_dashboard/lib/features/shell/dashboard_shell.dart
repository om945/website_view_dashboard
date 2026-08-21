import 'dart:async';
import 'package:flutter/material.dart';
import '../../app/theme/colors.dart';
import '../../core/responsive/responsive.dart';
import '../../data/api/api_client.dart';
import '../../data/models/models.dart';
import '../../core/platform/platform.dart';
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
  late final GlobalKey<ScaffoldState> _scaffoldKey;
  StreamSubscription<String>? _pathSubscription;

  @override
  void initState() {
    super.initState();
    _scaffoldKey = GlobalKey<ScaffoldState>();
    _section = _sectionFromPath(currentPath());
    if (!currentPath().startsWith('/dashboard')) pushPath('/dashboard');
    _pathSubscription = pathChanges().listen((path) {
      if (mounted) setState(() => _section = _sectionFromPath(path));
    });
    _loadSites();
  }

  DashboardSection _sectionFromPath(String path) => switch (path) {
        '/dashboard/websites' => DashboardSection.websites,
        '/dashboard/realtime' => DashboardSection.realtime,
        '/dashboard/analytics/pages' => DashboardSection.pages,
        '/dashboard/analytics/visitors' => DashboardSection.visitors,
        '/dashboard/analytics/events' => DashboardSection.events,
        '/dashboard/tracking' => DashboardSection.tracking,
        '/dashboard/settings' => DashboardSection.settings,
        _ => DashboardSection.overview,
      };

  String _pathFor(DashboardSection section) => switch (section) {
        DashboardSection.overview => '/dashboard',
        DashboardSection.websites => '/dashboard/websites',
        DashboardSection.realtime => '/dashboard/realtime',
        DashboardSection.pages => '/dashboard/analytics/pages',
        DashboardSection.visitors => '/dashboard/analytics/visitors',
        DashboardSection.events => '/dashboard/analytics/events',
        DashboardSection.tracking => '/dashboard/tracking',
        DashboardSection.settings => '/dashboard/settings',
      };

  Future<void> _loadSites({String? preferredId}) async {
    try {
      final sites = await widget.api.listSites();
      if (!mounted) return;
      setState(() {
        _sites = sites;
        _selectedSite = _resolveSelectedSite(
          sites,
          preferredId ?? _selectedSite?.id ?? selectedSiteId(),
        );
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

  Site? _resolveSelectedSite(List<Site> sites, String? currentId) {
    if (sites.isEmpty) return null;
    if (currentId != null && sites.any((site) => site.id == currentId)) {
      return sites.firstWhere((site) => site.id == currentId);
    }
    return sites.first;
  }

  Future<void> _logout() async {
    await widget.api.logout();
    if (!mounted) return;
    widget.onLoggedOut();
  }

  void _navigate(DashboardSection section) {
    pushPath(_pathFor(section));
    setState(() => _section = section);
  }

  @override
  void dispose() {
    _pathSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mobile = Responsive.isMobile(context);
    return Scaffold(
      key: _scaffoldKey,
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
                  onMenuTap: () => _scaffoldKey.currentState?.openDrawer(),
                  onSiteChanged: (site) {
                    if (site != null) setSelectedSiteId(site.id);
                    setState(() => _selectedSite = site);
                  },
                  onLogout: _logout,
                ),
                Expanded(
                  child: _loading
                      ? const LoadingState()
                      : _error != null
                          ? ErrorState(
                              message: _error is ApiException
                                  ? (_error as ApiException).message
                                  : 'Unable to reach the API.',
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
    if (_selectedSite == null && _section != DashboardSection.websites) {
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

    if (_section == DashboardSection.websites) {
      return WebsitesPage(
        api: widget.api,
        sites: _sites,
        selectedSite: _selectedSite,
        onCreated: (site) {
          setSelectedSiteId(site.id);
          _loadSites(preferredId: site.id);
        },
        onSelected: (site) {
          setSelectedSiteId(site.id);
          setState(() => _selectedSite = site);
        },
        onRefresh: _loadSites,
      );
    }
    final site = _selectedSite!;
    return KeyedSubtree(
      key: ValueKey('${_section.name}-${site.id}'),
      child: switch (_section) {
        DashboardSection.overview => OverviewPage(api: widget.api, site: site),
        DashboardSection.websites => const SizedBox.shrink(),
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
