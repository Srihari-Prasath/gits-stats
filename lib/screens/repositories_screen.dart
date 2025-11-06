import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import '../config/app_config.dart';
import '../models/repository.dart';
import '../services/github_service.dart';
import '../theme/app_theme.dart';
import '../widgets/animated_card.dart';

/// Screen displaying user repositories
class RepositoriesScreen extends StatefulWidget {
  const RepositoriesScreen({super.key});

  @override
  State<RepositoriesScreen> createState() => _RepositoriesScreenState();
}

class _RepositoriesScreenState extends State<RepositoriesScreen>
    with SingleTickerProviderStateMixin {
  final _githubService = GitHubService();
  List<Repository>? _repositories;
  bool _isLoading = true;
  String? _error;
  String _filterType = 'all'; // all, public, private
  String _sortBy = 'updated'; // updated, stars, name

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _loadRepositories();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadRepositories() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final token = AppConfig.githubToken;
      final username = AppConfig.githubUsername;

      _githubService.initialize(token);
      final repos = await _githubService.fetchUserRepositories(username);

      setState(() {
        _repositories = repos;
        _isLoading = false;
      });

      _animationController.forward(from: 0);
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  List<Repository> get _filteredAndSortedRepos {
    if (_repositories == null) return [];

    var filtered = _repositories!.where((repo) {
      switch (_filterType) {
        case 'public':
          return !repo.isPrivate;
        case 'private':
          return repo.isPrivate;
        default:
          return true;
      }
    }).toList();

    filtered.sort((a, b) {
      switch (_sortBy) {
        case 'stars':
          return b.stargazersCount.compareTo(a.stargazersCount);
        case 'name':
          return a.name.toLowerCase().compareTo(b.name.toLowerCase());
        default: // updated
          return b.updatedAt.compareTo(a.updatedAt);
      }
    });

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Repositories'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _isLoading ? null : _loadRepositories,
            tooltip: 'Refresh',
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_list),
            onSelected: (value) {
              setState(() => _filterType = value);
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'all', child: Text('All Repos')),
              const PopupMenuItem(value: 'public', child: Text('Public Only')),
              const PopupMenuItem(
                value: 'private',
                child: Text('Private Only'),
              ),
            ],
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.sort),
            onSelected: (value) {
              setState(() => _sortBy = value);
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'updated',
                child: Text('Recently Updated'),
              ),
              const PopupMenuItem(value: 'stars', child: Text('Most Stars')),
              const PopupMenuItem(value: 'name', child: Text('Name')),
            ],
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
              const Text(
                'Failed to load repositories',
                style: TextStyle(
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
                onPressed: _loadRepositories,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.accentBlue,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      );
    }

    final repos = _filteredAndSortedRepos;

    if (repos.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.folder_open, size: 64, color: AppTheme.textSecondary),
            SizedBox(height: 16),
            Text(
              'No repositories found',
              style: TextStyle(fontSize: 18, color: AppTheme.textSecondary),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadRepositories,
      color: AppTheme.accentBlue,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: repos.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              return _buildStatsHeader(repos);
            }

            final repo = repos[index - 1];
            return AnimatedCard(
              delay: Duration(milliseconds: index * 50),
              child: _buildRepositoryCard(repo),
            );
          },
        ),
      ),
    );
  }

  Widget _buildStatsHeader(List<Repository> repos) {
    final totalStars = repos.fold<int>(
      0,
      (sum, repo) => sum + repo.stargazersCount,
    );
    final totalForks = repos.fold<int>(0, (sum, repo) => sum + repo.forksCount);
    final publicCount = repos.where((r) => !r.isPrivate).length;
    final privateCount = repos.where((r) => r.isPrivate).length;

    return AnimatedCard(
      delay: Duration.zero,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppTheme.secondaryDark,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.borderColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                Icon(Icons.bar_chart, size: 20, color: AppTheme.accentBlue),
                SizedBox(width: 8),
                Text(
                  'Repository Stats',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    'Total',
                    repos.length.toString(),
                    Icons.folder,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    'Public',
                    publicCount.toString(),
                    Icons.lock_open,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    'Private',
                    privateCount.toString(),
                    Icons.lock,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    'Stars',
                    totalStars.toString(),
                    Icons.star,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    'Forks',
                    totalForks.toString(),
                    Icons.fork_right,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    'Languages',
                    _getUniqueLanguages(repos).toString(),
                    Icons.code,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 20, color: AppTheme.textSecondary),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
        ),
      ],
    );
  }

  int _getUniqueLanguages(List<Repository> repos) {
    final languages = repos
        .where((r) => r.primaryLanguage != null)
        .map((r) => r.primaryLanguage!)
        .toSet();
    return languages.length;
  }

  Widget _buildRepositoryCard(Repository repo) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppTheme.secondaryDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => _openRepository(repo.url),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Icon(
                      repo.isPrivate ? Icons.lock : Icons.folder_open,
                      size: 20,
                      color: repo.isPrivate
                          ? AppTheme.accentOrange
                          : AppTheme.accentBlue,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        repo.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.accentBlue,
                        ),
                      ),
                    ),
                    if (repo.isFork)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.tertiaryDark,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'Fork',
                          style: TextStyle(
                            fontSize: 11,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ),
                  ],
                ),
                if (repo.description != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    repo.description!,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppTheme.textSecondary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                const SizedBox(height: 12),

                // Stats
                Wrap(
                  spacing: 16,
                  runSpacing: 8,
                  children: [
                    if (repo.primaryLanguage != null)
                      _buildRepoStat(
                        icon: Icons.circle,
                        label: repo.primaryLanguage!,
                        color: _parseColor(repo.languageColor),
                      ),
                    _buildRepoStat(
                      icon: Icons.star_border,
                      label: repo.stargazersCount.toString(),
                    ),
                    _buildRepoStat(
                      icon: Icons.fork_right,
                      label: repo.forksCount.toString(),
                    ),
                    if (repo.openIssuesCount > 0)
                      _buildRepoStat(
                        icon: Icons.error_outline,
                        label: repo.openIssuesCount.toString(),
                      ),
                    _buildRepoStat(
                      icon: Icons.storage,
                      label: repo.sizeFormatted,
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Footer
                Row(
                  children: [
                    const Icon(
                      Icons.access_time,
                      size: 14,
                      color: AppTheme.textTertiary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Updated ${_formatDate(repo.updatedAt)}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.textTertiary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRepoStat({
    required IconData icon,
    required String label,
    Color? color,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: color ?? AppTheme.textSecondary),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
        ),
      ],
    );
  }

  Color _parseColor(String? hexColor) {
    if (hexColor == null) return AppTheme.textSecondary;
    try {
      return Color(int.parse(hexColor.replaceAll('#', '0xFF')));
    } catch (e) {
      return AppTheme.textSecondary;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return '${difference.inMinutes}m ago';
      }
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else if (difference.inDays < 30) {
      return '${(difference.inDays / 7).floor()}w ago';
    } else if (difference.inDays < 365) {
      return DateFormat('MMM d').format(date);
    } else {
      return DateFormat('MMM d, yyyy').format(date);
    }
  }

  Future<void> _openRepository(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
