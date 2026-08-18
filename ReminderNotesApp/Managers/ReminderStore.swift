import Foundation
import Combine

@MainActor
final class ReminderStore: ObservableObject {
    @Published private(set) var reminders: [ReminderTime] = []

    private let storageKey = "com.remindernotes.reminders"
    private let notificationManager: NotificationManager

    init(notificationManager: NotificationManager = .shared) {
        self.notificationManager = notificationManager
        load()
    }

    func add(hour: Int, minute: Int, message: String) {
        let reminder = ReminderTime(hour: hour, minute: minute, message: message)
        reminders.append(reminder)
        sortReminders()
        save()
        notificationManager.schedule(reminder)
    }

    func update(_ reminder: ReminderTime) {
        guard let index = reminders.firstIndex(where: { $0.id == reminder.id }) else { return }
        reminders[index] = reminder
        sortReminders()
        save()
        notificationManager.schedule(reminder)
    }

    func delete(at offsets: IndexSet) {
        let removed = offsets.map { reminders[$0] }
        reminders.remove(atOffsets: offsets)
        save()
        removed.forEach { notificationManager.cancel($0) }
    }

    func toggle(_ reminder: ReminderTime) {
        guard let index = reminders.firstIndex(where: { $0.id == reminder.id }) else { return }
        reminders[index].isEnabled.toggle()
        save()
        notificationManager.schedule(reminders[index])
    }

    private func sortReminders() {
        reminders.sort { ($0.hour, $0.minute) < ($1.hour, $1.minute) }
    }

    private func load() {
        guard let data = UserDefaults.standard.data(forKey: storageKey),
              let decoded = try? JSONDecoder().decode([ReminderTime].self, from: data) else { return }
        reminders = decoded
        notificationManager.rescheduleAll(reminders)
    }

    private func save() {
        guard let data = try? JSONEncoder().encode(reminders) else { return }
        UserDefaults.standard.set(data, forKey: storageKey)
    }
}
