import Foundation

actor OTTAvailabilityService {
    static let shared = OTTAvailabilityService()
    private let tmdbService = TMDbService.shared
    private var cache: [Int: [OTTPlatform]] = [:]

    private init() {}

    func getAvailablePlatforms(for movieId: Int) async -> [OTTPlatform] {
        if let cached = cache[movieId] {
            return cached
        }

        do {
            let response = try await tmdbService.fetchWatchProviders(movieId: movieId)
            // Look for India ("IN") region
            guard let indiaProviders = response.results["IN"] else {
                cache[movieId] = []
                return []
            }

            var platforms: Set<OTTPlatform> = []

            // Check flatrate (subscription) providers
            if let flatrate = indiaProviders.flatrate {
                for provider in flatrate {
                    if let platform = OTTPlatform.from(providerId: provider.providerId) {
                        platforms.insert(platform)
                    }
                }
            }

            // Check rent providers
            if let rent = indiaProviders.rent {
                for provider in rent {
                    if let platform = OTTPlatform.from(providerId: provider.providerId) {
                        platforms.insert(platform)
                    }
                }
            }

            // Check buy providers
            if let buy = indiaProviders.buy {
                for provider in buy {
                    if let platform = OTTPlatform.from(providerId: provider.providerId) {
                        platforms.insert(platform)
                    }
                }
            }

            let result = Array(platforms).sorted { $0.name < $1.name }
            cache[movieId] = result
            return result
        } catch {
            return []
        }
    }

    func clearCache() {
        cache.removeAll()
    }
}
