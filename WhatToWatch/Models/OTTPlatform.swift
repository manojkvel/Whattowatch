import Foundation
import SwiftUI

enum OTTPlatform: Int, CaseIterable, Identifiable {
    case netflix = 8
    case primeVideo = 119
    case hotstar = 122
    case lionsgatePlus = 337
    case sonyliv = 237
    case zee5 = 232
    case aha = 532

    var id: Int { rawValue }

    // TMDb provider IDs for India region
    var tmdbProviderId: Int { rawValue }

    var name: String {
        switch self {
        case .netflix: return "Netflix"
        case .primeVideo: return "Prime Video"
        case .hotstar: return "Hotstar"
        case .lionsgatePlus: return "Lionsgate Play"
        case .sonyliv: return "SonyLIV"
        case .zee5: return "ZEE5"
        case .aha: return "aha"
        }
    }

    var brandColor: Color {
        switch self {
        case .netflix: return Color(red: 0.89, green: 0.07, blue: 0.07)
        case .primeVideo: return Color(red: 0.0, green: 0.66, blue: 0.88)
        case .hotstar: return Color(red: 0.04, green: 0.12, blue: 0.42)
        case .lionsgatePlus: return Color(red: 0.99, green: 0.68, blue: 0.0)
        case .sonyliv: return Color(red: 0.0, green: 0.0, blue: 0.0)
        case .zee5: return Color(red: 0.51, green: 0.18, blue: 0.79)
        case .aha: return Color(red: 1.0, green: 0.45, blue: 0.0)
        }
    }

    var shortName: String {
        switch self {
        case .netflix: return "Netflix"
        case .primeVideo: return "Prime"
        case .hotstar: return "Hotstar"
        case .lionsgatePlus: return "Lionsgate"
        case .sonyliv: return "SonyLIV"
        case .zee5: return "ZEE5"
        case .aha: return "aha"
        }
    }

    static func from(providerId: Int) -> OTTPlatform? {
        return OTTPlatform(rawValue: providerId)
    }

    static func matchingPlatforms(from providers: [WatchProvider]) -> [OTTPlatform] {
        return providers.compactMap { OTTPlatform.from(providerId: $0.providerId) }
    }
}
