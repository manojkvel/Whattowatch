import Foundation

actor RecommendationEngine {
    static let shared = RecommendationEngine()
    private let tmdbService = TMDbService.shared

    private init() {}

    struct RecommendationSection: Identifiable {
        let id = UUID()
        let title: String
        let subtitle: String
        let movies: [Movie]
    }

    func getHomeRecommendations() async throws -> [RecommendationSection] {
        var sections: [RecommendationSection] = []

        // Fetch multiple categories concurrently
        async let trendingTask = tmdbService.fetchTrending()
        async let popularTask = tmdbService.fetchPopular()
        async let topRatedTask = tmdbService.fetchTopRated()
        async let nowPlayingTask = tmdbService.fetchNowPlaying()
        async let bollywoodTask = tmdbService.fetchIndianMovies(language: "hi")
        async let tamilTask = tmdbService.fetchIndianMovies(language: "ta")
        async let teluguTask = tmdbService.fetchIndianMovies(language: "te")

        let trending = try await trendingTask
        let popular = try await popularTask
        let topRated = try await topRatedTask
        let nowPlaying = try await nowPlayingTask
        let bollywood = try await bollywoodTask
        let tamil = try await tamilTask
        let telugu = try await teluguTask

        sections.append(RecommendationSection(
            title: "Trending This Week",
            subtitle: "What everyone's watching right now",
            movies: trending.results
        ))

        sections.append(RecommendationSection(
            title: "Popular Movies",
            subtitle: "Most popular picks for you",
            movies: popular.results
        ))

        if !nowPlaying.results.isEmpty {
            sections.append(RecommendationSection(
                title: "Now Playing",
                subtitle: "Currently in theaters",
                movies: nowPlaying.results
            ))
        }

        sections.append(RecommendationSection(
            title: "Top Rated",
            subtitle: "Critically acclaimed films",
            movies: topRated.results
        ))

        if !bollywood.results.isEmpty {
            sections.append(RecommendationSection(
                title: "Bollywood Hits",
                subtitle: "Popular Hindi movies",
                movies: bollywood.results
            ))
        }

        if !tamil.results.isEmpty {
            sections.append(RecommendationSection(
                title: "Tamil Cinema",
                subtitle: "Top Tamil movies",
                movies: tamil.results
            ))
        }

        if !telugu.results.isEmpty {
            sections.append(RecommendationSection(
                title: "Telugu Cinema",
                subtitle: "Top Telugu movies",
                movies: telugu.results
            ))
        }

        return sections
    }

    func getRecommendationsForGenre(_ genre: MovieGenre) async throws -> [Movie] {
        let response = try await tmdbService.fetchByGenre(genreId: genre.rawValue)
        return response.results
    }

    func getRecommendationsForPlatform(_ platform: OTTPlatform) async throws -> [Movie] {
        let response = try await tmdbService.fetchByProvider(providerId: platform.tmdbProviderId)
        return response.results
    }

    func getSimilarMovies(to movieId: Int) async throws -> [Movie] {
        let response = try await tmdbService.fetchSimilar(movieId: movieId)
        return response.results
    }
}
