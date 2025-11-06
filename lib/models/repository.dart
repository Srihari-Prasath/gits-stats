/// Model for a GitHub repository
class Repository {
  final String name;
  final String? description;
  final String url;
  final int stargazersCount;
  final int forksCount;
  final int watchersCount;
  final int openIssuesCount;
  final String? primaryLanguage;
  final String? languageColor;
  final bool isPrivate;
  final bool isFork;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int diskUsage; // in KB

  Repository({
    required this.name,
    this.description,
    required this.url,
    required this.stargazersCount,
    required this.forksCount,
    required this.watchersCount,
    required this.openIssuesCount,
    this.primaryLanguage,
    this.languageColor,
    required this.isPrivate,
    required this.isFork,
    required this.createdAt,
    required this.updatedAt,
    required this.diskUsage,
  });

  factory Repository.fromJson(Map<String, dynamic> json) {
    return Repository(
      name: json['name'] as String,
      description: json['description'] as String?,
      url: json['url'] as String,
      stargazersCount: json['stargazerCount'] as int? ?? 0,
      forksCount: json['forkCount'] as int? ?? 0,
      watchersCount: json['watchers']['totalCount'] as int? ?? 0,
      openIssuesCount: json['issues']['totalCount'] as int? ?? 0,
      primaryLanguage: json['primaryLanguage']?['name'] as String?,
      languageColor: json['primaryLanguage']?['color'] as String?,
      isPrivate: json['isPrivate'] as bool? ?? false,
      isFork: json['isFork'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      diskUsage: json['diskUsage'] as int? ?? 0,
    );
  }

  String get sizeFormatted {
    if (diskUsage < 1024) {
      return '${diskUsage} KB';
    } else if (diskUsage < 1024 * 1024) {
      return '${(diskUsage / 1024).toStringAsFixed(1)} MB';
    } else {
      return '${(diskUsage / (1024 * 1024)).toStringAsFixed(1)} GB';
    }
  }
}
