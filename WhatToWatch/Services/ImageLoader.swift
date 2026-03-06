import SwiftUI

@MainActor
final class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    @Published var isLoading = false

    private static let cache = NSCache<NSString, UIImage>()

    func load(from url: URL?) async {
        guard let url = url else { return }

        let key = url.absoluteString as NSString
        if let cached = Self.cache.object(forKey: key) {
            self.image = cached
            return
        }

        isLoading = true
        defer { isLoading = false }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let uiImage = UIImage(data: data) {
                Self.cache.setObject(uiImage, forKey: key)
                self.image = uiImage
            }
        } catch {
            // Silently fail for image loading
        }
    }
}

struct AsyncPosterImage: View {
    let url: URL?
    let width: CGFloat
    let height: CGFloat

    @StateObject private var loader = ImageLoader()

    var body: some View {
        Group {
            if let image = loader.image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: width, height: height)
                    .clipped()
            } else if loader.isLoading {
                ProgressView()
                    .frame(width: width, height: height)
                    .background(Color.gray.opacity(0.2))
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: width, height: height)
                    .overlay {
                        Image(systemName: "film")
                            .font(.largeTitle)
                            .foregroundStyle(.gray)
                    }
            }
        }
        .cornerRadius(12)
        .task {
            await loader.load(from: url)
        }
    }
}
