import 'package:flutter/material.dart';

import '../../app/router.dart';
import '../../app/theme/colors.dart';
import '../../core/errors/api_exception.dart';
import '../../core/platform/platform.dart';
import '../../core/responsive/responsive.dart';
import '../../data/api/api_client.dart';
import '../../data/models/models.dart';
import '../../data/repositories/repositories.dart';
import '../../shared/widgets/app_button.dart';
import '../../shared/widgets/dashboard_scaffold.dart';
import '../../shared/icons/dashboard_icons.dart';
import '../events/events_page.dart';
import '../overview/overview_page.dart';
import '../pages/pages_page.dart';
import '../settings/settings_page.dart';
import '../tracking/tracking_page.dart';
import '../visitors/visitors_page.dart';
import '../websites/websites_page.dart';
import 'dashboard_sidebar.dart';
import 'dashboard_top_bar.dart';

class DashboardShell extends StatefulWidget {
  const DashboardShell({
    super.key,
    required this.api,
    required this.user,
    required this.routePath,
    required this.onRouteChanged,
    required this.onLoggedOut,
  });

  final ApiClient api;
  final User user;
  final String routePath;
  final ValueChanged<String> onRouteChanged;
  final VoidCallback onLoggedOut;

  @override
  State<DashboardShell> createState() => _DashboardShellState();
}

class _DashboardShellState extends State<DashboardShell> {
  late final WebsiteRepository _websites;
  late final AnalyticsRepository _analytics;

  List<Site> _sites = [];
  Site? _selectedSite;
  DashboardSection _section = DashboardSection.overview;
  bool _loading = true;
  Object? _error;
  bool _openCreateForm = false;
  late final GlobalKey<ScaffoldState> _scaffoldKey;

  @override
  void initState() {
    super.initState();
    _websites = WebsiteRepository(widget.api);
    _analytics = AnalyticsRepository(widget.api);
    _scaffoldKey = GlobalKey<ScaffoldState>();
    _section = DashboardRoutes.sectionFromPath(widget.routePath);
    _loadSites();
  }

  @override
  void didUpdateWidget(covariant DashboardShell oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.routePath != widget.routePath) {
      _section = DashboardRoutes.sectionFromPath(widget.routePath);
      _openCreateForm = false;
    }
  }

  Future<void> _loadSites({String? preferredId}) async {
    try {
      final sites = await _websites.listSites();
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
      if (error is ApiException && error.isUnauthorized) {
        widget.onLoggedOut();
        return;
      }
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
    try {
      await widget.api.logout();
    } catch (_) {
    }
    setSelectedSiteId(null);
    if (!mounted) return;
    widget.onLoggedOut();
  }

  void _navigate(DashboardSection section, {bool openCreateForm = false}) {
    widget.onRouteChanged(DashboardRoutes.pathFor(section));
    setState(() {
      _section = section;
      _openCreateForm = openCreateForm;
    });
  }

  void _goToAddWebsite() {
    _navigate(DashboardSection.websites, openCreateForm: true);
  }

  @override
  void dispose() {
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
            Container(
              width: 228,
              decoration: const BoxDecoration(
                border: Border(right: BorderSide(color: AppColors.border)),
              ),
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
                              message: friendlyError(_error!),
                              onRetry: () {
                                setState(() {
                                  _loading = true;
                                  _error = null;
                                });
                                _loadSites();
                              },
                            )
                          : AnimatedSwitcher(
                              duration: const Duration(milliseconds: 190),
                              reverseDuration:
                                  const Duration(milliseconds: 140),
                              switchInCurve: Curves.easeOutCubic,
                              switchOutCurve: Curves.easeInCubic,
                              layoutBuilder: (currentChild, previousChildren) {
                                return Stack(
                                  alignment: Alignment.topLeft,
                                  children: [
                                    ...previousChildren,
                                    if (currentChild != null) currentChild,
                                  ],
                                );
                              },
                              transitionBuilder: (child, animation) {
                                final offset = Tween<Offset>(
                                  begin: const Offset(0, 0.012),
                                  end: Offset.zero,
                                ).animate(animation);
                                return FadeTransition(
                                  opacity: animation,
                                  child: SlideTransition(
                                    position: offset,
                                    child: child,
                                  ),
                                );
                              },
                              child: KeyedSubtree(
                                key: ValueKey(
                                  '${_section.name}-${_selectedSite?.id ?? 'none'}',
                                ),
                                child: _buildContent(),
                              ),
                            ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (_section == DashboardSection.websites) {
      return WebsitesPage(
        websites: _websites,
        sites: _sites,
        selectedSite: _selectedSite,
        initiallyShowForm: _openCreateForm || _sites.isEmpty,
        onCreated: (site) {
          setSelectedSiteId(site.id);
          setState(() => _openCreateForm = false);
          _loadSites(preferredId: site.id);
        },
        onSelected: (site) {
          setSelectedSiteId(site.id);
          setState(() => _selectedSite = site);
        },
        onDeleted: (siteId) async {
          if (_selectedSite?.id == siteId) {
            setSelectedSiteId(null);
          }
          await _loadSites();
        },
        onRefresh: _loadSites,
      );
    }

    if (_selectedSite == null) {
      return PageFrame(
        title: 'Welcome',
        subtitle: 'Create your first website to start collecting analytics.',
        child: EmptyState(
          icon: DashboardIcons.websites,
          title: 'No websites yet',
          body:
              'Add a website, copy the tracking script, and your first visitor will appear here.',
          action: AppButton(
            label: 'Add website',
            icon: DashboardIcons.add,
            onPressed: _goToAddWebsite,
          ),
        ),
      );
    }

    final site = _selectedSite!;
    return KeyedSubtree(
      key: ValueKey('${_section.name}-${site.id}'),
      child: switch (_section) {
        DashboardSection.overview => OverviewPage(
            analytics: _analytics,
            site: site,
          ),
        DashboardSection.websites => const SizedBox.shrink(),
        DashboardSection.pages => PagesPage(
            analytics: _analytics,
            site: site,
          ),
        DashboardSection.visitors => VisitorsPage(
            analytics: _analytics,
            site: site,
          ),
        DashboardSection.events => const EventsPage(),
        DashboardSection.tracking => TrackingPage(site: site),
        DashboardSection.settings => SettingsPage(
            websites: _websites,
            user: widget.user,
            site: site,
            onDeleted: () async {
              setSelectedSiteId(null);
              await _loadSites();
              if (mounted) _navigate(DashboardSection.websites);
            },
            onLogout: _logout,
          ),
      },
    );
  }
}
