import SwiftUI

struct MovieCardView: View {
    let movie: Movie

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            AsyncPosterImage(
                url: movie.posterImageURL,
                width: 150,
                height: 225
            )
            .shadow(color: .black.opacity(0.3), radius: 4, x: 0, y: 2)

            VStack(alignment: .leading, spacing: 4) {
                Text(movie.title)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .lineLimit(2)
                    .foregroundStyle(.primary)

                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .font(.caption2)
                        .foregroundStyle(.yellow)
                    Text(movie.formattedRating)
                        .font(.caption2)
                        .foregroundStyle(.secondary)

                    Spacer()

                    Text(String(movie.year))
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }

                if !movie.genres.isEmpty {
                    Text(movie.genres.prefix(2).joined(separator: ", "))
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }

                // OTT badges
                if !movie.ottPlatforms.isEmpty {
                    HStack(spacing: 3) {
                        ForEach(movie.ottPlatforms.prefix(2)) { platform in
                            Text(platform.shortName)
                                .font(.system(size: 8))
                                .fontWeight(.medium)
                                .padding(.horizontal, 4)
                                .padding(.vertical, 2)
                                .background(platform.brandColor.opacity(0.15))
                                .foregroundStyle(platform.brandColor)
                                .cornerRadius(3)
                        }
                        if movie.ottPlatforms.count > 2 {
                            Text("+\(movie.ottPlatforms.count - 2)")
                                .font(.system(size: 8))
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
            .frame(width: 150)
        }
    }
}

struct MovieListRow: View {
    let movie: Movie

    var body: some View {
        HStack(spacing: 12) {
            AsyncPosterImage(
                url: movie.posterImageURL,
                width: 80,
                height: 120
            )

            VStack(alignment: .leading, spacing: 6) {
                Text(movie.title)
                    .font(.headline)
                    .lineLimit(2)

                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .font(.caption)
                        .foregroundStyle(.yellow)
                    Text(movie.formattedRating)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Text("(\(String(movie.year)))")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    if let lang = movie.language {
                        Text(lang)
                            .font(.caption2)
                            .padding(.horizontal, 4)
                            .padding(.vertical, 1)
                            .background(Color.blue.opacity(0.1))
                            .foregroundStyle(.blue)
                            .cornerRadius(3)
                    }
                }

                if !movie.summary.isEmpty {
                    Text(movie.summary)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }

                // Genre tags
                if !movie.genres.isEmpty {
                    HStack(spacing: 4) {
                        ForEach(Array(movie.genres.prefix(3)), id: \.self) { genreName in
                            let genre = MovieGenre.from(name: genreName)
                            Text(genreName)
                                .font(.caption2)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background((genre?.color ?? .gray).opacity(0.2))
                                .foregroundStyle(genre?.color ?? .gray)
                                .cornerRadius(4)
                        }
                    }
                }

                // OTT availability
                if !movie.ottPlatforms.isEmpty {
                    HStack(spacing: 4) {
                        ForEach(movie.ottPlatforms) { platform in
                            OTTBadgeView(platform: platform)
                        }
                    }
                }
            }
        }
        .padding(.vertical, 4)
    }
}
