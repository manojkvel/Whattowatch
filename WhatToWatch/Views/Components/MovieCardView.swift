import SwiftUI

struct MovieCardView: View {
    let movie: Movie

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            AsyncPosterImage(
                url: movie.posterURL,
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

                    Text(movie.year)
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }

                if !movie.genreIds.isEmpty {
                    Text(MovieGenre.names(for: Array(movie.genreIds.prefix(2))).joined(separator: ", "))
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
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
                url: movie.posterURL,
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
                    Text("(\(movie.year))")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                Text(movie.overview)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(3)

                if !movie.genreIds.isEmpty {
                    HStack(spacing: 4) {
                        ForEach(Array(movie.genreIds.prefix(3)), id: \.self) { genreId in
                            if let genre = MovieGenre.from(id: genreId) {
                                Text(genre.name)
                                    .font(.caption2)
                                    .padding(.horizontal, 6)
                                    .padding(.vertical, 2)
                                    .background(genre.color.opacity(0.2))
                                    .foregroundStyle(genre.color)
                                    .cornerRadius(4)
                            }
                        }
                    }
                }
            }
        }
        .padding(.vertical, 4)
    }
}
