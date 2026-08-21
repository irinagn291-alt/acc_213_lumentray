import SwiftUI

struct LumenPlanView: View {
    @EnvironmentObject private var store: LumenStore
    @State private var day = Date()

    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(store.planDays(), id: \.self) { stamp in
                            Button {
                                day = stamp
                            } label: {
                                VStack(spacing: 4) {
                                    Text(stamp, format: .dateTime.weekday(.abbreviated))
                                        .font(.system(.caption2, design: .default))
                                    Text(stamp, format: .dateTime.day())
                                        .font(.system(.headline, design: .default).monospacedDigit())
                                }
                                .foregroundStyle(LumenPalette.ink)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(
                                    Capsule().fill(isSelected(stamp) ? LumenPalette.teal.opacity(0.22) : Color.white.opacity(0.35))
                                )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal, 16)
                }
                let rows = store.planned(on: day)
                if rows.isEmpty {
                    LumenEmptyPane(
                        art: "EmptyTodayTray",
                        title: "Clear glass ahead",
                        line: "Seat a hunt on First Light, Midday, or Evening. Nibble stays off the plan."
                    )
                    Spacer()
                } else {
                    List {
                        ForEach(rows) { bite in
                            LumenBiteRow(bite: bite)
                                .listRowBackground(Color.white.opacity(0.28))
                                .swipeActions(edge: .trailing) {
                                    Button("Serve") { store.serve(bite) }
                                        .tint(LumenPalette.teal)
                                }
                                .swipeActions(edge: .leading) {
                                    Button(role: .destructive) { store.dropBite(bite) } label: {
                                        Text("Lift")
                                    }
                                }
                        }
                    }
                    .scrollContentBackground(.hidden)
                }
            }
            .background(Color.clear)
            .navigationTitle("Plan")
            .onAppear { day = store.today }
        }
    }

    private func isSelected(_ stamp: Date) -> Bool {
        Calendar.current.isDate(stamp, inSameDayAs: day)
    }
}
