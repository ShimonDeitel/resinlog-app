import Foundation

struct Pour: Identifiable, Codable, Equatable {
    var id: UUID
    var createdAt: Date
    var title: String
    var resinType: String
    var mixRatio: String
    var cureHours: String
    var notes: String

    init(id: UUID = UUID(), createdAt: Date = Date(), title: String = "", resinType: String = "", mixRatio: String = "", cureHours: String = "", notes: String = "") {
        self.id = id
        self.createdAt = createdAt
        self.title = title
        self.resinType = resinType
        self.mixRatio = mixRatio
        self.cureHours = cureHours
        self.notes = notes
    }
}
