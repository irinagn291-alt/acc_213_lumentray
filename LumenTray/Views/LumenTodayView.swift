import SwiftUI

struct LumenTodayView: View {
    @EnvironmentObject private var store: LumenStore

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    macros
                    slots
                    actions
                    Text("Local pane · swipe to log")
                        .font(.system(.subheadline, design: .default).weight(.semibold))
                        .foregroundStyle(LumenPalette.ink)
                    ForEach(LumenShelf.panes) { goods in
                        LumenShelfRow(goods: goods)
                    }
                }
                .padding(16)
            }
            .scrollContentBackground(.hidden)
            .background(Color.clear)
            .navigationTitle("Today")
        }
    }

    private var macros: some View {
        let sum = store.todaySum()
        let aims = store.vault.aims
        return LumenGlassCard {
            VStack(alignment: .leading, spacing: 12) {
                Text("Against aims")
                    .font(.system(.headline, design: .default))
                    .foregroundStyle(LumenPalette.ink)
                LumenMacroBar(title: "Energy", value: sum.kcal, aim: aims.kcal, unit: "kcal")
                LumenMacroBar(title: "Protein", value: sum.protein, aim: aims.protein, unit: "g")
                LumenMacroBar(title: "Carbs", value: sum.carbs, aim: aims.carbs, unit: "g")
                LumenMacroBar(title: "Fat", value: sum.fat, aim: aims.fat, unit: "g")
            }
        }
    }

    private var slots: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
            ForEach(LumenSlot.allCases) { slot in
                let pack = store.slotSum(slot)
                LumenGlassCard(padded: false) {
                    VStack(alignment: .leading, spacing: 0) {
                        Color.white
                            .frame(height: 88)
                            .overlay {
                                Image(slot.artName)
                                    .resizable()
                                    .scaledToFill()
                            }
                            .clipped()
                        VStack(alignment: .leading, spacing: 2) {
                            Text(slot.title)
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundStyle(Color.black)
                            Text("\(Int(pack.kcal.rounded())) kcal")
                                .font(.system(size: 13).monospacedDigit())
                                .foregroundStyle(Color.black.opacity(0.55))
                        }
                        .padding(12)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.white)
                    }
                }
                .contextMenu {
                    Button("Hunt into \(slot.title)") { store.sheet = .hunt }
                }
            }
        }
    }

    private var actions: some View {
        HStack(spacing: 12) {
            LumenTealPill(title: "Hunt name", art: "ChromeGlassPill") { store.sheet = .hunt }
            LumenTealPill(title: "Scan pane", art: "ChromeTealBezel") { store.sheet = .pane }
        }
    }

}

struct LumenShelfRow: View {
    @EnvironmentObject private var store: LumenStore
    let goods: LumenGoods

    var body: some View {
        LumenGlassCard {
            HStack(spacing: 12) {
                art
                    .frame(width: 56, height: 56)
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                VStack(alignment: .leading, spacing: 4) {
                    Text(goods.title)
                        .font(.system(.body, design: .default).weight(.medium))
                        .foregroundStyle(LumenPalette.ink)
                    Text("\(Int(goods.kcal100.rounded())) kcal / 100 g")
                        .font(.system(.caption, design: .default))
                        .foregroundStyle(LumenPalette.mute)
                }
                Spacer()
            }
        }
        .contentShape(Rectangle())
        .onTapGesture { store.sheet = .card(goods) }
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            Button("Log") { store.quickLog(goods, slot: .firstLight) }
                .tint(LumenPalette.teal)
        }
        .swipeActions(edge: .leading) {
            Button("Wish") { store.pinWish(goods) }
                .tint(LumenPalette.mute)
        }
        .contextMenu {
            ForEach(LumenSlot.allCases) { slot in
                Button(slot.title) { store.quickLog(goods, slot: slot) }
            }
            Button("Wish pane") { store.pinWish(goods) }
        }
    }

    @ViewBuilder
    private var art: some View {
        if let name = goods.artName {
            Image(name).resizable().scaledToFill()
        } else {
            Image("ChromeSlotFrame").resizable().scaledToFill()
        }
    }
}
