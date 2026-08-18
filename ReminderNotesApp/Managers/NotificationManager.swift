import Foundation
import UserNotifications

@MainActor
final class NotificationManager: ObservableObject {
    static let shared = NotificationManager()

    @Published var authorizationGranted = false

    private let center = UNUserNotificationCenter.current()

    private init() {}

    func requestAuthorizationIfNeeded() {
        center.getNotificationSettings { [weak self] settings in
            switch settings.authorizationStatus {
            case .notDetermined:
                self?.requestAuthorization()
            case .authorized, .provisional, .ephemeral:
                Task { @MainActor in self?.authorizationGranted = true }
            default:
                Task { @MainActor in self?.authorizationGranted = false }
            }
        }
    }

    func requestAuthorization() {
        center.requestAuthorization(options: [.alert, .sound, .badge]) { [weak self] granted, _ in
            Task { @MainActor in self?.authorizationGranted = granted }
        }
    }

    /// Schedules (or replaces) a repeating daily local notification for the given reminder.
    func schedule(_ reminder: ReminderTime) {
        center.removePendingNotificationRequests(withIdentifiers: [reminder.notificationIdentifier])
        guard reminder.isEnabled else { return }

        let content = UNMutableNotificationContent()
        content.title = "Reminder"
        content.body = reminder.message
        content.sound = .default

        var dateComponents = DateComponents()
        dateComponents.hour = reminder.hour
        dateComponents.minute = reminder.minute

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(
            identifier: reminder.notificationIdentifier,
            content: content,
            trigger: trigger
        )

        center.add(request)
    }

    func cancel(_ reminder: ReminderTime) {
        center.removePendingNotificationRequests(withIdentifiers: [reminder.notificationIdentifier])
    }

    /// Re-registers every enabled reminder with iOS, e.g. after app launch.
    func rescheduleAll(_ reminders: [ReminderTime]) {
        let identifiers = reminders.map { $0.notificationIdentifier }
        center.removePendingNotificationRequests(withIdentifiers: identifiers)
        for reminder in reminders where reminder.isEnabled {
            schedule(reminder)
        }
    }
}
