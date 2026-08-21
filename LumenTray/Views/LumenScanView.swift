import SwiftUI

struct LumenScanView: View {
    @EnvironmentObject private var store: LumenStore
    @State private var typed = ""
    @State private var busy = false
    @State private var note: String?
    @State private var path = NavigationPath()

    var body: some View {
        NavigationStack(path: $path) {
            VStack(spacing: 16) {
                LumenPaneScanner { raw in
                    Task { await pull(raw) }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 28, style: .continuous)
                        .stroke(LumenPalette.teal.opacity(0.5), lineWidth: 1)
                )
                .padding(.horizontal, 16)

                LumenGlassCard {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Or type a glyph")
                            .font(.system(.subheadline, design: .default).weight(.semibold))
                        HStack {
                            TextField("EAN / URL", text: $typed)
                                .keyboardType(.numbersAndPunctuation)
                                .textInputAutocapitalization(.never)
                            Button("Lift") { Task { await pull(typed) } }
                                .foregroundStyle(LumenPalette.teal)
                        }
                        if let note {
                            Text(note)
                                .font(.system(.caption, design: .default))
                                .foregroundStyle(LumenPalette.mute)
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 12)
            }
            .background(LumenBackdrop())
            .navigationTitle("Scan pane")
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

    private func pull(_ raw: String) async {
        busy = true
        note = nil
        defer { busy = false }
        do {
            let goods = try await LumenCatalog.pane(raw)
            path.append(LumenHuntHop.card(goods))
        } catch {
            note = "That code did not open a pane"
        }
    }
}
