import SwiftUI

struct MovieDetailView: View {
    @ObservedObject var viewModel: MovieViewModel
    let movieId: Int

    var body: some View {
        Group {
            if viewModel.isLoadingDetail {
                ProgressView("Loading movie details...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let movie = viewModel.selectedMovieDetail {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        // Backdrop
                        backdropSection(movie)

                        VStack(alignment: .leading, spacing: 20) {
                            // Title and meta
                            titleSection(movie)

                            // Rating
                            ratingSection(movie)

                            // Genres
                            genreSection(movie)

                            // Tagline
                            if let tagline = movie.tagline, !tagline.isEmpty {
                                Text("\"\(tagline)\"")
                                    .font(.subheadline)
                                    .italic()
                                    .foregroundStyle(.secondary)
                            }

                            // Summary
                            summarySection(movie)

                            // Where to Watch
                            OTTAvailabilityView(platforms: viewModel.selectedMoviePlatforms)

                            // Similar Movies
                            if !viewModel.similarMovies.isEmpty {
                                similarSection
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            } else {
                VStack(spacing: 12) {
                    Image(systemName: "film")
                        .font(.largeTitle)
                        .foregroundStyle(.secondary)
                    Text("Movie not found")
                        .foregroundStyle(.secondary)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.loadMovieDetail(movieId: movieId)
        }
    }

    private func backdropSection(_ movie: MovieDetail) -> some View {
        ZStack(alignment: .bottomLeading) {
            AsyncPosterImage(
                url: movie.backdropURL ?? movie.posterURL,
                width: UIScreen.main.bounds.width,
                height: 250
            )

            LinearGradient(
                colors: [.clear, .black.opacity(0.7)],
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(height: 120)
            .frame(maxHeight: .infinity, alignment: .bottom)
        }
        .frame(height: 250)
    }

    private func titleSection(_ movie: MovieDetail) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(movie.title)
                .font(.title)
                .fontWeight(.bold)

            HStack(spacing: 12) {
                if let date = movie.releaseDate, date.count >= 4 {
                    Label(String(date.prefix(4)), systemImage: "calendar")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                Label(movie.formattedRuntime, systemImage: "clock")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                if let status = movie.status {
                    Label(status, systemImage: "info.circle")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }

    private func ratingSection(_ movie: MovieDetail) -> some View {
        HStack(spacing: 16) {
            VStack(spacing: 4) {
                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .foregroundStyle(.yellow)
                    Text(String(format: "%.1f", movie.voteAverage))
                        .font(.title2)
                        .fontWeight(.bold)
                    Text("/ 10")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                Text("TMDb Rating")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding()
            .background(Color.yellow.opacity(0.1))
            .cornerRadius(12)
        }
    }

    private func genreSection(_ movie: MovieDetail) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Label("Genres", systemImage: "tag")
                .font(.headline)

            FlowLayout(spacing: 8) {
                ForEach(movie.genres) { genre in
                    let movieGenre = MovieGenre.from(id: genre.id)
                    HStack(spacing: 4) {
                        if let mg = movieGenre {
                            Image(systemName: mg.icon)
                                .font(.caption2)
                        }
                        Text(genre.name)
                            .font(.caption)
                            .fontWeight(.medium)
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background((movieGenre?.color ?? .gray).opacity(0.15))
                    .foregroundStyle(movieGenre?.color ?? .gray)
                    .cornerRadius(16)
                }
            }
        }
    }

    private func summarySection(_ movie: MovieDetail) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Label("Summary", systemImage: "text.alignleft")
                .font(.headline)

            Text(movie.overview)
                .font(.body)
                .lineSpacing(4)
                .foregroundStyle(.primary.opacity(0.9))
        }
    }

    private var similarSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label("You Might Also Like", systemImage: "sparkles")
                .font(.headline)

            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 16) {
                    ForEach(viewModel.similarMovies) { movie in
                        NavigationLink {
                            MovieDetailView(viewModel: viewModel, movieId: movie.id)
                        } label: {
                            MovieCardView(movie: movie)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
    }
}

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
