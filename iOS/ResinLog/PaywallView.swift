import SwiftUI

struct PaywallView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var purchases: PurchaseManager
    @EnvironmentObject var store: Store

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.background.ignoresSafeArea()
                VStack(spacing: 20) {
                    Image(systemName: "sparkles")
                        .font(.system(size: 44))
                        .foregroundStyle(Theme.accent)
                    Text("Resin Log - Cure Tracker Pro")
                        .font(Theme.titleFont)
                        .foregroundStyle(Theme.text)
                    Text("Ambient Temp Cure Adjustor")
                        .font(Theme.bodyFont)
                        .foregroundStyle(Theme.textMuted)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)
                    VStack(alignment: .leading, spacing: 10) {
                        FeatureLine(text: "Unlimited pours")
                        FeatureLine(text: "Ambient Temp Cure Adjustor")
                        FeatureLine(text: "Priority support")
                    }
                    .padding()
                    .background(Theme.card)
                    .clipShape(RoundedRectangle(cornerRadius: Theme.cornerRadius))
                    .padding(.horizontal, 24)

                    Button {
                        Task { await purchases.purchase() }
                    } label: {
                        Text(purchases.product?.displayPrice.isEmpty == false ? "Unlock — \(purchases.product!.displayPrice)" : "Unlock — 1.99/month")
                            .font(Theme.headlineFont)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Theme.accent)
                            .foregroundStyle(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: Theme.cornerRadius))
                    }
                    .accessibilityIdentifier("purchaseButton")
                    .padding(.horizontal, 24)

                    Button("Restore Purchases") {
                        Task { await purchases.restore() }
                    }
                    .accessibilityIdentifier("restorePurchasesButtonPaywall")
                    .foregroundStyle(Theme.textMuted)

                    Spacer()
                }
                .padding(.top, 32)
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                        .accessibilityIdentifier("paywallCloseButton")
                }
            }
            .onChange(of: purchases.isPurchased) { _, newValue in
                if newValue { dismiss() }
            }
        }
    }
}

private struct FeatureLine: View {
    let text: String
    var body: some View {
        HStack {
            Image(systemName: "checkmark.circle.fill")
                .foregroundStyle(Theme.accent)
            Text(text)
                .foregroundStyle(Theme.text)
                .font(Theme.bodyFont)
        }
    }
}
