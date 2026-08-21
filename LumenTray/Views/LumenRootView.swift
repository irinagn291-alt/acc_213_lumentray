import SwiftUI

struct LumenRootView: View {
    @EnvironmentObject private var store: LumenStore

    var body: some View {
        ZStack {
            LumenBackdrop()
            if store.vault.didFinishOnboard {
                tabs
            } else {
                LumenOnboardView()
            }
            if store.showSplash {
                splash
            }
        }
        .onAppear { store.hideSplashSoon() }
        .sheet(item: $store.sheet) { sheet in
            switch sheet {
            case .hunt:
                LumenSearchView()
            case .pane:
                LumenScanView()
            case .card(let goods):
                NavigationStack {
                    LumenDetailView(goods: goods) {
                        store.sheet = .seat(goods, preferPlan: false)
                    }
                }
            case .seat(let goods, let preferPlan):
                NavigationStack {
                    LumenAssignView(goods: goods, preferPlan: preferPlan)
                }
            }
        }
        .alert("Tray", isPresented: toastBind) {
            Button("OK", role: .cancel) { store.toast = nil }
        } message: {
            Text(store.toast ?? "")
        }
    }

    private var toastBind: Binding<Bool> {
        Binding(
            get: { store.toast != nil },
            set: { if !$0 { store.toast = nil } }
        )
    }

    private var tabs: some View {
        TabView {
            LumenTodayView()
                .tabItem { Label("Today", systemImage: "sun.horizon.fill") }
            LumenEatenView()
                .tabItem { Label("Eaten", systemImage: "fork.knife") }
            LumenPlanView()
                .tabItem { Label("Plan", systemImage: "calendar") }
            LumenWishView()
                .tabItem { Label("Wish", systemImage: "heart.fill") }
            LumenGoalsView()
                .tabItem { Label("Aims", systemImage: "target") }
        }
    }

    private var splash: some View {
        ZStack {
            LumenPalette.linen.ignoresSafeArea()
            Image("SplashGlassDawn")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
        }
        .transition(.opacity)
    }
}

#Preview {
    LumenRootView()
        .environmentObject(LumenStore())
}
