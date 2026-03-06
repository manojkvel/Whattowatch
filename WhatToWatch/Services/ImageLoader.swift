import SwiftUI

@MainActor
final class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    @Published var isLoading = false

    private static let cache: NSCache<NSString, UIImage> = {
        let cache = NSCache<NSString, UIImage>()
        cache.countLimit = 60
        cache.totalCostLimit = 30 * 1024 * 1024 // 30 MB
        return cache
    }()

    // Limit concurrent downloads to avoid overwhelming iPad
    private static let semaphore = DispatchSemaphore(value: 4)

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
                let cost = data.count
                Self.cache.setObject(uiImage, forKey: key, cost: cost)
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
                Rectangle()
                    .fill(Color.gray.opacity(0.15))
                    .frame(width: width, height: height)
                    .overlay {
                        ProgressView()
                            .scaleEffect(0.7)
                    }
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.15))
                    .frame(width: width, height: height)
                    .overlay {
                        Image(systemName: "film")
                            .font(.title2)
                            .foregroundStyle(.gray.opacity(0.5))
                    }
            }
        }
        .cornerRadius(12)
        .task {
            await loader.load(from: url)
        }
    }
}
