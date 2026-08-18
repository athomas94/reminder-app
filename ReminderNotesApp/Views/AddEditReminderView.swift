import SwiftUI

struct AddEditReminderView: View {
    @EnvironmentObject private var reminderStore: ReminderStore
    @Environment(\.dismiss) private var dismiss

    let reminder: ReminderTime?

    @State private var selectedTime: Date
    @State private var message: String

    init(reminder: ReminderTime?) {
        self.reminder = reminder
        if let reminder {
            var components = DateComponents()
            components.hour = reminder.hour
            components.minute = reminder.minute
            _selectedTime = State(initialValue: Calendar.current.date(from: components) ?? Date())
            _message = State(initialValue: reminder.message)
        } else {
            _selectedTime = State(initialValue: Date())
            _message = State(initialValue: "")
        }
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Time") {
                    DatePicker("Reminder Time", selection: $selectedTime, displayedComponents: .hourAndMinute)
                        .datePickerStyle(.wheel)
                        .labelsHidden()
                }

                Section("Notification Text") {
                    TextField("What should the notification say?", text: $message, axis: .vertical)
                        .lineLimit(3...6)
                }
            }
            .navigationTitle(reminder == nil ? "New Reminder" : "Edit Reminder")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        save()
                        dismiss()
                    }
                    .disabled(message.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }

    private func save() {
        let components = Calendar.current.dateComponents([.hour, .minute], from: selectedTime)
        let hour = components.hour ?? 9
        let minute = components.minute ?? 0
        let trimmedMessage = message.trimmingCharacters(in: .whitespacesAndNewlines)

        if var existing = reminder {
            existing.hour = hour
            existing.minute = minute
            existing.message = trimmedMessage
            reminderStore.update(existing)
        } else {
            reminderStore.add(hour: hour, minute: minute, message: trimmedMessage)
        }
    }
}

#Preview {
    AddEditReminderView(reminder: nil)
        .environmentObject(ReminderStore())
}
