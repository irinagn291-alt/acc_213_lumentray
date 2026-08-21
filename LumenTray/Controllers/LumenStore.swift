import Combine
import Foundation
import SwiftUI

enum LumenSheet: Identifiable, Equatable {
    case hunt
    case pane
    case card(LumenGoods)
    case seat(LumenGoods, preferPlan: Bool)

    var id: String {
        switch self {
        case .hunt: "hunt"
        case .pane: "pane"
        case .card(let goods): "card-\(goods.sku)"
        case .seat(let goods, let preferPlan): "seat-\(goods.sku)-\(preferPlan)"
        }
    }
}

@MainActor
final class LumenStore: ObservableObject {
    @Published var vault: LumenVault
    @Published var sheet: LumenSheet?
    @Published var toast: String?
    @Published var showSplash = true

    private let fileURL: URL
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder

    init(fileURL: URL? = nil) {
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        self.fileURL = fileURL ?? documents.appendingPathComponent("lumen_vault.json")
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        encoder.outputFormatting = [.sortedKeys]
        self.encoder = encoder
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        self.decoder = decoder
        self.vault = LumenVault.empty
        pullDisk()
        LumenSeed.plant(into: &vault)
        pushDisk()
        LumenIntentBridge.shared.store = self
    }

    var today: Date { Calendar.current.startOfDay(for: Date()) }

    func todaySum() -> LumenMacroPack {
        LumenScale.dayTotals(bites: vault.bites, day: today)
    }

    func slotSum(_ slot: LumenSlot, day: Date? = nil) -> LumenMacroPack {
        let day = day ?? today
        return vault.bites
            .filter { !$0.isPlan && $0.slot == slot && Calendar.current.isDate($0.dayStamp, inSameDayAs: day) }
            .map(\.macros)
            .reduce(.zero, +)
    }

    func eaten(on day: Date) -> [LumenBite] {
        vault.bites
            .filter { !$0.isPlan && Calendar.current.isDate($0.dayStamp, inSameDayAs: day) }
            .sorted { $0.slot.rawValue < $1.slot.rawValue }
    }

    func planned(on day: Date) -> [LumenBite] {
        vault.bites
            .filter { $0.isPlan && Calendar.current.isDate($0.dayStamp, inSameDayAs: day) }
            .sorted { $0.slot.rawValue < $1.slot.rawValue }
    }

    func planDays() -> [Date] {
        (0..<7).compactMap { Calendar.current.date(byAdding: .day, value: $0, to: today) }
    }

    func finishOnboard() {
        vault.didFinishOnboard = true
        pushDisk()
    }

    func place(goods: LumenGoods, grams: Double, slot: LumenSlot, day: Date, asPlan: Bool) {
        if asPlan && !slot.allowsPlan {
            toast = "Nibble stays on the eaten tray"
            return
        }
        let clamped = min(max(grams, 5), 800)
        vault.bites.append(LumenBite.from(goods: goods, grams: clamped, slot: slot, day: day, isPlan: asPlan))
        pushDisk()
        toast = asPlan ? "Seated on the plan" : "Logged on the tray"
        sheet = nil
    }

    func quickLog(_ goods: LumenGoods, slot: LumenSlot) {
        place(goods: goods, grams: 100, slot: slot, day: today, asPlan: false)
    }

    func dropBite(_ bite: LumenBite) {
        vault.bites.removeAll { $0.id == bite.id }
        pushDisk()
    }

    func serve(_ bite: LumenBite) {
        guard let index = vault.bites.firstIndex(where: { $0.id == bite.id }) else { return }
        vault.bites[index].isPlan = false
        vault.bites[index].dayStamp = today
        pushDisk()
        toast = "Served onto today"
    }

    func pinWish(_ goods: LumenGoods) {
        if vault.wishes.contains(where: { $0.sku == goods.sku }) {
            toast = "Already on the wish pane"
            return
        }
        vault.wishes.append(LumenWish.from(goods))
        pushDisk()
        toast = "Pinned to wish"
    }

    func dropWish(_ wish: LumenWish) {
        vault.wishes.removeAll { $0.id == wish.id }
        pushDisk()
    }

    func writeAims(_ aims: LumenAims) {
        vault.aims = aims
        pushDisk()
    }

    func hideSplashSoon() {
        Task { @MainActor in
            try? await Task.sleep(for: .milliseconds(900))
            showSplash = false
        }
    }

    private func pullDisk() {
        guard let data = try? Data(contentsOf: fileURL) else { return }
        if let decoded = try? decoder.decode(LumenVault.self, from: data) {
            vault = decoded
        }
    }

    private func pushDisk() {
        guard let data = try? encoder.encode(vault) else { return }
        try? data.write(to: fileURL, options: [.atomic])
    }
}

@MainActor
final class LumenIntentBridge {
    static let shared = LumenIntentBridge()
    weak var store: LumenStore?

    func openHunt() { store?.sheet = .hunt }
    func openPane() { store?.sheet = .pane }
}
