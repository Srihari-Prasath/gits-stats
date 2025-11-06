/// App configuration and constants
class AppConfig {
  // GitHub API
  static const String githubGraphQLEndpoint = 'https://api.github.com/graphql';

  // GitHub Credentials - Add your personal access token here
  // Generate token at: https://github.com/settings/tokens
  // Required scopes: repo, read:user, read:org
  static const String githubToken = 'YOUR_GITHUB_TOKEN_HERE';
  static const String githubUsername = 'YOUR_GITHUB_USERNAME_HERE';

  // Storage keys (for backward compatibility)
  static const String tokenKey = 'github_token';
  static const String usernameKey = 'github_username';

  // App info
  static const String appName = 'GitTrack';
  static const String appVersion = '1.0.0';
}
