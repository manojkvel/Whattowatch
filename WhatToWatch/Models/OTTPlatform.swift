import Foundation
import SwiftUI

enum OTTPlatform: String, CaseIterable, Identifiable, Codable {
    case netflix = "Netflix"
    case primeVideo = "Prime Video"
    case hotstar = "Hotstar"
    case lionsgatePlus = "Lionsgate Play"
    case sonyliv = "SonyLIV"
    case zee5 = "ZEE5"
    case aha = "aha"

    var id: String { rawValue }
    var name: String { rawValue }

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

    var iconLetter: String {
        switch self {
        case .netflix: return "N"
        case .primeVideo: return "P"
        case .hotstar: return "H"
        case .lionsgatePlus: return "L"
        case .sonyliv: return "S"
        case .zee5: return "Z"
        case .aha: return "a"
        }
    }

    static func fromName(_ name: String) -> OTTPlatform? {
        let lowered = name.lowercased().trimmingCharacters(in: .whitespaces)
        switch lowered {
        case "netflix": return .netflix
        case "prime video", "amazon prime video", "prime", "amazon prime": return .primeVideo
        case "hotstar", "disney+ hotstar", "disney+hotstar", "jiohotstar", "jio hotstar": return .hotstar
        case "lionsgate play", "lionsgateplay", "lionsgate+", "lionsgate": return .lionsgatePlus
        case "sonyliv", "sony liv", "sony": return .sonyliv
        case "zee5", "z5": return .zee5
        case "aha": return .aha
        default: return nil
        }
    }
}
