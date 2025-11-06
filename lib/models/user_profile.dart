/// Model for GitHub organization membership
class Organization {
  final String login;
  final String name;
  final String avatarUrl;
  final String? description;
  final String url;

  Organization({
    required this.login,
    required this.name,
    required this.avatarUrl,
    this.description,
    required this.url,
  });

  factory Organization.fromJson(Map<String, dynamic> json) {
    return Organization(
      login: json['login'] as String,
      name: json['name'] as String? ?? json['login'] as String,
      avatarUrl: json['avatarUrl'] as String,
      description: json['description'] as String?,
      url: json['url'] as String,
    );
  }
}

/// Model for GitHub user profile information
class UserProfile {
  final String login;
  final String? name;
  final String? bio;
  final String? company;
  final String? location;
  final String? email;
  final String? websiteUrl;
  final String? twitterUsername;
  final String avatarUrl;
  final String? pronouns;
  final int followersCount;
  final int followingCount;
  final int publicReposCount;
  final int publicGistsCount;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final List<Organization> organizations;
  final int totalStars;
  final int totalForks;
  final String? status;
  final bool isHireable;
  final int totalIssues;
  final int totalPullRequests;
  final int sponsorCount;

  UserProfile({
    required this.login,
    this.name,
    this.bio,
    this.company,
    this.location,
    this.email,
    this.websiteUrl,
    this.twitterUsername,
    required this.avatarUrl,
    this.pronouns,
    required this.followersCount,
    required this.followingCount,
    required this.publicReposCount,
    required this.publicGistsCount,
    required this.createdAt,
    this.updatedAt,
    this.organizations = const [],
    this.totalStars = 0,
    this.totalForks = 0,
    this.status,
    this.isHireable = false,
    this.totalIssues = 0,
    this.totalPullRequests = 0,
    this.sponsorCount = 0,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    // Parse organizations
    final orgsList = json['organizations']?['nodes'] as List? ?? [];
    final organizations = orgsList
        .map((org) => Organization.fromJson(org))
        .toList();

    // Calculate total stars and forks
    final reposList = json['repositories']?['nodes'] as List? ?? [];
    int totalStars = 0;
    int totalForks = 0;
    for (var repo in reposList) {
      totalStars += (repo['stargazerCount'] as int? ?? 0);
      totalForks += (repo['forkCount'] as int? ?? 0);
    }

    return UserProfile(
      login: json['login'] as String,
      name: json['name'] as String?,
      bio: json['bio'] as String?,
      company: json['company'] as String?,
      location: json['location'] as String?,
      email: json['email'] as String?,
      websiteUrl: json['websiteUrl'] as String?,
      twitterUsername: json['twitterUsername'] as String?,
      avatarUrl: json['avatarUrl'] as String,
      pronouns: json['pronouns'] as String?,
      followersCount: json['followers']['totalCount'] as int? ?? 0,
      followingCount: json['following']['totalCount'] as int? ?? 0,
      publicReposCount: json['repositories']['totalCount'] as int? ?? 0,
      publicGistsCount: json['gists']['totalCount'] as int? ?? 0,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
      organizations: organizations,
      totalStars: totalStars,
      totalForks: totalForks,
      status: json['status']?['message'] as String?,
      isHireable: json['isHireable'] as bool? ?? false,
      totalIssues: json['issues']['totalCount'] as int? ?? 0,
      totalPullRequests: json['pullRequests']['totalCount'] as int? ?? 0,
      sponsorCount:
          json['sponsorshipsAsMaintainer']?['totalCount'] as int? ?? 0,
    );
  }
}
