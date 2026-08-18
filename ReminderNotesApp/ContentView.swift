import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            RemindersListView()
                .tabItem {
                    Label("Reminders", systemImage: "bell.badge")
                }

            NotesListView()
                .tabItem {
                    Label("Notes", systemImage: "note.text")
                }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(ReminderStore())
        .environmentObject(NoteStore())
        .environmentObject(NotificationManager.shared)
}
