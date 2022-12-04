import SwiftUI

struct CardView: View {
    @Binding var character: Character
    
    var body: some View {
        ZStack {
            Color("CardColor")
            HStack(spacing: 10) {
                Unwrap(character.imageUrl) { url in
                    AvatarView(url: url, size: 100)
                }
                VStack(spacing: 5) {
                    Text(character.name)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.headline)
                    Text("portrayed_by__title".localized(arguments: character.portrayed))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.caption)
                }
                Button(action: {
                    character.isFavoured.toggle()
                }) {
                    Image(systemName: character.isFavoured ? "heart.fill" : "heart")
                }
                .frame(maxWidth: 20, alignment: .trailing)
            }
            .padding()
        }
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.gray, lineWidth: 1)
        )
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(
            character: .init(
                get: { .fixture()},
                set: { _ in })
        )
        .frame(height: 200)
    }
}
