import SwiftUI

struct LumenSearchView: View {
    @EnvironmentObject private var store: LumenStore
    @State private var query = ""
    @State private var hits: [LumenGoods] = []
    @State private var busy = false
    @State private var note: String?
    @State private var path = NavigationPath()

    var body: some View {
        NavigationStack(path: $path) {
            List {
                Section {
                    HStack {
                        TextField("Hunt a name", text: $query)
                            .textInputAutocapitalization(.never)
                            .onSubmit { Task { await runHunt() } }
                        Button("Hunt") { Task { await runHunt() } }
                            .foregroundStyle(LumenPalette.teal)
                    }
                }
                if let note {
                    Section { Text(note).foregroundStyle(LumenPalette.mute) }
                }
                if query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    Section("Local pane") {
                        ForEach(LumenShelf.panes) { goods in
                            Button { path.append(LumenHuntHop.card(goods)) } label: {
                                LumenHitLabel(goods: goods)
                            }
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button("Log") { store.quickLog(goods, slot: .firstLight) }
                                    .tint(LumenPalette.teal)
                            }
                        }
                    }
                } else {
                    Section("Finds") {
                        ForEach(hits) { goods in
                            Button { path.append(LumenHuntHop.card(goods)) } label: {
                                LumenHitLabel(goods: goods)
                            }
                        }
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .background(LumenBackdrop())
            .navigationTitle("Hunt")
            .navigationDestination(for: LumenHuntHop.self) { hop in
                switch hop {
                case .card(let goods):
                    LumenDetailView(goods: goods) { path.append(LumenHuntHop.seat(goods)) }
                case .seat(let goods):
                    LumenAssignView(goods: goods)
                }
            }
            .overlay { if busy { ProgressView().tint(LumenPalette.teal) } }
        }
    }

    private func runHunt() async {
        busy = true
        note = nil
        defer { busy = false }
        do {
            hits = try await LumenCatalog.hunt(query)
        } catch {
            hits = []
            note = "No pane matched that name"
        }
    }
}

struct LumenHitLabel: View {
    let goods: LumenGoods

    var body: some View {
        HStack(spacing: 12) {
            thumb
            VStack(alignment: .leading, spacing: 4) {
                Text(goods.title)
                    .foregroundStyle(LumenPalette.ink)
                Text("\(Int(goods.kcal100.rounded())) kcal / 100 g")
                    .font(.system(.caption, design: .default))
                    .foregroundStyle(LumenPalette.mute)
            }
        }
    }

    @ViewBuilder
    private var thumb: some View {
        if let name = goods.artName {
            Image(name).resizable().scaledToFill().frame(width: 44, height: 44).clipShape(RoundedRectangle(cornerRadius: 10))
        } else if let remote = goods.remoteThumb, let url = URL(string: remote) {
            AsyncImage(url: url) { image in
                image.resizable().scaledToFill()
            } placeholder: {
                Image("ChromeSlotFrame").resizable().scaledToFill()
            }
            .frame(width: 44, height: 44)
            .clipShape(RoundedRectangle(cornerRadius: 10))
        } else {
            Image("ChromeSlotFrame").resizable().scaledToFill().frame(width: 44, height: 44).clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
}
