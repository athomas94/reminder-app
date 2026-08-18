import Foundation

struct ReminderTime: Identifiable, Codable, Equatable {
    let id: UUID
    var hour: Int
    var minute: Int
    var message: String
    var isEnabled: Bool

    init(id: UUID = UUID(), hour: Int, minute: Int, message: String, isEnabled: Bool = true) {
        self.id = id
        self.hour = hour
        self.minute = minute
        self.message = message
        self.isEnabled = isEnabled
    }

    var timeLabel: String {
        var components = DateComponents()
        components.hour = hour
        components.minute = minute
        let date = Calendar.current.date(from: components) ?? Date()
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }

    var notificationIdentifier: String {
        "reminder-\(id.uuidString)"
    }
}
