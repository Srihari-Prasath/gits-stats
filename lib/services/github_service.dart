import 'package:graphql_flutter/graphql_flutter.dart';
import '../config/app_config.dart';
import '../models/github_stats.dart';
import '../models/repository.dart';
import '../models/user_profile.dart';

/// Service to interact with GitHub GraphQL API
class GitHubService {
  GraphQLClient? _client;

  /// Initialize the GraphQL client with token
  void initialize(String token) {
    final HttpLink httpLink = HttpLink(AppConfig.githubGraphQLEndpoint);

    final AuthLink authLink = AuthLink(getToken: () async => 'Bearer $token');

    final Link link = authLink.concat(httpLink);

    _client = GraphQLClient(
      cache: GraphQLCache(store: InMemoryStore()),
      link: link,
    );
  }

  /// Fetch GitHub user contribution data
  Future<GitHubStats> fetchUserStats(String username) async {
    if (_client == null) {
      throw Exception(
        'GitHub service not initialized. Call initialize() first.',
      );
    }

    const String query = r'''
    query($username: String!) {
      user(login: $username) {
        name
        contributionsCollection {
          contributionCalendar {
            totalContributions
            weeks {
              contributionDays {
                date
                contributionCount
              }
            }
          }
        }
      }
    }
    ''';

    final QueryOptions options = QueryOptions(
      document: gql(query),
      variables: {'username': username},
    );

    final QueryResult result = await _client!.query(options);

    if (result.hasException) {
      throw Exception(
        'Failed to fetch GitHub data: ${result.exception.toString()}',
      );
    }

    if (result.data == null) {
      throw Exception('No data received from GitHub API');
    }

    return GitHubStats.fromGraphQL(result.data!, username);
  }

  /// Verify if token and username are valid
  Future<bool> verifyCredentials(String token, String username) async {
    try {
      initialize(token);
      await fetchUserStats(username);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Fetch user profile information
  Future<UserProfile> fetchUserProfile(String username) async {
    if (_client == null) {
      throw Exception(
        'GitHub service not initialized. Call initialize() first.',
      );
    }

    const String query = r'''
    query($username: String!) {
      user(login: $username) {
        login
        name
        bio
        pronouns
        company
        location
        email
        websiteUrl
        twitterUsername
        avatarUrl
        isHireable
        status {
          message
        }
        followers {
          totalCount
        }
        following {
          totalCount
        }
        repositories(first: 100, ownerAffiliations: [OWNER]) {
          totalCount
          nodes {
            stargazerCount
            forkCount
          }
        }
        gists {
          totalCount
        }
        issues(first: 1) {
          totalCount
        }
        pullRequests(first: 1) {
          totalCount
        }
        sponsorshipsAsMaintainer(first: 1) {
          totalCount
        }
        organizations(first: 10) {
          nodes {
            login
            name
            avatarUrl
            description
            url
          }
        }
        createdAt
        updatedAt
      }
    }
    ''';

    final QueryOptions options = QueryOptions(
      document: gql(query),
      variables: {'username': username},
    );

    final QueryResult result = await _client!.query(options);

    if (result.hasException) {
      throw Exception(
        'Failed to fetch user profile: ${result.exception.toString()}',
      );
    }

    if (result.data == null) {
      throw Exception('No data received from GitHub API');
    }

    return UserProfile.fromJson(result.data!['user']);
  }

  /// Fetch user repositories
  Future<List<Repository>> fetchUserRepositories(
    String username, {
    int first = 30,
    String? after,
  }) async {
    if (_client == null) {
      throw Exception(
        'GitHub service not initialized. Call initialize() first.',
      );
    }

    const String query = r'''
    query($username: String!, $first: Int!, $after: String) {
      user(login: $username) {
        repositories(
          first: $first,
          after: $after,
          orderBy: {field: UPDATED_AT, direction: DESC},
          ownerAffiliations: [OWNER]
        ) {
          nodes {
            name
            description
            url
            stargazerCount
            forkCount
            watchers {
              totalCount
            }
            issues(states: OPEN) {
              totalCount
            }
            primaryLanguage {
              name
              color
            }
            isPrivate
            isFork
            createdAt
            updatedAt
            diskUsage
          }
        }
      }
    }
    ''';

    final QueryOptions options = QueryOptions(
      document: gql(query),
      variables: {'username': username, 'first': first, 'after': after},
    );

    final QueryResult result = await _client!.query(options);

    if (result.hasException) {
      throw Exception(
        'Failed to fetch repositories: ${result.exception.toString()}',
      );
    }

    if (result.data == null) {
      throw Exception('No data received from GitHub API');
    }

    final nodes = result.data!['user']['repositories']['nodes'] as List;
    return nodes.map((node) => Repository.fromJson(node)).toList();
  }
}
