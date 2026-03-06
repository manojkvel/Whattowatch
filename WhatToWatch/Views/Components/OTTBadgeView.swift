import SwiftUI

struct OTTBadgeView: View {
    let platform: OTTPlatform
    var showFullName: Bool = false

    var body: some View {
        HStack(spacing: 4) {
            Circle()
                .fill(platform.brandColor)
                .frame(width: 8, height: 8)
            Text(showFullName ? platform.name : platform.shortName)
                .font(.caption2)
                .fontWeight(.medium)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(platform.brandColor.opacity(0.15))
        .foregroundStyle(platform.brandColor)
        .cornerRadius(6)
    }
}

struct OTTPlatformRow: View {
    let platform: OTTPlatform
    let isSelected: Bool
    var onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                RoundedRectangle(cornerRadius: 8)
                    .fill(platform.brandColor)
                    .frame(width: 40, height: 40)
                    .overlay {
                        Text(String(platform.shortName.prefix(1)))
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                    }

                Text(platform.name)
                    .font(.body)
                    .foregroundStyle(.primary)

                Spacer()

                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(platform.brandColor)
                }
            }
            .padding(.vertical, 4)
        }
    }
}

struct OTTAvailabilityView: View {
    let platforms: [OTTPlatform]

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label("Where to Watch", systemImage: "play.tv")
                .font(.headline)

            if platforms.isEmpty {
                HStack {
                    Image(systemName: "info.circle")
                        .foregroundStyle(.secondary)
                    Text("Streaming availability info not found for India")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
            } else {
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 8) {
                    ForEach(platforms) { platform in
                        HStack(spacing: 8) {
                            RoundedRectangle(cornerRadius: 6)
                                .fill(platform.brandColor)
                                .frame(width: 32, height: 32)
                                .overlay {
                                    Text(String(platform.shortName.prefix(1)))
                                        .font(.caption)
                                        .fontWeight(.bold)
                                        .foregroundStyle(.white)
                                }

                            Text(platform.name)
                                .font(.caption)
                                .fontWeight(.medium)
                                .lineLimit(1)

                            Spacer()
                        }
                        .padding(8)
                        .background(platform.brandColor.opacity(0.1))
                        .cornerRadius(8)
                    }
                }
            }
        }
    }
}
