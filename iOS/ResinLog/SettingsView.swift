import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var purchases: PurchaseManager
    @AppStorage("notif_enabled_resinlog") private var notificationsEnabled = true
    @AppStorage("units_pref_resinlog") private var useMetricUnits = false
    @State private var showingPaywall = false

    var body: some View {
        NavigationStack {
            Form {
                Section("Preferences") {
                    Toggle("Reminders", isOn: $notificationsEnabled)
                        .accessibilityIdentifier("toggleReminders")
                    Toggle("Metric Units", isOn: $useMetricUnits)
                        .accessibilityIdentifier("toggleMetric")
                }
                Section("Resin Log - Cure Tracker Pro") {
                    if purchases.isPurchased {
                        Label("Pro Unlocked", systemImage: "checkmark.seal.fill")
                            .foregroundStyle(Theme.accent)
                    } else {
                        Button("Unlock Pro") {
                            showingPaywall = true
                        }
                        .accessibilityIdentifier("unlockProButton")
                    }
                    Button("Restore Purchases") {
                        Task { await purchases.restore() }
                    }
                    .accessibilityIdentifier("restorePurchasesButton")
                }
                Section("About") {
                    Link("Privacy Policy", destination: URL(string: "https://shimondeitel.github.io/resinlog-app/privacy.html")!)
                    Link("Terms of Use", destination: URL(string: "https://shimondeitel.github.io/resinlog-app/terms.html")!)
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0")
                            .foregroundStyle(Theme.textMuted)
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                        .accessibilityIdentifier("settingsDoneButton")
                }
            }
            .sheet(isPresented: $showingPaywall) {
                PaywallView()
            }
        }
    }
}
