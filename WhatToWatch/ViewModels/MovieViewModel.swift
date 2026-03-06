import Foundation
import SwiftUI

@MainActor
final class MovieViewModel: ObservableObject {
    @Published var sections: [RecommendationEngine.RecommendationSection] = []
    @Published var searchResults: [Movie] = []
    @Published var selectedMovieDetail: MovieDetail?
    @Published var selectedMoviePlatforms: [OTTPlatform] = []
    @Published var similarMovies: [Movie] = []
    @Published var genreMovies: [Movie] = []
    @Published var platformMovies: [Movie] = []
    @Published var isLoading = false
    @Published var isSearching = false
    @Published var isLoadingDetail = false
    @Published var errorMessage: String?
    @Published var searchQuery = ""
    @Published var selectedGenre: MovieGenre?
    @Published var selectedPlatform: OTTPlatform?

    private let recommendationEngine = RecommendationEngine.shared
    private let tmdbService = TMDbService.shared
    private let ottService = OTTAvailabilityService.shared

    func loadHomeData() async {
        isLoading = true
        errorMessage = nil

        do {
            sections = try await recommendationEngine.getHomeRecommendations()
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    func searchMovies() async {
        guard !searchQuery.trimmingCharacters(in: .whitespaces).isEmpty else {
            searchResults = []
            return
        }

        isSearching = true
        do {
            let response = try await tmdbService.searchMovies(query: searchQuery)
            searchResults = response.results
        } catch {
            errorMessage = error.localizedDescription
        }
        isSearching = false
    }

    func loadMovieDetail(movieId: Int) async {
        isLoadingDetail = true
        selectedMovieDetail = nil
        selectedMoviePlatforms = []
        similarMovies = []

        // Fetch detail, platforms, and similar movies concurrently
        async let detailTask = tmdbService.fetchMovieDetail(movieId: movieId)
        async let platformsTask = ottService.getAvailablePlatforms(for: movieId)
        async let similarTask = recommendationEngine.getSimilarMovies(to: movieId)

        do {
            selectedMovieDetail = try await detailTask
            selectedMoviePlatforms = await platformsTask
            similarMovies = (try? await similarTask) ?? []
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoadingDetail = false
    }

    func loadGenreMovies(genre: MovieGenre) async {
        selectedGenre = genre
        isLoading = true
        do {
            genreMovies = try await recommendationEngine.getRecommendationsForGenre(genre)
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }

    func loadPlatformMovies(platform: OTTPlatform) async {
        selectedPlatform = platform
        isLoading = true
        do {
            platformMovies = try await recommendationEngine.getRecommendationsForPlatform(platform)
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }

    func genreNames(for ids: [Int]) -> String {
        MovieGenre.names(for: ids).joined(separator: ", ")
    }
}
