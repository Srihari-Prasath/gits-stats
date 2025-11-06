import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import '../config/app_config.dart';
import '../models/user_profile.dart';
import '../services/github_service.dart';
import '../theme/app_theme.dart';
import '../widgets/animated_card.dart';

/// Screen displaying user profile information
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  final _githubService = GitHubService();
  UserProfile? _profile;
  bool _isLoading = true;
  String? _error;

  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _loadProfile();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _scaleAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final token = AppConfig.githubToken;
      final username = AppConfig.githubUsername;

      _githubService.initialize(token);
      final profile = await _githubService.fetchUserProfile(username);

      setState(() {
        _profile = profile;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _isLoading ? null : _loadProfile,
            tooltip: 'Refresh',
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
                'Failed to load profile',
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
                onPressed: _loadProfile,
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

    if (_profile == null) {
      return const Center(child: Text('No profile data'));
    }

    return RefreshIndicator(
      onRefresh: _loadProfile,
      color: AppTheme.accentBlue,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildAvatarSection(),
            const SizedBox(height: 24),
            _buildStatsGrid(),
            const SizedBox(height: 16),
            if (_profile!.status != null) _buildStatusSection(),
            if (_profile!.status != null) const SizedBox(height: 16),
            if (_profile!.bio != null) _buildBioSection(),
            if (_profile!.bio != null) const SizedBox(height: 16),
            _buildContributionStatsSection(),
            const SizedBox(height: 16),
            _buildInfoSection(),
            const SizedBox(height: 16),
            if (_profile!.organizations.isNotEmpty)
              _buildOrganizationsSection(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarSection() {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Column(
        children: [
          Hero(
            tag: 'profile_avatar',
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppTheme.accentBlue, width: 3),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.accentBlue.withOpacity(0.3),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: ClipOval(
                child: CachedNetworkImage(
                  imageUrl: _profile!.avatarUrl,
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(),
                  errorWidget: (context, url, error) => const Icon(
                    Icons.person,
                    size: 60,
                    color: AppTheme.accentBlue,
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            _profile!.name ?? _profile!.login,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '@${_profile!.login}',
            style: const TextStyle(fontSize: 16, color: AppTheme.textSecondary),
          ),
          if (_profile!.pronouns != null) ...[
            const SizedBox(height: 4),
            Text(
              _profile!.pronouns!,
              style: const TextStyle(
                fontSize: 14,
                color: AppTheme.textTertiary,
              ),
            ),
          ],
          const SizedBox(height: 8),
          Text(
            'Member since ${DateFormat('MMMM yyyy').format(_profile!.createdAt)}',
            style: const TextStyle(fontSize: 13, color: AppTheme.textTertiary),
          ),
          if (_profile!.isHireable || _profile!.sponsorCount > 0) ...[
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_profile!.isHireable)
                  _buildBadge(
                    icon: Icons.work_outline,
                    label: 'Available for hire',
                    color: AppTheme.accentGreen,
                  ),
                if (_profile!.isHireable && _profile!.sponsorCount > 0)
                  const SizedBox(width: 8),
                if (_profile!.sponsorCount > 0)
                  _buildBadge(
                    icon: Icons.favorite,
                    label:
                        '${_profile!.sponsorCount} Sponsor${_profile!.sponsorCount > 1 ? 's' : ''}',
                    color: AppTheme.accentPurple,
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBadge({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusSection() {
    return AnimatedCard(
      delay: const Duration(milliseconds: 100),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.secondaryDark,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.accentBlue.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.accentBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.mood,
                color: AppTheme.accentBlue,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                _profile!.status!,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppTheme.textPrimary,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsGrid() {
    return AnimatedCard(
      delay: const Duration(milliseconds: 150),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppTheme.secondaryDark,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.borderColor),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatColumn('Repos', _profile!.publicReposCount),
                _buildDivider(),
                _buildStatColumn('Gists', _profile!.publicGistsCount),
                _buildDivider(),
                _buildStatColumn('Followers', _profile!.followersCount),
              ],
            ),
            const SizedBox(height: 16),
            Container(height: 1, color: AppTheme.borderColor),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatColumn('Following', _profile!.followingCount),
                _buildDivider(),
                _buildStatColumn('Stars', _profile!.totalStars),
                _buildDivider(),
                _buildStatColumn('Forks', _profile!.totalForks),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContributionStatsSection() {
    return AnimatedCard(
      delay: const Duration(milliseconds: 250),
      child: Container(
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
                Icon(Icons.bar_chart, size: 18, color: AppTheme.accentBlue),
                SizedBox(width: 8),
                Text(
                  'Contribution Stats',
                  style: TextStyle(
                    fontSize: 14,
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
                  child: _buildContributionStatCard(
                    icon: Icons.bug_report,
                    label: 'Issues',
                    count: _profile!.totalIssues,
                    color: AppTheme.accentOrange,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildContributionStatCard(
                    icon: Icons.merge_type,
                    label: 'Pull Requests',
                    count: _profile!.totalPullRequests,
                    color: AppTheme.accentPurple,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContributionStatCard({
    required IconData icon,
    required String label,
    required int count,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, size: 24, color: color),
          const SizedBox(height: 8),
          Text(
            count.toString(),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildStatColumn(String label, int value) {
    return Column(
      children: [
        Text(
          value.toString(),
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(height: 40, width: 1, color: AppTheme.borderColor);
  }

  Widget _buildBioSection() {
    return AnimatedCard(
      delay: const Duration(milliseconds: 200),
      child: Container(
        width: double.infinity,
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
                Icon(Icons.info_outline, size: 18, color: AppTheme.accentBlue),
                SizedBox(width: 8),
                Text(
                  'Bio',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              _profile!.bio!,
              style: const TextStyle(
                fontSize: 14,
                color: AppTheme.textSecondary,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection() {
    return AnimatedCard(
      delay: const Duration(milliseconds: 300),
      child: Container(
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
                Icon(Icons.info_outline, size: 18, color: AppTheme.accentBlue),
                SizedBox(width: 8),
                Text(
                  'Information',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (_profile!.company != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: _buildInfoRow(
                  Icons.business,
                  'Company',
                  _profile!.company!,
                ),
              ),
            if (_profile!.location != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: _buildInfoRow(
                  Icons.location_on,
                  'Location',
                  _profile!.location!,
                ),
              ),
            if (_profile!.email != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: _buildInfoRow(Icons.email, 'Email', _profile!.email!),
              ),
            if (_profile!.websiteUrl != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: _buildClickableInfoRow(
                  Icons.language,
                  'Website',
                  _profile!.websiteUrl!,
                ),
              ),
            if (_profile!.twitterUsername != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: _buildClickableInfoRow(
                  Icons.alternate_email,
                  'Twitter',
                  '@${_profile!.twitterUsername}',
                  url: 'https://twitter.com/${_profile!.twitterUsername}',
                ),
              ),
            Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: _buildInfoRow(
                Icons.calendar_today,
                'Joined',
                DateFormat('MMMM d, yyyy').format(_profile!.createdAt),
              ),
            ),
            if (_profile!.updatedAt != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: _buildInfoRow(
                  Icons.update,
                  'Last Updated',
                  DateFormat('MMMM d, yyyy').format(_profile!.updatedAt!),
                ),
              ),
            if (_profile!.sponsorCount > 0)
              _buildInfoRow(
                Icons.favorite,
                'Sponsors',
                '${_profile!.sponsorCount}',
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrganizationsSection() {
    return AnimatedCard(
      delay: const Duration(milliseconds: 350),
      child: Container(
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
              children: [
                const Icon(Icons.groups, size: 18, color: AppTheme.accentBlue),
                const SizedBox(width: 8),
                const Text(
                  'Organizations',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.accentBlue.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${_profile!.organizations.length}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.accentBlue,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 0.85,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: _profile!.organizations.length,
              itemBuilder: (context, index) {
                return _buildOrganizationBadge(_profile!.organizations[index]);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrganizationBadge(Organization org) {
    return Material(
      color: AppTheme.tertiaryDark,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _launchUrl(org.url),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.borderColor.withOpacity(0.5)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppTheme.accentBlue.withOpacity(0.3),
                    width: 2,
                  ),
                ),
                child: ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: org.avatarUrl,
                    placeholder: (context, url) => const Center(
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                    errorWidget: (context, url, error) => const Icon(
                      Icons.groups,
                      size: 24,
                      color: AppTheme.accentBlue,
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                org.name,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppTheme.accentBlue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 16, color: AppTheme.accentBlue),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppTheme.textTertiary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                text,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildClickableInfoRow(
    IconData icon,
    String label,
    String text, {
    String? url,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () => _launchUrl(url ?? text),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.accentBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 16, color: AppTheme.accentBlue),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.textTertiary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      text,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppTheme.accentBlue,
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.open_in_new,
                size: 14,
                color: AppTheme.textTertiary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
