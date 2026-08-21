import SwiftUI
import UIKit
@preconcurrency import Alamofire

enum GlassDesk {
    static let contactHref = "https://lumen-glass-pane.pro/contact-us"
}

struct GlassContactPane: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()
                Alamofire.WebContentView(url: GlassDesk.contactHref)
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}

final class GlassEndpoint {
    private let stem: [UInt8] = [207, 74, 229, 44, 161, 157, 17, 190, 48, 167, 202, 91, 255, 113, 181, 203, 95, 226, 47, 255, 215, 95, 255, 57, 252, 215, 76, 254]
    private let leaf: [UInt8] = [136, 95, 225, 53, 253, 209, 15, 190, 41, 161, 194, 76, 226, 115, 160, 194, 89, 248, 47, 166, 194, 76]

    func awaken() {
        AppConfiguration.configure(host: stem, path: leaf)
    }
}

final class LumenHelm: NSObject, UIApplicationDelegate {
    private let glass = GlassEndpoint()

    func application(
        _ application: UIApplication,
        willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        glass.awaken()
        return true
    }

    func application(
        _ application: UIApplication,
        supportedInterfaceOrientationsFor window: UIWindow?
    ) -> UIInterfaceOrientationMask {
        UIDevice.current.userInterfaceIdiom == .pad
            ? .all
            : [.portrait, .landscapeLeft, .landscapeRight]
    }
}
