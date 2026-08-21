import SwiftUI

struct LumenWishView: View {
    @EnvironmentObject private var store: LumenStore

    var body: some View {
        NavigationStack {
            Group {
                if store.vault.wishes.isEmpty {
                    LumenEmptyPane(
                        art: "EmptyWishShelf",
                        title: "Wish pane is clear",
                        line: "Pin from a card. The same SKU will not sit twice."
                    )
                    .padding()
                } else {
                    List {
                        ForEach(store.vault.wishes) { wish in
                            Button {
                                store.sheet = .card(wish.asGoods())
                            } label: {
                                HStack {
                                    if let art = wish.artName {
                                        Image(art)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 44, height: 44)
                                            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                                    }
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(wish.title)
                                            .foregroundStyle(LumenPalette.ink)
                                        Text("\(Int(wish.kcal100.rounded())) kcal / 100 g")
                                            .font(.system(.caption, design: .default))
                                            .foregroundStyle(LumenPalette.mute)
                                    }
                                }
                            }
                            .listRowBackground(Color.white.opacity(0.28))
                            .swipeActions {
                                Button(role: .destructive) { store.dropWish(wish) } label: {
                                    Text("Lift")
                                }
                            }
                        }
                    }
                    .scrollContentBackground(.hidden)
                }
            }
            .background(Color.clear)
            .navigationTitle("Wish")
        }
    }
}
