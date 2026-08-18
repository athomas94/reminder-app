import SwiftUI

struct NotesListView: View {
    @EnvironmentObject private var noteStore: NoteStore
    @State private var isPresentingAdd = false

    var body: some View {
        NavigationStack {
            List {
                ForEach(noteStore.notes) { note in
                    VStack(alignment: .leading, spacing: 6) {
                        Text(note.text)
                            .font(.body)
                        Text(note.timestampLabel)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 4)
                }
                .onDelete(perform: noteStore.delete)

                if noteStore.notes.isEmpty {
                    VStack(spacing: 8) {
                        Image(systemName: "note.text")
                            .font(.largeTitle)
                            .foregroundStyle(.secondary)
                        Text("No Notes Yet")
                            .font(.headline)
                        Text("Tap + to log a note. It will be time-stamped automatically.")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 40)
                    .listRowSeparator(.hidden)
                }
            }
            .navigationTitle("Notes")
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
                AddNoteView()
            }
        }
    }
}

#Preview {
    NotesListView()
        .environmentObject(NoteStore())
}
