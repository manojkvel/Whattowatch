import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = MovieViewModel()
    @State private var showingGenreFilter = false
    @State private var showingPlatformFilter = false

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading && viewModel.sections.isEmpty {
                    ProgressView("Finding movies for you...")
                } else {
                    contentView
                }
            }
            .navigationTitle("What to Watch")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Button {
                            showingGenreFilter = true
                        } label: {
                            Label("Browse by Genre", systemImage: "theatermasks")
                        }
                        Button {
                            showingPlatformFilter = true
                        } label: {
                            Label("Browse by Platform", systemImage: "play.tv")
                        }
                    } label: {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                    }
                }
            }
            .sheet(isPresented: $showingGenreFilter) {
                GenreFilterView(viewModel: viewModel)
            }
            .sheet(isPresented: $showingPlatformFilter) {
                PlatformBrowseView(viewModel: viewModel)
            }
            .onAppear {
                if viewModel.sections.isEmpty {
                    viewModel.loadHomeData()
                }
            }
        }
    }

    private var contentView: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 24) {
                genreChips
                ottQuickAccess

                ForEach(viewModel.sections) { section in
                    movieSection(section)
                }

                // Load remaining sections when user scrolls near bottom
                if viewModel.hasMoreSections {
                    Color.clear
                        .frame(height: 1)
                        .onAppear {
                            viewModel.loadMoreSections()
                        }
                }
            }
            .padding(.vertical)
        }
    }

    private var genreChips: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Genres")
                .font(.headline)
                .padding(.horizontal)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(MovieGenre.allCases) { genre in
                        NavigationLink {
                            GenreMoviesView(viewModel: viewModel, genre: genre)
                        } label: {
                            HStack(spacing: 4) {
                                Image(systemName: genre.icon)
                                    .font(.caption2)
                                Text(genre.name)
                                    .font(.caption)
                                    .fontWeight(.medium)
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(genre.color.opacity(0.15))
                            .foregroundStyle(genre.color)
                            .cornerRadius(20)
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
    }

    private var ottQuickAccess: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Streaming Platforms")
                .font(.headline)
                .padding(.horizontal)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(OTTPlatform.allCases) { platform in
                        NavigationLink {
                            PlatformMoviesView(viewModel: viewModel, platform: platform)
                        } label: {
                            VStack(spacing: 6) {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(platform.brandColor)
                                    .frame(width: 56, height: 56)
                                    .overlay {
                                        Text(platform.iconLetter)
                                            .font(.title2)
                                            .fontWeight(.bold)
                                            .foregroundStyle(.white)
                                    }
                                    .shadow(color: platform.brandColor.opacity(0.4), radius: 4, y: 2)

                                Text(platform.shortName)
                                    .font(.caption2)
                                    .fontWeight(.medium)
                                    .foregroundStyle(.primary)
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
    }

    private func movieSection(_ section: RecommendationEngine.RecommendationSection) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            VStack(alignment: .leading, spacing: 2) {
                Text(section.title)
                    .font(.title3)
                    .fontWeight(.bold)
                Text(section.subtitle)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal)

            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 16) {
                    ForEach(section.movies) { movie in
                        NavigationLink {
                            MovieDetailView(viewModel: viewModel, movie: movie)
                        } label: {
                            MovieCardView(movie: movie)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

// MARK: - Genre Movies View

struct GenreMoviesView: View {
    @ObservedObject var viewModel: MovieViewModel
    let genre: MovieGenre

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(viewModel.genreMovies) { movie in
                    NavigationLink {
                        MovieDetailView(viewModel: viewModel, movie: movie)
                    } label: {
                        MovieListRow(movie: movie)
                            .padding(.horizontal)
                    }
                    .buttonStyle(.plain)
                    Divider().padding(.horizontal)
                }

                if viewModel.genreMovies.isEmpty {
                    Text("No \(genre.name) movies found")
                        .foregroundStyle(.secondary)
                        .padding(.top, 40)
                }
            }
        }
        .navigationTitle(genre.name)
        .onAppear {
            viewModel.loadGenreMovies(genre: genre)
        }
    }
}

// MARK: - Platform Movies View

struct PlatformMoviesView: View {
    @ObservedObject var viewModel: MovieViewModel
    let platform: OTTPlatform

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(viewModel.platformMovies) { movie in
                    NavigationLink {
                        MovieDetailView(viewModel: viewModel, movie: movie)
                    } label: {
                        MovieListRow(movie: movie)
                            .padding(.horizontal)
                    }
                    .buttonStyle(.plain)
                    Divider().padding(.horizontal)
                }

                if viewModel.platformMovies.isEmpty {
                    Text("No movies found on \(platform.name)")
                        .foregroundStyle(.secondary)
                        .padding(.top, 40)
                }
            }
        }
        .navigationTitle(platform.name)
        .onAppear {
            viewModel.loadPlatformMovies(platform: platform)
        }
    }
}

// MARK: - Platform Browse Sheet

struct PlatformBrowseView: View {
    @ObservedObject var viewModel: MovieViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            List {
                ForEach(OTTPlatform.allCases) { platform in
                    HStack(spacing: 12) {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(platform.brandColor)
                            .frame(width: 44, height: 44)
                            .overlay {
                                Text(platform.iconLetter)
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .foregroundStyle(.white)
                            }

                        VStack(alignment: .leading) {
                            Text(platform.name)
                                .font(.body)
                                .fontWeight(.medium)
                            Text("\(MovieDatabase.shared.byPlatform(platform).count) titles")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
            .navigationTitle("Streaming Platforms")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}
