import Foundation

struct Movie: Identifiable, Codable, Hashable {
    let imdbId: String
    let title: String
    let year: Int
    let genres: [String]
    let rating: Double
    let summary: String
    let posterURL: String?
    let cast: String?
    let director: String?
    let runtime: String?
    let language: String?
    let availableOn: [String]

    var id: String { imdbId }

    var formattedRating: String {
        String(format: "%.1f", rating)
    }

    var ratingStars: String {
        let stars = Int(round(rating / 2))
        return String(repeating: "\u{2605}", count: stars) + String(repeating: "\u{2606}", count: 5 - stars)
    }

    var genreText: String {
        genres.joined(separator: ", ")
    }

    var posterImageURL: URL? {
        guard let urlString = posterURL else { return nil }
        let resized = urlString.replacingOccurrences(
            of: #"\._V1_.*\.jpg"#,
            with: "._V1_SX400.jpg",
            options: .regularExpression
        )
        return URL(string: resized)
    }

    var imdbURL: URL? {
        URL(string: "https://www.imdb.com/title/\(imdbId)/")
    }

    var ottPlatforms: [OTTPlatform] {
        availableOn.compactMap { OTTPlatform.fromName($0) }
    }
}

// MARK: - IMDb Suggestion API Response

struct IMDbSuggestionResponse: Codable {
    let d: [IMDbSuggestion]?
    let q: String?
}

struct IMDbSuggestion: Codable, Identifiable {
    let id: String
    let l: String
    let q: String?
    let qid: String?
    let rank: Int?
    let s: String?
    let y: Int?
    let yr: String?
    let i: IMDbImage?

    struct IMDbImage: Codable {
        let imageUrl: String
        let height: Int?
        let width: Int?
    }

    var isMovie: Bool {
        qid == "movie" || qid == "tvMovie" || q == "feature" || q == "TV movie"
    }

    var posterURL: URL? {
        guard let urlString = i?.imageUrl else { return nil }
        let resized = urlString.replacingOccurrences(
            of: #"\._V1_.*\.jpg"#,
            with: "._V1_SX400.jpg",
            options: .regularExpression
        )
        return URL(string: resized)
    }

    func toMovie() -> Movie {
        Movie(
            imdbId: id,
            title: l,
            year: y ?? 0,
            genres: [],
            rating: 0,
            summary: "",
            posterURL: i?.imageUrl,
            cast: s,
            director: nil,
            runtime: nil,
            language: nil,
            availableOn: []
        )
    }
}
