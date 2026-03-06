import Foundation
import SwiftUI

@MainActor
final class MovieViewModel: ObservableObject {
    @Published var sections: [RecommendationEngine.RecommendationSection] = []
    @Published var searchResults: [Movie] = []
    @Published var imdbSearchResults: [IMDbSuggestion] = []
    @Published var selectedMovie: Movie?
    @Published var similarMovies: [Movie] = []
    @Published var genreMovies: [Movie] = []
    @Published var platformMovies: [Movie] = []
    @Published var isLoading = false
    @Published var isSearching = false
    @Published var errorMessage: String?
    @Published var searchQuery = ""

    private let engine = RecommendationEngine.shared
    private let imdbService = IMDbService.shared
    private let database = MovieDatabase.shared

    private var allSections: [RecommendationEngine.RecommendationSection] = []
    private let initialSectionCount = 3

    var hasMoreSections: Bool {
        sections.count < allSections.count
    }

    func loadHomeData() {
        isLoading = true
        allSections = engine.getHomeRecommendations()
        // Show first few sections immediately for fast startup
        sections = Array(allSections.prefix(initialSectionCount))
        isLoading = false
    }

    func loadMoreSections() {
        guard hasMoreSections else { return }
        let next = min(sections.count + 2, allSections.count)
        sections = Array(allSections.prefix(next))
    }

    func searchMovies() async {
        let query = searchQuery.trimmingCharacters(in: .whitespaces)
        guard !query.isEmpty else {
            searchResults = []
            imdbSearchResults = []
            return
        }

        isSearching = true

        // Search local database first
        searchResults = engine.localSearch(query: query)

        // Also search IMDb suggestion API for broader results
        do {
            imdbSearchResults = try await imdbService.searchMovies(query: query)
        } catch {
            imdbSearchResults = []
        }

        isSearching = false
    }

    func selectMovie(_ movie: Movie) {
        selectedMovie = movie
        similarMovies = engine.similar(to: movie)
    }

    func selectMovieById(_ imdbId: String) {
        if let movie = database.movie(byId: imdbId) {
            selectMovie(movie)
        }
    }

    func loadGenreMovies(genre: MovieGenre) {
        isLoading = true
        genreMovies = engine.moviesForGenre(genre)
        isLoading = false
    }

    func loadPlatformMovies(platform: OTTPlatform) {
        isLoading = true
        platformMovies = engine.moviesForPlatform(platform)
        isLoading = false
    }
}
