import SwiftUI

struct LumenDetailView: View {
    @EnvironmentObject private var store: LumenStore
    let goods: LumenGoods
    var onSeat: () -> Void
    @State private var grams: Double = 120

    var body: some View {
        let preview = LumenScale.pack(
            kcal100: goods.kcal100,
            protein100: goods.protein100,
            carbs100: goods.carbs100,
            fat100: goods.fat100,
            grams: grams
        )
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                hero
                LumenGlassCard {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(goods.title)
                            .font(.system(.title2, design: .default).weight(.semibold))
                            .foregroundStyle(LumenPalette.ink)
                        if !goods.brand.isEmpty {
                            Text(goods.brand)
                                .font(.system(.caption, design: .default))
                                .foregroundStyle(LumenPalette.mute)
                        }
                        Text("Per 100 g")
                            .font(.system(.subheadline, design: .default).weight(.semibold))
                            .padding(.top, 6)
                        Text("\(fmt(goods.kcal100)) kcal · P \(fmt(goods.protein100)) · C \(fmt(goods.carbs100)) · F \(fmt(goods.fat100))")
                            .font(.system(.caption, design: .default).monospacedDigit())
                            .foregroundStyle(LumenPalette.mute)
                    }
                }
                LumenGlassCard {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Portion \(Int(grams)) g")
                            .font(.system(.headline, design: .default))
                        Slider(value: $grams, in: 20...400, step: 5)
                            .tint(LumenPalette.teal)
                        Text("\(fmt(preview.kcal)) kcal · P \(fmt(preview.protein)) · C \(fmt(preview.carbs)) · F \(fmt(preview.fat))")
                            .font(.system(.caption, design: .default).monospacedDigit())
                            .foregroundStyle(LumenPalette.ink)
                    }
                }
                LumenTealPill(title: "Seat this pane") { onSeat() }
                LumenTealPill(title: "Pin to wish", art: "ChromeSlotFrame") { store.pinWish(goods) }
            }
            .padding(16)
        }
        .background(LumenBackdrop())
        .navigationTitle("Card")
        .navigationBarTitleDisplayMode(.inline)
    }

    @ViewBuilder
    private var hero: some View {
        if let name = goods.artName {
            Image(name)
                .resizable()
                .scaledToFill()
                .frame(height: 200)
                .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
        } else if let remote = goods.remoteThumb, let url = URL(string: remote) {
            AsyncImage(url: url) { image in
                image.resizable().scaledToFill()
            } placeholder: {
                Image("ChromeSlotFrame").resizable().scaledToFill()
            }
            .frame(height: 200)
            .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
        } else {
            Image("OnboardScanGlass")
                .resizable()
                .scaledToFill()
                .frame(height: 200)
                .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
        }
    }

    private func fmt(_ value: Double) -> String {
        String(Int(value.rounded()))
    }
}
