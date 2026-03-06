import Foundation

actor IMDbService {
    static let shared = IMDbService()
    private let session = URLSession.shared

    private init() {}

    // MARK: - IMDb Suggestion API (public, no key needed)

    func searchMovies(query: String) async throws -> [IMDbSuggestion] {
        let trimmed = query.trimmingCharacters(in: .whitespaces).lowercased()
        guard !trimmed.isEmpty else { return [] }

        let firstChar = String(trimmed.prefix(1))
        let encoded = trimmed.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? trimmed
        let urlString = "https://v3.sg.media-imdb.com/suggestion/\(firstChar)/\(encoded).json"

        guard let url = URL(string: urlString) else {
            throw IMDbError.invalidURL
        }

        let (data, response) = try await session.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw IMDbError.invalidResponse
        }

        let decoded = try JSONDecoder().decode(IMDbSuggestionResponse.self, from: data)
        // Filter to only movies
        return decoded.d?.filter { $0.isMovie } ?? []
    }
}

enum IMDbError: LocalizedError {
    case invalidURL
    case invalidResponse

    var errorDescription: String? {
        switch self {
        case .invalidURL: return "Invalid search URL"
        case .invalidResponse: return "Could not reach IMDb"
        }
    }
}
