import SwiftUI

struct SearchView: View {
    @StateObject private var viewModel = MovieViewModel()

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.searchQuery.isEmpty {
                    emptySearchView
                } else if viewModel.isSearching {
                    ProgressView("Searching...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if viewModel.searchResults.isEmpty {
                    noResultsView
                } else {
                    resultsList
                }
            }
            .navigationTitle("Search")
            .searchable(text: $viewModel.searchQuery, prompt: "Search movies...")
            .onChange(of: viewModel.searchQuery) {
                Task {
                    // Debounce
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
            Text("Find movies by title and see where to watch them")
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
                ForEach(viewModel.searchResults) { movie in
                    NavigationLink {
                        MovieDetailView(viewModel: viewModel, movieId: movie.id)
                    } label: {
                        MovieListRow(movie: movie)
                            .padding(.horizontal)
                    }
                    .buttonStyle(.plain)
                    Divider().padding(.horizontal)
                }
            }
        }
    }
}
