import SwiftUI

struct MovieDetailView: View {
    @ObservedObject var viewModel: MovieViewModel
    let movie: Movie

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Poster header
                posterSection

                VStack(alignment: .leading, spacing: 20) {
                    // Title and meta
                    titleSection

                    // IMDb Rating
                    ratingSection

                    // Genres
                    genreSection

                    // Summary
                    if !movie.summary.isEmpty {
                        summarySection
                    }

                    // Cast & Director
                    creditsSection

                    // Where to Watch
                    OTTAvailabilityView(platforms: movie.ottPlatforms)

                    // IMDb Link
                    if let url = movie.imdbURL {
                        Link(destination: url) {
                            HStack {
                                Image(systemName: "link")
                                Text("View on IMDb")
                                Spacer()
                                Image(systemName: "arrow.up.right.square")
                            }
                            .font(.subheadline)
                            .padding()
                            .background(Color.yellow.opacity(0.15))
                            .foregroundStyle(.primary)
                            .cornerRadius(12)
                        }
                    }

                    // Similar Movies
                    if !viewModel.similarMovies.isEmpty {
                        similarSection
                    }
                }
                .padding(.horizontal)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.selectMovie(movie)
        }
    }

    private var posterSection: some View {
        ZStack(alignment: .bottomLeading) {
            AsyncPosterImage(
                url: movie.posterImageURL,
                width: UIScreen.main.bounds.width,
                height: 300
            )

            LinearGradient(
                colors: [.clear, .black.opacity(0.8)],
                startPoint: .center,
                endPoint: .bottom
            )
            .frame(height: 150)
            .frame(maxHeight: .infinity, alignment: .bottom)

            VStack(alignment: .leading, spacing: 4) {
                Text(movie.title)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                HStack(spacing: 8) {
                    Text(String(movie.year))
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.8))
                    if let runtime = movie.runtime {
                        Text(runtime)
                            .font(.subheadline)
                            .foregroundStyle(.white.opacity(0.8))
                    }
                    if let language = movie.language {
                        Text(language)
                            .font(.caption)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(.white.opacity(0.2))
                            .foregroundStyle(.white)
                            .cornerRadius(4)
                    }
                }
            }
            .padding()
        }
        .frame(height: 300)
    }

    private var titleSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(movie.title)
                .font(.title)
                .fontWeight(.bold)

            HStack(spacing: 12) {
                Label(String(movie.year), systemImage: "calendar")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                if let runtime = movie.runtime {
                    Label(runtime, systemImage: "clock")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                if let language = movie.language {
                    Label(language, systemImage: "globe")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }

    private var ratingSection: some View {
        HStack(spacing: 16) {
            VStack(spacing: 4) {
                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .foregroundStyle(.yellow)
                    Text(movie.formattedRating)
                        .font(.title2)
                        .fontWeight(.bold)
                    Text("/ 10")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                Text("IMDb Rating")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding()
            .background(Color.yellow.opacity(0.1))
            .cornerRadius(12)

            VStack(spacing: 4) {
                Text(movie.ratingStars)
                    .font(.title3)
                Text("Stars")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding()
            .background(Color.orange.opacity(0.1))
            .cornerRadius(12)
        }
    }

    private var genreSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label("Genres", systemImage: "tag")
                .font(.headline)

            FlowLayout(spacing: 8) {
                ForEach(movie.genres, id: \.self) { genreName in
                    let genre = MovieGenre.from(name: genreName)
                    HStack(spacing: 4) {
                        if let g = genre {
                            Image(systemName: g.icon)
                                .font(.caption2)
                        }
                        Text(genreName)
                            .font(.caption)
                            .fontWeight(.medium)
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background((genre?.color ?? .gray).opacity(0.15))
                    .foregroundStyle(genre?.color ?? .gray)
                    .cornerRadius(16)
                }
            }
        }
    }

    private var summarySection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label("Summary", systemImage: "text.alignleft")
                .font(.headline)

            Text(movie.summary)
                .font(.body)
                .lineSpacing(4)
                .foregroundStyle(.primary.opacity(0.9))
        }
    }

    private var creditsSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label("Credits", systemImage: "person.2")
                .font(.headline)

            if let director = movie.director {
                HStack(alignment: .top) {
                    Text("Director")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .frame(width: 70, alignment: .leading)
                    Text(director)
                        .font(.subheadline)
                }
            }

            if let cast = movie.cast {
                HStack(alignment: .top) {
                    Text("Cast")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .frame(width: 70, alignment: .leading)
                    Text(cast)
                        .font(.subheadline)
                }
            }
        }
        .padding()
        .background(Color.gray.opacity(0.08))
        .cornerRadius(12)
    }

    private var similarSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label("You Might Also Like", systemImage: "sparkles")
                .font(.headline)

            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 16) {
                    ForEach(viewModel.similarMovies) { similar in
                        NavigationLink {
                            MovieDetailView(viewModel: viewModel, movie: similar)
                        } label: {
                            MovieCardView(movie: similar)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
    }
}

// MARK: - Flow Layout

struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = arrange(proposal: proposal, subviews: subviews)
        return result.size
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = arrange(proposal: proposal, subviews: subviews)
        for (index, position) in result.positions.enumerated() {
            subviews[index].place(at: CGPoint(x: bounds.minX + position.x, y: bounds.minY + position.y), proposal: .unspecified)
        }
    }

    private func arrange(proposal: ProposedViewSize, subviews: Subviews) -> (positions: [CGPoint], size: CGSize) {
        let maxWidth = proposal.width ?? .infinity
        var positions: [CGPoint] = []
        var x: CGFloat = 0
        var y: CGFloat = 0
        var rowHeight: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if x + size.width > maxWidth, x > 0 {
                x = 0
                y += rowHeight + spacing
                rowHeight = 0
            }
            positions.append(CGPoint(x: x, y: y))
            rowHeight = max(rowHeight, size.height)
            x += size.width + spacing
        }

        return (positions, CGSize(width: maxWidth, height: y + rowHeight))
    }
}
