import Foundation
import Combine

@MainActor
final class Store: ObservableObject {
    @Published private(set) var items: [Pour] = []
    @Published var isProUnlocked: Bool = false

    /// Free-tier cap. Seed data ships with 3 items, so this is set well above
    /// that to guarantee a fresh install never trips the paywall immediately.
    static let freeLimit = 15

    private let fileURL: URL

    init() {
        let support = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        let dir = support.appendingPathComponent("ResinLog", isDirectory: true)
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        fileURL = dir.appendingPathComponent("pours.json")
        load()
    }

    var isAtFreeLimit: Bool {
        !isProUnlocked && items.count >= Store.freeLimit
    }

    func canAdd() -> Bool {
        isProUnlocked || items.count < Store.freeLimit
    }

    func add(_ item: Pour) {
        guard canAdd() else { return }
        items.insert(item, at: 0)
        save()
    }

    func update(_ item: Pour) {
        guard let idx = items.firstIndex(where: { $0.id == item.id }) else { return }
        items[idx] = item
        save()
    }

    func delete(at offsets: IndexSet) {
        items.remove(atOffsets: offsets)
        save()
    }

    func delete(_ item: Pour) {
        items.removeAll(where: { $0.id == item.id })
        save()
    }

    private func load() {
        if let data = try? Data(contentsOf: fileURL),
           let decoded = try? JSONDecoder().decode([Pour].self, from: data) {
            items = decoded
        } else {
            items = Store.seedData
        }
    }

    private func save() {
        guard let data = try? JSONEncoder().encode(items) else { return }
        try? data.write(to: fileURL, options: .atomic)
    }

    static let seedData: [Pour] = [
        Pour(title: "River Table Slab", resinType: "Deep Pour Epoxy", mixRatio: "2:1 by volume", cureHours: "72", notes: "Poured in 1in lifts, 24hr between"),
        Pour(title: "Coaster Set", resinType: "Fast Cure Casting", mixRatio: "1:1 by volume", cureHours: "24", notes: "Demold at 24hr, cure fully at 7 days"),
        Pour(title: "Pendant Batch", resinType: "UV Resin", mixRatio: "N/A single part", cureHours: "1", notes: "Cured under 36W UV lamp")
    ]
}
