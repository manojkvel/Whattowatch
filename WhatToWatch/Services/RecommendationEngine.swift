import Foundation

final class RecommendationEngine {
    static let shared = RecommendationEngine()
    private let database = MovieDatabase.shared

    private init() {}

    struct RecommendationSection: Identifiable {
        let id = UUID()
        let title: String
        let subtitle: String
        let movies: [Movie]
    }

    func getHomeRecommendations(limit: Int? = nil) -> [RecommendationSection] {
        var sections: [RecommendationSection] = []
        let cap = 8 // max movies per horizontal row

        // Top Rated
        let topRated = database.allMovies
            .sorted { $0.rating > $1.rating }
            .prefix(cap)
        sections.append(RecommendationSection(
            title: "Top Rated on IMDb",
            subtitle: "Highest rated movies and shows",
            movies: Array(topRated)
        ))

        // Bollywood
        let bollywood = database.byLanguage("Hindi")
            .sorted { $0.rating > $1.rating }
            .prefix(cap)
        if !bollywood.isEmpty {
            sections.append(RecommendationSection(
                title: "Bollywood Picks",
                subtitle: "Best Hindi movies and series",
                movies: Array(bollywood)
            ))
        }

        // Tamil Cinema
        let tamil = database.byLanguage("Tamil")
            .sorted { $0.rating > $1.rating }
            .prefix(cap)
        if !tamil.isEmpty {
            sections.append(RecommendationSection(
                title: "Tamil Cinema",
                subtitle: "Top Tamil movies",
                movies: Array(tamil)
            ))
        }

        // Telugu Cinema
        let telugu = database.byLanguage("Telugu")
            .sorted { $0.rating > $1.rating }
            .prefix(cap)
        if !telugu.isEmpty {
            sections.append(RecommendationSection(
                title: "Telugu Cinema",
                subtitle: "Top Telugu movies",
                movies: Array(telugu)
            ))
        }

        // Malayalam Cinema
        let malayalam = database.byLanguage("Malayalam")
            .sorted { $0.rating > $1.rating }
            .prefix(cap)
        if !malayalam.isEmpty {
            sections.append(RecommendationSection(
                title: "Malayalam Cinema",
                subtitle: "Top Malayalam movies",
                movies: Array(malayalam)
            ))
        }

        // Hollywood Blockbusters
        let hollywood = database.byLanguage("English")
            .sorted { $0.rating > $1.rating }
            .prefix(cap)
        if !hollywood.isEmpty {
            sections.append(RecommendationSection(
                title: "Hollywood Blockbusters",
                subtitle: "Top English movies on Indian OTTs",
                movies: Array(hollywood)
            ))
        }

        // Action Picks
        let action = database.byGenre("Action")
            .sorted { $0.rating > $1.rating }
            .prefix(cap)
        if !action.isEmpty {
            sections.append(RecommendationSection(
                title: "Action Packed",
                subtitle: "Adrenaline-fueled picks",
                movies: Array(action)
            ))
        }

        // Drama
        let drama = database.byGenre("Drama")
            .sorted { $0.rating > $1.rating }
            .prefix(cap)
        if !drama.isEmpty {
            sections.append(RecommendationSection(
                title: "Compelling Dramas",
                subtitle: "Stories that stay with you",
                movies: Array(drama)
            ))
        }

        if let limit {
            return Array(sections.prefix(limit))
        }
        return sections
    }

    func moviesForGenre(_ genre: MovieGenre) -> [Movie] {
        database.byGenre(genre.name).sorted { $0.rating > $1.rating }
    }

    func moviesForPlatform(_ platform: OTTPlatform) -> [Movie] {
        database.byPlatform(platform).sorted { $0.rating > $1.rating }
    }

    func similar(to movie: Movie) -> [Movie] {
        database.similar(to: movie)
    }

    func localSearch(query: String) -> [Movie] {
        database.search(query: query)
    }
}
