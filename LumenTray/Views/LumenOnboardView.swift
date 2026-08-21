import SwiftUI

struct LumenOnboardView: View {
    @EnvironmentObject private var store: LumenStore
    @State private var page = 0

    private let pages: [(art: String, title: String, line: String)] = [
        ("OnboardFirstLight", "First light on glass", "A quiet tray. Four panes. Nothing logged until you sweep it in."),
        ("OnboardScanGlass", "Sweep a code", "Hunt a name or lift a barcode through the pane. The card holds per-100 g light."),
        ("OnboardSlots", "Four quiet slots", "First Light, Midday, Evening — and Nibble only once it is eaten."),
        ("OnboardAims", "Aims in teal", "Set a day of energy and macros. The tray stays on this phone.")
    ]

    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 0) {
                TabView(selection: $page) {
                    ForEach(pages.indices, id: \.self) { index in
                        VStack(spacing: 16) {
                            Image(pages[index].art)
                                .resizable()
                                .scaledToFit()
                                .frame(width: geo.size.width - 48, height: 220)
                                .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
                            Text(pages[index].title)
                                .font(.system(size: 24, weight: .semibold))
                                .foregroundStyle(Color.black)
                                .multilineTextAlignment(.center)
                                .frame(width: geo.size.width - 40)
                            Text(pages[index].line)
                                .font(.system(size: 16))
                                .foregroundStyle(Color.black.opacity(0.65))
                                .multilineTextAlignment(.center)
                                .lineLimit(4)
                                .frame(width: geo.size.width - 48)
                            Spacer(minLength: 8)
                        }
                        .frame(width: geo.size.width, height: geo.size.height - 90)
                        .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .always))
                .frame(width: geo.size.width, height: geo.size.height - 90)
                LumenTealPill(title: page == pages.count - 1 ? "Step onto the tray" : "Next pane") {
                    if page == pages.count - 1 {
                        store.finishOnboard()
                    } else {
                        page += 1
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 24)
            }
        }
    }
}
