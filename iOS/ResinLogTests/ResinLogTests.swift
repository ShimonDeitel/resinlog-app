import XCTest
@testable import ResinLog

@MainActor
final class ResinLogTests: XCTestCase {
    func testSeedDataLoadsBelowFreeLimit() {
        let store = Store()
        XCTAssertLessThan(store.items.count, Store.freeLimit)
    }

    func testAddIncreasesCount() {
        let store = Store()
        let before = store.items.count
        store.add(Pour(title: "Test Entry"))
        XCTAssertEqual(store.items.count, before + 1)
    }

    func testAddInsertsAtFront() {
        let store = Store()
        store.add(Pour(title: "Newest"))
        XCTAssertEqual(store.items.first?.title, "Newest")
    }

    func testDeleteRemovesItem() {
        let store = Store()
        store.add(Pour(title: "ToDelete"))
        let idx = store.items.firstIndex(where: { $0.title == "ToDelete" })!
        store.delete(at: IndexSet(integer: idx))
        XCTAssertFalse(store.items.contains(where: { $0.title == "ToDelete" }))
    }

    func testCanAddWhenBelowLimit() {
        let store = Store()
        XCTAssertTrue(store.canAdd())
    }

    func testCannotAddAtFreeLimitWhenNotPro() {
        let store = Store()
        store.isProUnlocked = false
        while store.items.count < Store.freeLimit {
            store.add(Pour(title: "Filler"))
        }
        XCTAssertFalse(store.canAdd())
    }

    func testCanAddAtLimitWhenPro() {
        let store = Store()
        store.isProUnlocked = true
        while store.items.count < Store.freeLimit {
            store.add(Pour(title: "Filler"))
        }
        XCTAssertTrue(store.canAdd())
    }

    func testUpdateModifiesExistingItem() {
        let store = Store()
        store.add(Pour(title: "Original"))
        var item = store.items.first!
        item.title = "Renamed"
        store.update(item)
        XCTAssertEqual(store.items.first?.title, "Renamed")
    }
}
