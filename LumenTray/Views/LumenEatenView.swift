import SwiftUI

struct LumenEatenView: View {
    @EnvironmentObject private var store: LumenStore

    var body: some View {
        NavigationStack {
            Group {
                let rows = store.eaten(on: store.today)
                if rows.isEmpty {
                    LumenEmptyPane(
                        art: "EmptyEatenGlass",
                        title: "No panes eaten",
                        line: "Swipe a shelf row or hunt a name to seat today."
                    )
                    .padding()
                } else {
                    List {
                        ForEach(rows) { bite in
                            LumenBiteRow(bite: bite)
                                .listRowBackground(Color.white.opacity(0.28))
                                .swipeActions {
                                    Button(role: .destructive) { store.dropBite(bite) } label: {
                                        Text("Lift")
                                    }
                                }
                        }
                    }
                    .scrollContentBackground(.hidden)
                }
            }
            .background(Color.clear)
            .navigationTitle("Eaten")
        }
    }
}

struct LumenBiteRow: View {
    let bite: LumenBite

    var body: some View {
        HStack(spacing: 12) {
            Image(bite.slot.artName)
                .resizable()
                .scaledToFill()
                .frame(width: 44, height: 44)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            VStack(alignment: .leading, spacing: 4) {
                Text(bite.title)
                    .font(.system(.body, design: .default).weight(.medium))
                    .foregroundStyle(LumenPalette.ink)
                Text("\(bite.slot.title) · \(Int(bite.grams)) g · \(Int(bite.macros.kcal.rounded())) kcal")
                    .font(.system(.caption, design: .default))
                    .foregroundStyle(LumenPalette.mute)
            }
        }
    }
}
