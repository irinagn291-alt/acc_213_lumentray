import SwiftUI

struct LumenGoalsView: View {
    @EnvironmentObject private var store: LumenStore
    @State private var kcal: Double = LumenAims.factory.kcal
    @State private var protein: Double = LumenAims.factory.protein
    @State private var carbs: Double = LumenAims.factory.carbs
    @State private var fat: Double = LumenAims.factory.fat
    @State private var showContact = false

    var body: some View {
        NavigationStack {
            Form {
                Section("Day aims") {
                    stepper("Energy kcal", value: $kcal, range: 800...3600, step: 10)
                    stepper("Protein g", value: $protein, range: 20...250, step: 1)
                    stepper("Carbs g", value: $carbs, range: 40...450, step: 1)
                    stepper("Fat g", value: $fat, range: 15...160, step: 1)
                }
                Section {
                    Button("Write aims") {
                        store.writeAims(LumenAims(kcal: kcal, protein: protein, carbs: carbs, fat: fat))
                        store.toast = "Aims etched"
                    }
                    .foregroundStyle(LumenPalette.teal)
                    Button("Contact Us") { showContact = true }
                        .foregroundStyle(LumenPalette.teal)
                }
            }
            .scrollContentBackground(.hidden)
            .background(Color.clear)
            .navigationTitle("Aims")
            .onAppear {
                kcal = store.vault.aims.kcal
                protein = store.vault.aims.protein
                carbs = store.vault.aims.carbs
                fat = store.vault.aims.fat
            }
            .sheet(isPresented: $showContact) {
                GlassContactPane()
            }
        }
    }

    private func stepper(_ title: String, value: Binding<Double>, range: ClosedRange<Double>, step: Double) -> some View {
        Stepper(value: value, in: range, step: step) {
            HStack {
                Text(title)
                Spacer()
                Text("\(Int(value.wrappedValue.rounded()))")
                    .font(.system(.body, design: .default).monospacedDigit())
                    .foregroundStyle(LumenPalette.teal)
            }
        }
    }
}
