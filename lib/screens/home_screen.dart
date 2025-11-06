import 'package:flutter/material.dart';
import '../config/app_config.dart';
import '../models/github_stats.dart';
import '../services/github_service.dart';
import '../theme/app_theme.dart';
import '../widgets/contribution_graph.dart';
import '../widgets/stats_card.dart';
import '../widgets/streak_card.dart';
import '../widgets/animated_card.dart';

/// Main home screen displaying GitHub stats
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final _githubService = GitHubService();

  GitHubStats? _stats;
  bool _isLoading = true;
  String? _error;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _loadData();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Use hardcoded credentials from AppConfig
      final token = AppConfig.githubToken;
      final username = AppConfig.githubUsername;

      _githubService.initialize(token);
      final stats = await _githubService.fetchUserStats(username);

      setState(() {
        _stats = stats;
        _isLoading = false;
      });

      _animationController.forward();
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _showAbout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.secondaryDark,
        title: Row(
          children: const [
            Icon(Icons.info_outline, color: AppTheme.accentBlue),
            SizedBox(width: 12),
            Text(
              'About GitTrack',
              style: TextStyle(color: AppTheme.textPrimary),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Version: ${AppConfig.appVersion}',
              style: const TextStyle(color: AppTheme.textSecondary),
            ),
            const SizedBox(height: 8),
            Text(
              'GitHub: @${AppConfig.githubUsername}',
              style: const TextStyle(color: AppTheme.textSecondary),
            ),
            const SizedBox(height: 16),
            const Text(
              'Track your GitHub contribution streak with style!',
              style: TextStyle(color: AppTheme.textSecondary, fontSize: 14),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Close',
              style: TextStyle(color: AppTheme.accentBlue),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GitTrack'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _isLoading ? null : _loadData,
            tooltip: 'Refresh',
          ),
          PopupMenuButton(
            icon: const Icon(Icons.more_vert),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'about',
                child: Row(
                  children: [
                    Icon(Icons.info_outline, size: 20),
                    SizedBox(width: 12),
                    Text('About'),
                  ],
                ),
              ),
            ],
            onSelected: (value) {
              if (value == 'about') _showAbout();
            },
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 64,
                color: AppTheme.textSecondary,
              ),
              const SizedBox(height: 16),
              Text(
                'Failed to load data',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _error!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppTheme.textSecondary),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _loadData,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.accentBlue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (_stats == null) {
      return const Center(child: Text('No data available'));
    }

    return RefreshIndicator(
      onRefresh: _loadData,
      color: AppTheme.accentBlue,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // User info
            AnimatedCard(delay: Duration.zero, child: _buildUserInfo()),
            const SizedBox(height: 24),

            // Streak cards
            Row(
              children: [
                Expanded(
                  child: AnimatedCard(
                    delay: const Duration(milliseconds: 100),
                    child: StreakCard(
                      title: 'Current Streak',
                      count: _stats!.currentStreak,
                      icon: Icons.local_fire_department,
                      color: AppTheme.accentOrange,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: AnimatedCard(
                    delay: const Duration(milliseconds: 200),
                    child: StreakCard(
                      title: 'Longest Streak',
                      count: _stats!.longestStreak,
                      icon: Icons.emoji_events,
                      color: AppTheme.accentPurple,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Total contributions
            AnimatedCard(
              delay: const Duration(milliseconds: 300),
              child: StatsCard(
                title: 'Total Contributions',
                value: _stats!.totalContributions.toString(),
                subtitle: 'in the last year',
                icon: Icons.check_circle_outline,
                color: AppTheme.contributionVeryHigh,
              ),
            ),
            const SizedBox(height: 24),

            // Contribution graph
            AnimatedCard(
              delay: const Duration(milliseconds: 500),
              child: ContributionGraph(
                contributionDays: _stats!.contributionDays,
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfo() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.secondaryDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppTheme.tertiaryDark,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: AppTheme.accentBlue, width: 2),
            ),
            child: const Icon(
              Icons.person,
              size: 32,
              color: AppTheme.accentBlue,
            ),
          ),
          const SizedBox(width: 16),

          // User details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _stats!.name ?? _stats!.username,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '@${_stats!.username}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          // GitHub icon
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.tertiaryDark,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.code, color: AppTheme.accentBlue),
          ),
        ],
      ),
    );
  }
}
