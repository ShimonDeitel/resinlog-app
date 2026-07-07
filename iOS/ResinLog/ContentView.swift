import SwiftUI

struct ContentView: View {
    @EnvironmentObject var store: Store
    @EnvironmentObject var purchases: PurchaseManager
    @State private var showingAdd = false
    @State private var showingPaywall = false
    @State private var showingSettings = false
    @State private var selectedItem: Pour?

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.background.ignoresSafeArea()
                if store.items.isEmpty {
                    emptyState
                } else {
                    list
                }
            }
            .navigationTitle("Pours")
            .toolbarBackground(Theme.background, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        showingSettings = true
                    } label: {
                        Image(systemName: "gearshape.fill")
                    }
                    .accessibilityIdentifier("settingsButton")
                    .tint(Theme.accent)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        if store.canAdd() {
                            showingAdd = true
                        } else {
                            showingPaywall = true
                        }
                    } label: {
                        Image(systemName: "plus.circle.fill")
                    }
                    .accessibilityIdentifier("addButton")
                    .tint(Theme.accent)
                }
            }
            .sheet(isPresented: $showingAdd) {
                EditItemView(item: nil) { newItem in
                    store.add(newItem)
                }
            }
            .sheet(item: $selectedItem) { item in
                EditItemView(item: item) { updated in
                    store.update(updated)
                }
            }
            .sheet(isPresented: $showingPaywall) {
                PaywallView()
            }
            .sheet(isPresented: $showingSettings) {
                SettingsView()
            }
        }
        .tint(Theme.accent)
    }

    private var list: some View {
        List {
            ForEach(store.items) { item in
                Button {
                    selectedItem = item
                } label: {
                    ItemRow(item: item)
                }
                .accessibilityIdentifier("row_\(item.title.isEmpty ? item.id.uuidString : item.title)")
                .listRowBackground(Theme.card)
            }
            .onDelete { offsets in
                store.delete(at: offsets)
            }
        }
        .scrollContentBackground(.hidden)
        .listStyle(.plain)
    }

    private var emptyState: some View {
        VStack(spacing: 12) {
            Image(systemName: "tray")
                .font(.system(size: 40))
                .foregroundStyle(Theme.textMuted)
            Text("No pours yet")
                .font(Theme.headlineFont)
                .foregroundStyle(Theme.text)
            Text("Tap + to log your first one.")
                .font(Theme.captionFont)
                .foregroundStyle(Theme.textMuted)
        }
    }
}

private struct ItemRow: View {
    let item: Pour

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(item.title)
                .font(Theme.headlineFont)
                .foregroundStyle(Theme.text)
            if !item.resinType.isEmpty {
            Text(item.resinType)
                .font(Theme.captionFont)
                .foregroundStyle(Theme.textMuted)
                .lineLimit(1)
            }
        }
        .padding(.vertical, 4)
    }
}

struct LabeledRow: View {
    let label: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(label.uppercased())
                .font(.caption2)
                .foregroundStyle(Theme.textMuted)
            Text(value)
                .font(Theme.bodyFont)
                .foregroundStyle(Theme.text)
        }
        .padding(.vertical, 4)
    }
}

struct EditItemView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var draft: Pour
    private let isNew: Bool
    private let onSave: (Pour) -> Void

    init(item: Pour?, onSave: @escaping (Pour) -> Void) {
        _draft = State(initialValue: item ?? Pour())
        self.isNew = item == nil
        self.onSave = onSave
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                TextField("Pour Name", text: $draft.title)
                    .accessibilityIdentifier("field_title")
                TextField("Resin Type", text: $draft.resinType, axis: .vertical)
                    .accessibilityIdentifier("field_resinType")
                TextField("Mix Ratio", text: $draft.mixRatio, axis: .vertical)
                    .accessibilityIdentifier("field_mixRatio")
                TextField("Cure Time (hrs)", text: $draft.cureHours, axis: .vertical)
                    .accessibilityIdentifier("field_cureHours")
                TextField("Notes", text: $draft.notes, axis: .vertical)
                    .accessibilityIdentifier("field_notes")
                }
            }
            .navigationTitle(isNew ? "New Pour" : "Edit Pour")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                        .accessibilityIdentifier("cancelButton")
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        onSave(draft)
                        dismiss()
                    }
                    .accessibilityIdentifier("saveButton")
                    .disabled(draft.title.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
            .onTapGesture {
                hideKeyboard()
            }
        }
    }
}

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
