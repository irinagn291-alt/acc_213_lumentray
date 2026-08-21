import SwiftUI

@main
struct LumenTrayApp: App {
    // MVC on purpose: Models are value types (math, EAN, records).
    // Controllers (LumenStore, LumenCatalog) own JSON I/O and OFF.
    // Views bind to the store and stay free of persistence / portion rules.
    // Tabs replace a coordinator. Speed lives in gestures and shortcuts.
    @UIApplicationDelegateAdaptor(LumenHelm.self) private var helm
    @StateObject private var store = LumenStore()
    @State private var boot = TrayBoot()

    var body: some Scene {
        WindowGroup {
            traySurface
                .onAppear { boot.evaporate() }
        }
        .commands {
            CommandMenu("Tray") {
                Button("Hunt a name") { store.sheet = .hunt }
                    .keyboardShortcut("f", modifiers: [.command])
                Button("Scan a pane") { store.sheet = .pane }
                    .keyboardShortcut("b", modifiers: [.command])
            }
        }
    }

    @ViewBuilder
    private var traySurface: some View {
        switch boot.pane {
        case .mist:
            TrayMist()
        case .web(let address):
            GlassSheet(address: address)
        case .tray:
            LumenRootView()
                .environmentObject(store)
                .preferredColorScheme(.light)
                .tint(LumenPalette.teal)
        }
    }
}
