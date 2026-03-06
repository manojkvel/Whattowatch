import Foundation
import SwiftUI

enum MovieGenre: Int, CaseIterable, Identifiable {
    case action = 28
    case adventure = 12
    case animation = 16
    case comedy = 35
    case crime = 80
    case documentary = 99
    case drama = 18
    case family = 10751
    case fantasy = 14
    case history = 36
    case horror = 27
    case music = 10402
    case mystery = 9648
    case romance = 10749
    case scienceFiction = 878
    case thriller = 53
    case war = 10752
    case western = 37

    var id: Int { rawValue }

    var name: String {
        switch self {
        case .action: return "Action"
        case .adventure: return "Adventure"
        case .animation: return "Animation"
        case .comedy: return "Comedy"
        case .crime: return "Crime"
        case .documentary: return "Documentary"
        case .drama: return "Drama"
        case .family: return "Family"
        case .fantasy: return "Fantasy"
        case .history: return "History"
        case .horror: return "Horror"
        case .music: return "Music"
        case .mystery: return "Mystery"
        case .romance: return "Romance"
        case .scienceFiction: return "Sci-Fi"
        case .thriller: return "Thriller"
        case .war: return "War"
        case .western: return "Western"
        }
    }

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
        case .scienceFiction: return "atom"
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
        case .scienceFiction: return .cyan
        case .thriller: return Color(red: 0.5, green: 0, blue: 0)
        case .war: return Color(red: 0.3, green: 0.3, blue: 0.1)
        case .western: return Color(red: 0.7, green: 0.5, blue: 0.2)
        }
    }

    static func from(id: Int) -> MovieGenre? {
        return MovieGenre(rawValue: id)
    }

    static func names(for ids: [Int]) -> [String] {
        return ids.compactMap { MovieGenre(rawValue: $0)?.name }
    }
}
