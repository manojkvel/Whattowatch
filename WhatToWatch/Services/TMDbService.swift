import Foundation

actor TMDbService {
    static let shared = TMDbService()

    // TMDb API v3 - Users should replace with their own API key from https://www.themoviedb.org/settings/api
    // Get a free API key at: https://www.themoviedb.org/signup
    private let apiKey = "YOUR_TMDB_API_KEY"
    private let baseURL = "https://api.themoviedb.org/3"
    private let session = URLSession.shared

    private init() {}

    // MARK: - Trending Movies

    func fetchTrending(page: Int = 1) async throws -> MovieResponse {
        let url = "\(baseURL)/trending/movie/week?api_key=\(apiKey)&page=\(page)&region=IN&language=en-US"
        return try await request(url: url)
    }

    // MARK: - Popular Movies

    func fetchPopular(page: Int = 1) async throws -> MovieResponse {
        let url = "\(baseURL)/movie/popular?api_key=\(apiKey)&page=\(page)&region=IN&language=en-US"
        return try await request(url: url)
    }

    // MARK: - Top Rated Movies

    func fetchTopRated(page: Int = 1) async throws -> MovieResponse {
        let url = "\(baseURL)/movie/top_rated?api_key=\(apiKey)&page=\(page)&region=IN&language=en-US"
        return try await request(url: url)
    }

    // MARK: - Now Playing

    func fetchNowPlaying(page: Int = 1) async throws -> MovieResponse {
        let url = "\(baseURL)/movie/now_playing?api_key=\(apiKey)&page=\(page)&region=IN&language=en-US"
        return try await request(url: url)
    }

    // MARK: - Upcoming

    func fetchUpcoming(page: Int = 1) async throws -> MovieResponse {
        let url = "\(baseURL)/movie/upcoming?api_key=\(apiKey)&page=\(page)&region=IN&language=en-US"
        return try await request(url: url)
    }

    // MARK: - Discover by Genre

    func fetchByGenre(genreId: Int, page: Int = 1) async throws -> MovieResponse {
        let url = "\(baseURL)/discover/movie?api_key=\(apiKey)&with_genres=\(genreId)&page=\(page)&region=IN&language=en-US&sort_by=popularity.desc"
        return try await request(url: url)
    }

    // MARK: - Search Movies

    func searchMovies(query: String, page: Int = 1) async throws -> MovieResponse {
        let encoded = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query
        let url = "\(baseURL)/search/movie?api_key=\(apiKey)&query=\(encoded)&page=\(page)&language=en-US&region=IN"
        return try await request(url: url)
    }

    // MARK: - Movie Details

    func fetchMovieDetail(movieId: Int) async throws -> MovieDetail {
        let url = "\(baseURL)/movie/\(movieId)?api_key=\(apiKey)&language=en-US"
        return try await request(url: url)
    }

    // MARK: - Watch Providers (for India)

    func fetchWatchProviders(movieId: Int) async throws -> WatchProviderResponse {
        let url = "\(baseURL)/movie/\(movieId)/watch/providers?api_key=\(apiKey)"
        return try await request(url: url)
    }

    // MARK: - Similar Movies

    func fetchSimilar(movieId: Int, page: Int = 1) async throws -> MovieResponse {
        let url = "\(baseURL)/movie/\(movieId)/similar?api_key=\(apiKey)&page=\(page)&language=en-US"
        return try await request(url: url)
    }

    // MARK: - Discover by OTT Provider

    func fetchByProvider(providerId: Int, page: Int = 1) async throws -> MovieResponse {
        let url = "\(baseURL)/discover/movie?api_key=\(apiKey)&watch_region=IN&with_watch_providers=\(providerId)&page=\(page)&language=en-US&sort_by=popularity.desc"
        return try await request(url: url)
    }

    // MARK: - Indian Language Movies

    func fetchIndianMovies(language: String = "hi", page: Int = 1) async throws -> MovieResponse {
        let url = "\(baseURL)/discover/movie?api_key=\(apiKey)&with_original_language=\(language)&page=\(page)&sort_by=popularity.desc&language=en-US"
        return try await request(url: url)
    }

    // MARK: - Private Request Helper

    private func request<T: Codable>(url: String) async throws -> T {
        guard let requestURL = URL(string: url) else {
            throw TMDbError.invalidURL
        }

        let (data, response) = try await session.data(from: requestURL)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw TMDbError.invalidResponse
        }

        guard httpResponse.statusCode == 200 else {
            throw TMDbError.httpError(statusCode: httpResponse.statusCode)
        }

        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    }
}

enum TMDbError: LocalizedError {
    case invalidURL
    case invalidResponse
    case httpError(statusCode: Int)
    case decodingError

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid response from server"
        case .httpError(let code):
            return "Server error (HTTP \(code))"
        case .decodingError:
            return "Failed to process movie data"
        }
    }
}
