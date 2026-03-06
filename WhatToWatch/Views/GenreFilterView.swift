import SwiftUI

struct GenreFilterView: View {
    @ObservedObject var viewModel: MovieViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            List {
                ForEach(MovieGenre.allCases) { genre in
                    let count = MovieDatabase.shared.byGenre(genre.name).count
                    HStack(spacing: 12) {
                        Image(systemName: genre.icon)
                            .font(.title3)
                            .foregroundStyle(genre.color)
                            .frame(width: 32)

                        Text(genre.name)
                            .font(.body)
                            .fontWeight(.medium)

                        Spacer()

                        if count > 0 {
                            Text("\(count)")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }

                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 4)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        dismiss()
                    }
                }
            }
            .navigationTitle("Browse by Genre")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}
