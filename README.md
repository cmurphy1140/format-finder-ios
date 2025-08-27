# Format Finder - Golf Game Formats iOS App

A comprehensive iOS reference app for golf game formats, featuring 20+ game types with detailed explanations, score tracking, and personalized format recommendations.

## Features

### 🏌️ Browse Formats
- **20+ Golf Formats**: Including Scramble, Best Ball, Skins, Nassau, Vegas, Wolf, and many more
- **Category Filtering**: Tournament and Betting formats
- **Search Functionality**: Quickly find formats by name or description
- **Difficulty Indicators**: Easy, Medium, and Complex formats clearly marked

### 🎯 Smart Format Selector
- **Personalized Recommendations**: Based on:
  - Number of players (1-8)
  - Skill level (Beginner, Mixed, Advanced)
  - Time available (9 holes, Full round, Quick game)
  - Game style (Casual, Competitive, Betting)
- **Top 3 Recommendations**: With explanations of why each format works for your group

### 📊 Score Tracking
- **Active Game Management**: Track scores for any format
- **Player Management**: Add multiple players with handicaps
- **Hole-by-Hole Scoring**: 18-hole scorecards
- **Format-Specific Scoring**: 
  - Stableford points calculation
  - Match play status tracking
  - Skins carryover handling
  - Vegas number combinations

### 💾 Saved Formats
- **Bookmark System**: Save your favorite formats for quick access
- **Persistent Storage**: Bookmarks saved across app sessions

### 📚 Golf Glossary
- **25+ Common Terms**: From "Ace" to "Wood"
- **Quick Reference**: Essential golf terminology explained

## Technical Details

### Requirements
- iOS 17.0+
- Xcode 15.0+
- Swift 5.9+

### Architecture
- **SwiftUI**: Modern declarative UI framework
- **MVVM Pattern**: Clean separation of concerns
- **UserDefaults**: Persistent storage for bookmarks and preferences
- **JSON Data**: Flexible format definitions

### Project Structure
```
FormatFinder/
├── FormatFinderApp.swift       # Main app file with all views and logic
├── Models/
│   ├── GolfFormat.swift        # Format data model
│   └── ScoreTracking.swift     # Score tracking models
├── Resources/
│   └── formats.json            # Golf formats database
├── Assets.xcassets/
│   └── FormatImages/          # SVG images for each format
└── Views/                      # Additional view components
```

## Installation

1. Clone the repository
```bash
git clone https://github.com/yourusername/format-finder.git
```

2. Open in Xcode
```bash
cd format-finder
open FormatFinder.xcodeproj
```

3. Build and run (⌘+R)

## Game Formats Included

### Tournament Formats
- Scramble
- Best Ball
- Alternate Shot
- Stableford
- Match Play
- Chapman
- Shamble
- Four-Man Cha Cha
- Quota
- Pink Ball
- Greensome
- Tombstone
- String

### Betting Formats
- Skins
- Nassau
- Wolf
- Vegas
- Bingo Bango Bongo
- Defender
- Rabbit
- Snake
- Daytona
- Lone Wolf

## Features Roadmap

- [ ] Export scorecards as PDF
- [ ] Share formats via Messages/Email
- [ ] Custom format builder
- [ ] Team/pairing generator with handicap balancing
- [ ] Historical score tracking
- [ ] Apple Watch companion app
- [ ] Multiplayer sync via iCloud
- [ ] Video tutorials for complex formats
- [ ] AR shot visualization

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is available under the MIT License. See the LICENSE file for more info.

## Contact

Created by Connor Murphy - Feel free to reach out with questions or suggestions!

---

**Format Finder** - Making golf more fun, one format at a time! ⛳