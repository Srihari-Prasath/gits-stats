# 🎨 GitTrack Design System

## Color Palette

### Background Colors

```
Primary Dark:    #0D1117 (Main background)
Secondary Dark:  #161B22 (Cards, containers)
Tertiary Dark:   #21262D (Elevated surfaces)
Border Color:    #30363D (Dividers, borders)
```

### Text Colors

```
Primary Text:    #C9D1D9 (Headings, important text)
Secondary Text:  #8B949E (Body text, descriptions)
Tertiary Text:   #6E7681 (Hints, subtle text)
```

### Accent Colors

```
Blue:    #58A6FF (Primary actions, links)
Purple:  #8B5CF6 (Longest streak)
Orange:  #FF9500 (Current streak)
```

### Contribution Colors (GitHub Green Scale)

```
None:        #161B22 (0 contributions)
Low:         #0E4429 (1-3 contributions)
Medium:      #006D32 (4-6 contributions)
High:        #26A641 (7-9 contributions)
Very High:   #39D353 (10+ contributions)
```

---

## Typography

### Headings

- **Display Large**: Bold, 32px - App title
- **Display Medium**: Bold, 28px - Section headers
- **Headline Large**: Semi-bold, 24px - Card titles
- **Headline Medium**: Semi-bold, 20px - Subtitles

### Body Text

- **Body Large**: Regular, 16px - Primary content
- **Body Medium**: Regular, 14px - Secondary content
- **Body Small**: Regular, 12px - Captions, hints

---

## Component Specifications

### Login Screen

#### App Logo

- Size: 100x100px
- Background: Secondary Dark
- Border: 2px Border Color
- Border Radius: 20px
- Icon: Code symbol, 50px, Blue

#### Input Fields

- Height: 56px
- Background: Secondary Dark
- Border: 1px Border Color
- Border Radius: 12px
- Focus Border: 2px Blue
- Padding: 16px

#### Login Button

- Height: 50px
- Width: Full
- Background: Blue
- Text: White, 16px, Semi-bold
- Border Radius: 12px
- No elevation

#### Help Card

- Background: Secondary Dark
- Border: 1px Border Color
- Border Radius: 12px
- Padding: 16px
- Icon: Info, 20px, Blue

---

### Home Screen

#### App Bar

- Background: Primary Dark
- Height: 56px
- No elevation
- Title: 20px, Semi-bold
- Actions: Refresh icon, Menu (three dots)

#### User Profile Card

- Background: Secondary Dark
- Border: 1px Border Color
- Border Radius: 16px
- Padding: 20px
- Avatar: 60x60px, Border: 2px Blue
- Name: 20px Bold
- Username: 14px, Secondary Text

#### Streak Cards (Current & Longest)

- Background: Secondary Dark
- Border: 1px Border Color
- Border Radius: 12px
- Padding: 16px
- Width: 50% (flex)
- Gap: 16px

**Card Structure**:

- Icon container: 48x48px, Color with 10% opacity, Border radius: 12px
- Icon: 32px, Full color
- Count: 32px Bold
- Title: 13px, Secondary text
- Unit: 12px, Tertiary text

#### Total Contributions Card

- Background: Secondary Dark
- Border: 1px Border Color
- Border Radius: 12px
- Padding: 20px
- Layout: Row (Icon + Content)

**Card Structure**:

- Icon container: 52x52px, Green with 10% opacity, Border radius: 12px
- Icon: 28px, Green
- Title: 14px, Secondary text
- Value: 28px Bold
- Subtitle: 12px, Tertiary text

#### Contribution Graph Card

- Background: Secondary Dark
- Border: 1px Border Color
- Border Radius: 12px
- Padding: 16px

**Graph Specifications**:

- Day cell: 12x12px
- Cell gap: 3px
- Border radius: 2px
- Empty cell border: 1px Border Color
- Month labels: 10px, Tertiary text
- Day labels: 10px, Tertiary text (odd rows only)
- Shows last 12 weeks
- Horizontal scroll enabled

**Legend**:

- Box size: 12x12px
- Gap: 3px
- Label: 11px, Tertiary text

---

## Screen States

### Loading State

- Centered spinner
- Blue color
- No background overlay

### Error State

- Centered column
- Error icon: 64px, Secondary text
- Title: 20px Bold
- Message: 14px, Secondary text
- Retry button: Blue background

### Empty State

- Centered text
- "No data available"
- Secondary text color

---

## Interactions

### Pull to Refresh

- Indicator color: Blue
- Trigger distance: Default
- Background: Transparent

### Card Tap

- No tap effect (informational cards)

### Button Press

- Slight scale animation (0.95)
- Disabled state: 50% opacity

### Scroll

- Smooth physics
- Overscroll glow: Blue

---

## Spacing System

```
xs:  4px   (tight spacing)
sm:  8px   (compact spacing)
md:  16px  (standard spacing)
lg:  24px  (loose spacing)
xl:  32px  (section spacing)
xxl: 48px  (major section spacing)
```

---

## Layout Grid

### Padding

- Screen edges: 16px
- Card internal: 16-20px
- Between sections: 16-24px

### Card Spacing

- Vertical gap: 16px
- Horizontal gap (row): 16px

### Content Width

- Maximum: Screen width - 32px (16px padding each side)
- Minimum card width: 150px

---

## Animations

### Page Transitions

- Type: Material slide
- Duration: 300ms
- Curve: Ease in out

### Loading Spinner

- Type: Circular
- Speed: Default
- Size: 20-40px depending on context

### Refresh Indicator

- Type: Material
- Color: Blue
- Speed: Default

---

## Icons

### System Icons (Material)

- `code` - App logo, GitHub
- `person` / `person_outline` - User profile
- `local_fire_department` - Current streak
- `emoji_events` - Longest streak
- `check_circle_outline` - Total contributions
- `grid_on` - Contribution graph
- `refresh` - Refresh action
- `more_vert` - Menu
- `logout` - Logout
- `error_outline` - Error state
- `info_outline` - Help/info
- `key_outlined` - Token input
- `visibility_outlined` / `visibility_off_outlined` - Password toggle

---

## Accessibility

### Text Contrast

- All text meets WCAG AA standards
- Primary text: 4.5:1 minimum contrast
- Secondary text: 3:1 minimum contrast

### Touch Targets

- Minimum size: 48x48px
- Buttons: 50x48px minimum
- Icon buttons: 48x48px

### Screen Readers

- All interactive elements labeled
- Proper semantic structure
- Status announcements for loading/errors

---

## Responsive Behavior

### Mobile (< 600px)

- Single column layout
- Full-width cards
- Streak cards in row (50% each)
- Graph scrolls horizontally

### Tablet (600-1024px)

- Same as mobile (optimized for portrait)
- Larger padding on landscape

### Desktop (> 1024px)

- Centered content (max 600px width)
- Same component structure

---

## Dark Mode Only

This app is designed exclusively for dark mode, inspired by GitHub's dark theme. No light mode available.

---

**Design Version**: 1.0.0
**Last Updated**: November 2025
**Platform**: Flutter (iOS, Android, Web)
