# 📖 GitTrack Usage Guide

## Quick Start

### 1️⃣ First Time Setup

When you first open the app, you'll see the **Login Screen**:

1. Enter your **GitHub Username** (e.g., `your-username`)
2. Enter your **Personal Access Token** (starts with `ghp_`)
3. Tap **Connect GitHub**

The app will verify your credentials and take you to the home screen.

---

## 🔑 Getting Your GitHub Token

### Step-by-Step:

1. **Go to GitHub**: Visit [github.com](https://github.com)
2. **Open Settings**: Click your profile picture → Settings
3. **Developer Settings**: Scroll down and click "Developer settings" in the left sidebar
4. **Personal Access Tokens**: Click "Personal access tokens" → "Tokens (classic)"
5. **Generate New Token**: Click "Generate new token (classic)"
6. **Configure Token**:
   - **Note**: Name it something like "GitTrack App"
   - **Expiration**: Choose your preferred expiration (recommend 90 days or No expiration)
   - **Select scopes**:
     - ✅ `read:user` - Read user profile data
     - ✅ `repo` - Full control of private repositories (just for reading your contributions)
7. **Generate**: Scroll down and click "Generate token"
8. **Copy Token**: ⚠️ **IMPORTANT** - Copy the token immediately! You won't be able to see it again.

---

## 📱 Using the App

### Home Screen Features

#### 👤 User Profile Card

- Displays your name and GitHub username
- Shows your profile information

#### 🔥 Current Streak Card

- Shows how many consecutive days you've made contributions
- Updates automatically based on your GitHub activity
- Orange flame icon indicates active streak

#### 🏆 Longest Streak Card

- Displays your best streak record
- Purple trophy icon highlights your achievement
- Personal best tracker

#### 📊 Total Contributions Card

- Shows total contributions in the last year
- Green checkmark indicates completed work
- Includes all commits, PRs, and issues

#### 📈 Contribution Graph

- GitHub-style heatmap visualization
- Last 12 weeks of activity
- Color intensity shows contribution frequency:
  - **Dark Gray**: No contributions
  - **Light Green**: 1-3 contributions
  - **Medium Green**: 4-6 contributions
  - **Bright Green**: 7-9 contributions
  - **Vivid Green**: 10+ contributions
- Hover over any day to see exact contribution count

### 🔄 Refreshing Data

**Method 1**: Pull down on the home screen to refresh
**Method 2**: Tap the refresh icon (↻) in the top-right corner

### 🚪 Logging Out

1. Tap the **three dots menu** (⋮) in the top-right corner
2. Select **Logout**
3. Your token will be securely removed from the device

---

## 🎨 Color Guide

### Contribution Levels

- **Level 0** (No contributions): `#161B22` - Dark gray
- **Level 1** (1-3 contributions): `#0E4429` - Light green
- **Level 2** (4-6 contributions): `#006D32` - Medium green
- **Level 3** (7-9 contributions): `#26A641` - Bright green
- **Level 4** (10+ contributions): `#39D353` - Vivid green

### Accent Colors

- **Primary Blue**: Used for buttons and highlights
- **Purple**: Used for longest streak
- **Orange**: Used for current streak

---

## 🔐 Security & Privacy

### Your Data is Safe

- ✅ Tokens are stored **locally** on your device using secure encryption
- ✅ No data is sent to any third-party servers
- ✅ Direct communication with GitHub API only
- ✅ No tracking or analytics
- ✅ Completely offline after initial data fetch

### Token Permissions

The app only needs:

- **`read:user`**: To read your public profile
- **`repo`**: To access your contribution data

The app **CANNOT**:

- ❌ Make commits on your behalf
- ❌ Delete repositories
- ❌ Modify your account
- ❌ Access private data beyond contributions

---

## 🛠️ Troubleshooting

### "Login Failed" Error

**Possible Causes**:

1. Invalid token - make sure you copied it correctly
2. Token expired - generate a new one
3. Insufficient permissions - ensure `read:user` scope is enabled
4. Wrong username - check spelling

**Solution**: Double-check your username and generate a fresh token with correct permissions.

---

### "Failed to Load Data" Error

**Possible Causes**:

1. No internet connection
2. GitHub API is down (rare)
3. Token was revoked

**Solution**:

- Check your internet connection
- Try pulling down to refresh
- If problem persists, log out and log in again

---

### App Crashes or Freezes

**Solution**:

1. Close and reopen the app
2. Clear app data (you'll need to log in again)
3. Reinstall the app

---

## 💡 Tips & Tricks

### Keep Your Streak Alive

- Make at least one contribution daily (commit, PR, or issue)
- The app checks contributions up to midnight in your time zone
- Empty commits count! Use: `git commit --allow-empty -m "Keep streak alive"`

### Understanding Streaks

- **Current Streak**: Consecutive days from today backwards
- **Longest Streak**: Your best streak ever recorded
- If you miss a day, your current streak resets to 0

### Best Practices

- 🔄 **Refresh regularly**: Pull to refresh to get latest data
- 🔐 **Rotate tokens**: Generate new tokens every 90 days for security
- 📊 **Check weekly**: Monitor your contribution patterns
- 🎯 **Set goals**: Use the longest streak as motivation

---

## 📞 Support

Having issues? Here are your options:

1. **Check this guide** - Most answers are here
2. **GitHub Issues** - Report bugs or request features
3. **Contact Developer** - Reach out for help

---

## 🎯 Pro Tips

### Maximize Your Contributions

1. Commit early and often
2. Create meaningful PRs
3. Participate in discussions
4. Document your code
5. Help others with issues

### Using GitTrack Effectively

1. **Morning Check**: Start your day by checking your streak
2. **Evening Reminder**: Make sure you've contributed today
3. **Weekly Review**: Analyze your contribution patterns
4. **Set Milestones**: Aim for specific streak goals (7, 30, 100 days)

---

**Remember**: Consistency is key! Even small contributions count. Happy coding! 🚀

---

Last Updated: November 2025
Version: 1.0.0
