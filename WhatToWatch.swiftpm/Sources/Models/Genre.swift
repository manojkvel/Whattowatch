import Foundation
import SwiftUI

enum MovieGenre: String, CaseIterable, Identifiable {
    case action = "Action"
    case adventure = "Adventure"
    case animation = "Animation"
    case comedy = "Comedy"
    case crime = "Crime"
    case documentary = "Documentary"
    case drama = "Drama"
    case family = "Family"
    case fantasy = "Fantasy"
    case history = "History"
    case horror = "Horror"
    case music = "Music"
    case mystery = "Mystery"
    case romance = "Romance"
    case sciFi = "Sci-Fi"
    case thriller = "Thriller"
    case war = "War"
    case western = "Western"

    var id: String { rawValue }
    var name: String { rawValue }

    var icon: String {
        switch self {
        case .action: return "bolt.fill"
        case .adventure: return "map.fill"
        case .animation: return "sparkles"
        case .comedy: return "face.smiling.fill"
        case .crime: return "exclamationmark.shield.fill"
        case .documentary: return "video.fill"
        case .drama: return "theatermasks.fill"
        case .family: return "figure.2.and.child.holdinghands"
        case .fantasy: return "wand.and.stars"
        case .history: return "clock.fill"
        case .horror: return "eye.fill"
        case .music: return "music.note"
        case .mystery: return "magnifyingglass"
        case .romance: return "heart.fill"
        case .sciFi: return "atom"
        case .thriller: return "bolt.shield.fill"
        case .war: return "shield.fill"
        case .western: return "sun.dust.fill"
        }
    }

    var color: Color {
        switch self {
        case .action: return .red
        case .adventure: return .orange
        case .animation: return .mint
        case .comedy: return .yellow
        case .crime: return .gray
        case .documentary: return .blue
        case .drama: return .purple
        case .family: return .green
        case .fantasy: return .indigo
        case .history: return .brown
        case .horror: return Color(red: 0.2, green: 0.2, blue: 0.2)
        case .music: return .pink
        case .mystery: return .teal
        case .romance: return .pink
        case .sciFi: return .cyan
        case .thriller: return Color(red: 0.5, green: 0, blue: 0)
        case .war: return Color(red: 0.3, green: 0.3, blue: 0.1)
        case .western: return Color(red: 0.7, green: 0.5, blue: 0.2)
        }
    }

    static func from(name: String) -> MovieGenre? {
        return MovieGenre(rawValue: name)
    }
}
