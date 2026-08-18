import SwiftUI

@main
struct ReminderNotesAppApp: App {
    @StateObject private var reminderStore = ReminderStore()
    @StateObject private var noteStore = NoteStore()
    @StateObject private var notificationManager = NotificationManager.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(reminderStore)
                .environmentObject(noteStore)
                .environmentObject(notificationManager)
                .onAppear {
                    notificationManager.requestAuthorizationIfNeeded()
                }
        }
    }
}
