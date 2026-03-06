import SwiftUI

struct SearchView: View {
    @StateObject private var viewModel = MovieViewModel()

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.searchQuery.isEmpty {
                    emptySearchView
                } else if viewModel.isSearching {
                    ProgressView("Searching IMDb...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if viewModel.searchResults.isEmpty && viewModel.imdbSearchResults.isEmpty {
                    noResultsView
                } else {
                    resultsList
                }
            }
            .navigationTitle("Search")
            .searchable(text: $viewModel.searchQuery, prompt: "Search movies on IMDb...")
            .onChange(of: viewModel.searchQuery) {
                Task {
                    try? await Task.sleep(nanoseconds: 300_000_000)
                    await viewModel.searchMovies()
                }
            }
        }
    }

    private var emptySearchView: some View {
        VStack(spacing: 16) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 48))
                .foregroundStyle(.secondary)
            Text("Search for movies")
                .font(.headline)
                .foregroundStyle(.secondary)
            Text("Find movies by title and see where to watch them on Indian OTTs")
                .font(.subheadline)
                .foregroundStyle(.tertiary)
                .multilineTextAlignment(.center)
        }
        .padding()
    }

    private var noResultsView: some View {
        VStack(spacing: 12) {
            Image(systemName: "film")
                .font(.system(size: 40))
                .foregroundStyle(.secondary)
            Text("No movies found")
                .font(.headline)
                .foregroundStyle(.secondary)
            Text("Try a different search term")
                .font(.subheadline)
                .foregroundStyle(.tertiary)
        }
    }

    private var resultsList: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                // Local matches (with full details + OTT info)
                if !viewModel.searchResults.isEmpty {
                    Section {
                        ForEach(viewModel.searchResults) { movie in
                            NavigationLink {
                                MovieDetailView(viewModel: viewModel, movie: movie)
                            } label: {
                                MovieListRow(movie: movie)
                                    .padding(.horizontal)
                            }
                            .buttonStyle(.plain)
                            Divider().padding(.horizontal)
                        }
                    } header: {
                        HStack {
                            Text("Movies with OTT Info")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundStyle(.secondary)
                            Spacer()
                        }
                        .padding(.horizontal)
                        .padding(.top, 8)
                        .padding(.bottom, 4)
                    }
                }

                // IMDb suggestion results
                if !viewModel.imdbSearchResults.isEmpty {
                    Section {
                        ForEach(viewModel.imdbSearchResults) { suggestion in
                            IMDbSuggestionRow(suggestion: suggestion)
                            Divider().padding(.horizontal)
                        }
                    } header: {
                        HStack {
                            Text("IMDb Results")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundStyle(.secondary)
                            Spacer()
                        }
                        .padding(.horizontal)
                        .padding(.top, 12)
                        .padding(.bottom, 4)
                    }
                }
            }
        }
    }
}

struct IMDbSuggestionRow: View {
    let suggestion: IMDbSuggestion

    var body: some View {
        HStack(spacing: 12) {
            AsyncPosterImage(
                url: suggestion.posterURL,
                width: 60,
                height: 90
            )

            VStack(alignment: .leading, spacing: 4) {
                Text(suggestion.l)
                    .font(.headline)
                    .lineLimit(2)

                if let year = suggestion.y {
                    Text(String(year))
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                if let cast = suggestion.s {
                    Text(cast)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }

                if let type = suggestion.q {
                    Text(type.capitalized)
                        .font(.caption2)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color.blue.opacity(0.1))
                        .foregroundStyle(.blue)
                        .cornerRadius(4)
                }
            }

            Spacer()

            // Link to IMDb
            if let url = URL(string: "https://www.imdb.com/title/\(suggestion.id)/") {
                Link(destination: url) {
                    Image(systemName: "arrow.up.right.square")
                        .foregroundStyle(.blue)
                }
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 6)
    }
}
