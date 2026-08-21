import AppIntents

struct LumenOpenHuntIntent: AppIntent {
    static let title: LocalizedStringResource = "Hunt a food name"
    static let openAppWhenRun: Bool = true

    @MainActor
    func perform() async throws -> some IntentResult {
        LumenIntentBridge.shared.openHunt()
        return .result()
    }
}

struct LumenOpenPaneIntent: AppIntent {
    static let title: LocalizedStringResource = "Scan a glass code"
    static let openAppWhenRun: Bool = true

    @MainActor
    func perform() async throws -> some IntentResult {
        LumenIntentBridge.shared.openPane()
        return .result()
    }
}

struct LumenShortcuts: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: LumenOpenHuntIntent(),
            phrases: ["Hunt food in \(.applicationName)", "Search the tray in \(.applicationName)"],
            shortTitle: "Hunt",
            systemImageName: "magnifyingglass"
        )
        AppShortcut(
            intent: LumenOpenPaneIntent(),
            phrases: ["Scan a pane in \(.applicationName)", "Read a barcode in \(.applicationName)"],
            shortTitle: "Scan",
            systemImageName: "barcode.viewfinder"
        )
    }
}
