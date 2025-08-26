import XCTest
@testable import FormatFinder

final class ModelTests: XCTestCase {
    
    // MARK: - GolfFormat Tests
    
    func testGolfFormatEquatable() {
        let format1 = GolfFormat(
            id: "scramble",
            name: "Scramble",
            category: "tournament",
            playerCount: "2-4 players",
            difficulty: "easy",
            shortDescription: "All players hit from the best shot",
            howToPlay: ["Everyone tees off"],
            scoringExample: "Team score: 4",
            diagram: "scramble_diagram"
        )
        
        let format2 = GolfFormat(
            id: "scramble",
            name: "Scramble",
            category: "tournament",
            playerCount: "2-4 players",
            difficulty: "easy",
            shortDescription: "All players hit from the best shot",
            howToPlay: ["Everyone tees off"],
            scoringExample: "Team score: 4",
            diagram: "scramble_diagram"
        )
        
        XCTAssertEqual(format1, format2)
    }
    
    func testGolfFormatHashable() {
        let format = GolfFormat(
            id: "scramble",
            name: "Scramble",
            category: "tournament",
            playerCount: "2-4 players",
            difficulty: "easy",
            shortDescription: "All players hit from the best shot",
            howToPlay: ["Everyone tees off"],
            scoringExample: "Team score: 4",
            diagram: "scramble_diagram"
        )
        
        var set = Set<GolfFormat>()
        set.insert(format)
        
        XCTAssertTrue(set.contains(format))
        XCTAssertEqual(set.count, 1)
    }
    
    func testGolfFormatIdentifiable() {
        let format = GolfFormat(
            id: "unique-id-123",
            name: "Test Format",
            category: "tournament",
            playerCount: "4 players",
            difficulty: "medium",
            shortDescription: "Test description",
            howToPlay: [],
            scoringExample: "Example",
            diagram: "test_diagram"
        )
        
        XCTAssertEqual(format.id, "unique-id-123")
    }
    
    // MARK: - CategoryFilter Tests
    
    func testCategoryFilterCases() {
        let allCase = CategoryFilter.all
        let tournamentCase = CategoryFilter.tournament
        let bettingCase = CategoryFilter.betting
        
        XCTAssertEqual(allCase.rawValue, "all")
        XCTAssertEqual(tournamentCase.rawValue, "tournament")
        XCTAssertEqual(bettingCase.rawValue, "betting")
    }
    
    func testCategoryFilterDisplayName() {
        XCTAssertEqual(CategoryFilter.all.displayName, "All")
        XCTAssertEqual(CategoryFilter.tournament.displayName, "Tournament")
        XCTAssertEqual(CategoryFilter.betting.displayName, "Betting")
    }
    
    // MARK: - Difficulty Tests
    
    func testDifficultyEnumeration() {
        let easy = Difficulty.easy
        let medium = Difficulty.medium
        let complex = Difficulty.complex
        
        XCTAssertEqual(easy.rawValue, "easy")
        XCTAssertEqual(medium.rawValue, "medium")
        XCTAssertEqual(complex.rawValue, "complex")
    }
    
    func testDifficultyColor() {
        XCTAssertNotNil(Difficulty.easy.color)
        XCTAssertNotNil(Difficulty.medium.color)
        XCTAssertNotNil(Difficulty.complex.color)
    }
    
    func testDifficultyFromString() {
        XCTAssertEqual(Difficulty(rawValue: "easy"), .easy)
        XCTAssertEqual(Difficulty(rawValue: "medium"), .medium)
        XCTAssertEqual(Difficulty(rawValue: "complex"), .complex)
        XCTAssertNil(Difficulty(rawValue: "invalid"))
    }
    
    // MARK: - FormatsData Tests
    
    func testFormatsDataDecoding() throws {
        let jsonData = """
        {
            "formats": [
                {
                    "id": "test-format",
                    "name": "Test Format",
                    "category": "tournament",
                    "playerCount": "2-4 players",
                    "difficulty": "easy",
                    "shortDescription": "Test description",
                    "howToPlay": ["Step 1", "Step 2"],
                    "scoringExample": "Example scoring",
                    "diagram": "test_diagram"
                }
            ]
        }
        """.data(using: .utf8)!
        
        let decoder = JSONDecoder()
        let formatsData = try decoder.decode(FormatsData.self, from: jsonData)
        
        XCTAssertEqual(formatsData.formats.count, 1)
        XCTAssertEqual(formatsData.formats[0].id, "test-format")
        XCTAssertEqual(formatsData.formats[0].name, "Test Format")
    }
    
    func testFormatsDataEncodingDecoding() throws {
        let originalFormat = GolfFormat(
            id: "encode-test",
            name: "Encode Test",
            category: "betting",
            playerCount: "2 players",
            difficulty: "complex",
            shortDescription: "Testing encoding",
            howToPlay: ["Rule 1", "Rule 2", "Rule 3"],
            scoringExample: "Score example",
            diagram: "encode_diagram"
        )
        
        let formatsData = FormatsData(formats: [originalFormat])
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let encoded = try encoder.encode(formatsData)
        
        let decoder = JSONDecoder()
        let decoded = try decoder.decode(FormatsData.self, from: encoded)
        
        XCTAssertEqual(decoded.formats.count, 1)
        XCTAssertEqual(decoded.formats[0], originalFormat)
    }
    
    // MARK: - Tab Tests
    
    func testTabEnumeration() {
        let browseTab = Tab.browse
        let savedTab = Tab.saved
        
        XCTAssertEqual(browseTab.title, "Browse")
        XCTAssertEqual(savedTab.title, "Saved")
        
        XCTAssertEqual(browseTab.icon, "square.grid.2x2")
        XCTAssertEqual(savedTab.icon, "bookmark.fill")
    }
    
    // MARK: - Validation Tests
    
    func testGolfFormatValidation() {
        let validFormat = GolfFormat(
            id: "valid",
            name: "Valid Format",
            category: "tournament",
            playerCount: "2-4 players",
            difficulty: "easy",
            shortDescription: "Valid description",
            howToPlay: ["Step 1"],
            scoringExample: "Example",
            diagram: "diagram"
        )
        
        XCTAssertTrue(validFormat.isValid)
        
        let invalidFormat = GolfFormat(
            id: "",
            name: "",
            category: "tournament",
            playerCount: "2-4 players",
            difficulty: "easy",
            shortDescription: "",
            howToPlay: [],
            scoringExample: "",
            diagram: ""
        )
        
        XCTAssertFalse(invalidFormat.isValid)
    }
    
    // MARK: - Format Category Tests
    
    func testFormatBelongsToCategory() {
        let tournamentFormat = GolfFormat(
            id: "t1",
            name: "Tournament Format",
            category: "tournament",
            playerCount: "4 players",
            difficulty: "easy",
            shortDescription: "Tournament format",
            howToPlay: ["Play"],
            scoringExample: "Score",
            diagram: "diagram"
        )
        
        XCTAssertTrue(tournamentFormat.belongsToCategory(.tournament))
        XCTAssertTrue(tournamentFormat.belongsToCategory(.all))
        XCTAssertFalse(tournamentFormat.belongsToCategory(.betting))
        
        let bettingFormat = GolfFormat(
            id: "b1",
            name: "Betting Format",
            category: "betting",
            playerCount: "2 players",
            difficulty: "medium",
            shortDescription: "Betting format",
            howToPlay: ["Bet"],
            scoringExample: "Money",
            diagram: "diagram"
        )
        
        XCTAssertTrue(bettingFormat.belongsToCategory(.betting))
        XCTAssertTrue(bettingFormat.belongsToCategory(.all))
        XCTAssertFalse(bettingFormat.belongsToCategory(.tournament))
    }
    
    // MARK: - Search Tests
    
    func testFormatMatchesSearchText() {
        let format = GolfFormat(
            id: "scramble",
            name: "Scramble",
            category: "tournament",
            playerCount: "2-4 players",
            difficulty: "easy",
            shortDescription: "All players hit from the best shot",
            howToPlay: ["Everyone tees off"],
            scoringExample: "Team score: 4",
            diagram: "scramble_diagram"
        )
        
        // Test name matching
        XCTAssertTrue(format.matchesSearchText("Scr"))
        XCTAssertTrue(format.matchesSearchText("scramble"))
        XCTAssertTrue(format.matchesSearchText("SCRAMBLE"))
        
        // Test description matching
        XCTAssertTrue(format.matchesSearchText("best shot"))
        XCTAssertTrue(format.matchesSearchText("players hit"))
        
        // Test no match
        XCTAssertFalse(format.matchesSearchText("wolf"))
        XCTAssertFalse(format.matchesSearchText("xyz"))
    }
    
    // MARK: - Array Extension Tests
    
    func testFormatArrayFiltering() {
        let formats = [
            GolfFormat(
                id: "1",
                name: "Format A",
                category: "tournament",
                playerCount: "4 players",
                difficulty: "easy",
                shortDescription: "Description A",
                howToPlay: ["Step"],
                scoringExample: "Score",
                diagram: "diagram"
            ),
            GolfFormat(
                id: "2",
                name: "Format B",
                category: "betting",
                playerCount: "2 players",
                difficulty: "medium",
                shortDescription: "Description B",
                howToPlay: ["Step"],
                scoringExample: "Score",
                diagram: "diagram"
            ),
            GolfFormat(
                id: "3",
                name: "Format C",
                category: "tournament",
                playerCount: "3 players",
                difficulty: "complex",
                shortDescription: "Description C",
                howToPlay: ["Step"],
                scoringExample: "Score",
                diagram: "diagram"
            )
        ]
        
        // Filter by category
        let tournamentFormats = formats.filter { $0.category == "tournament" }
        XCTAssertEqual(tournamentFormats.count, 2)
        
        let bettingFormats = formats.filter { $0.category == "betting" }
        XCTAssertEqual(bettingFormats.count, 1)
        
        // Filter by difficulty
        let easyFormats = formats.filter { $0.difficulty == "easy" }
        XCTAssertEqual(easyFormats.count, 1)
        
        // Filter by search text
        let searchResults = formats.filter { $0.matchesSearchText("Format A") }
        XCTAssertEqual(searchResults.count, 1)
        XCTAssertEqual(searchResults[0].id, "1")
    }
}