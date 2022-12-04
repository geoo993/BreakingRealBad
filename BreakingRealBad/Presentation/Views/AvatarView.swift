import SwiftUI

struct AvatarView: View {
    let url: URL
    let size: CGFloat

    var body: some View {
        AsyncImage(url: url) { phase in
            switch phase {
            case .empty:
                ProgressView()
            case .success(let image):
                image
                    .resizable()
                    .transition(.scale(scale: 0.1, anchor: .center))
            case .failure:
                Image(systemName: "exclamationmark.icloud.fill")
            @unknown default:
                EmptyView()
            }
        }
        .frame(width: size, height: size)
        .background(Color.gray)
        .clipShape(Circle())
    }
}
