import SwiftUI

@main
struct ResinLogApp: App {
    @StateObject private var store = Store()
    @StateObject private var purchases = PurchaseManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store)
                .environmentObject(purchases)
                .task {
                    store.isProUnlocked = purchases.isPurchased
                }
                .onChange(of: purchases.isPurchased) { _, newValue in
                    store.isProUnlocked = newValue
                }
                .preferredColorScheme(.dark)
        }
    }
}
