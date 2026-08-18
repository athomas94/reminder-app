import SwiftUI

struct AddNoteView: View {
    @EnvironmentObject private var noteStore: NoteStore
    @Environment(\.dismiss) private var dismiss
    @State private var text = ""

    var body: some View {
        NavigationStack {
            Form {
                Section("Note") {
                    TextField("What's on your mind?", text: $text, axis: .vertical)
                        .lineLimit(5...10)
                }

                Section {
                    Text("This note will be logged with the current date and time.")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("New Note")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        noteStore.add(text: text)
                        dismiss()
                    }
                    .disabled(text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }
}

#Preview {
    AddNoteView()
        .environmentObject(NoteStore())
}
