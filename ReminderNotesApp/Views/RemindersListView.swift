import SwiftUI

struct RemindersListView: View {
    @EnvironmentObject private var reminderStore: ReminderStore
    @EnvironmentObject private var notificationManager: NotificationManager
    @State private var isPresentingAdd = false
    @State private var editingReminder: ReminderTime?

    var body: some View {
        NavigationStack {
            List {
                if !notificationManager.authorizationGranted {
                    Section {
                        Label("Enable notifications in Settings to receive reminders.", systemImage: "exclamationmark.triangle")
                            .foregroundStyle(.orange)
                            .font(.footnote)
                    }
                }

                Section {
                    ForEach(reminderStore.reminders) { reminder in
                        Button {
                            editingReminder = reminder
                        } label: {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(reminder.timeLabel)
                                        .font(.headline)
                                    Text(reminder.message)
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                        .lineLimit(2)
                                }
                                Spacer()
                                Toggle("", isOn: Binding(
                                    get: { reminder.isEnabled },
                                    set: { _ in reminderStore.toggle(reminder) }
                                ))
                                .labelsHidden()
                            }
                        }
                        .foregroundStyle(.primary)
                    }
                    .onDelete(perform: reminderStore.delete)
                } header: {
                    if !reminderStore.reminders.isEmpty {
                        Text("Scheduled Reminders")
                    }
                }

                if reminderStore.reminders.isEmpty {
                    VStack(spacing: 8) {
                        Image(systemName: "bell.slash")
                            .font(.largeTitle)
                            .foregroundStyle(.secondary)
                        Text("No Reminders Yet")
                            .font(.headline)
                        Text("Tap + to schedule your first reminder.")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 40)
                    .listRowSeparator(.hidden)
                }
            }
            .navigationTitle("Reminders")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        isPresentingAdd = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $isPresentingAdd) {
                AddEditReminderView(reminder: nil)
            }
            .sheet(item: $editingReminder) { reminder in
                AddEditReminderView(reminder: reminder)
            }
        }
    }
}

#Preview {
    RemindersListView()
        .environmentObject(ReminderStore())
        .environmentObject(NotificationManager.shared)
}
