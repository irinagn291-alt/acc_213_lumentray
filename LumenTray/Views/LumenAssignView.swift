import SwiftUI

struct LumenAssignView: View {
    @EnvironmentObject private var store: LumenStore
    let goods: LumenGoods
    var preferPlan: Bool = false
    @State private var grams: Double = 120
    @State private var slot: LumenSlot = .firstLight
    @State private var asPlan = false
    @State private var planDay = Date()

    private var planSlots: [LumenSlot] {
        asPlan ? LumenSlot.allCases.filter(\.allowsPlan) : LumenSlot.allCases
    }

    var body: some View {
        Form {
            Section("Slot") {
                Picker("Pane", selection: $slot) {
                    ForEach(planSlots) { item in
                        Text(item.title).tag(item)
                    }
                }
                .pickerStyle(.inline)
            }
            Section("Grams") {
                Slider(value: $grams, in: 20...400, step: 5)
                    .tint(LumenPalette.teal)
                Text("\(Int(grams)) g")
                    .font(.system(.body, design: .default).monospacedDigit())
            }
            Section("Where") {
                Toggle("Seat on the 7-day plan", isOn: $asPlan)
                    .tint(LumenPalette.teal)
                if asPlan {
                    Picker("Day", selection: $planDay) {
                        ForEach(store.planDays(), id: \.self) { stamp in
                            Text(stamp, format: .dateTime.weekday(.wide).month(.abbreviated).day())
                                .tag(stamp)
                        }
                    }
                }
            }
            Section {
                Button("Confirm seat") {
                    store.place(
                        goods: goods,
                        grams: grams,
                        slot: slot,
                        day: asPlan ? planDay : store.today,
                        asPlan: asPlan
                    )
                }
                .foregroundStyle(LumenPalette.teal)
            }
        }
        .scrollContentBackground(.hidden)
        .background(LumenBackdrop())
        .navigationTitle("Assign")
        .onAppear {
            asPlan = preferPlan
            planDay = store.today
        }
        .onChange(of: asPlan) { _, on in
            if on && !slot.allowsPlan { slot = .firstLight }
        }
    }
}
