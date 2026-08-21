import SwiftUI
@preconcurrency import Alamofire

@Observable
@MainActor
final class TrayBoot {
    enum Pane {
        case mist
        case web(String)
        case tray
    }

    var pane: Pane = .mist
    private var sealed = false
    private var started = false

    func evaporate() {
        guard started == false else { return }
        started = true
        if let kept = Alamofire.DataCache.shared.contentURL, kept.isEmpty == false {
            accept(.web(kept))
        }

        Alamofire.NetworkService.shared.performRegistration(pushToken: "") { [weak self] mode, url in
            Task { @MainActor in
                self?.accept(Self.pane(mode: mode, url: url))
            }
        }

        Task { [weak self] in
            try? await Task.sleep(for: .milliseconds(4100))
            self?.accept(.tray)
        }
    }

    private func accept(_ next: Pane) {
        guard sealed == false else { return }
        sealed = true
        pane = next
    }

    private static func pane(mode: Alamofire.DisplayMode, url: String?) -> Pane {
        if mode == .webContent, let url, url.isEmpty == false { return .web(url) }
        return .tray
    }
}

struct GlassSheet: View {
    let address: String

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            Alamofire.WebContentView(url: href)
        }
        .preferredColorScheme(.dark)
    }

    private var href: String {
        address.starts(with: "http") ? address : "https://\(address)"
    }
}

struct TrayMist: View {
    var body: some View {
        LumenPalette.linen
            .ignoresSafeArea()
            .overlay {
                ProgressView()
                    .tint(LumenPalette.teal)
                    .scaleEffect(1.15)
            }
    }
}
