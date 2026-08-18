import Foundation
import Combine

@MainActor
final class NoteStore: ObservableObject {
    @Published private(set) var notes: [NoteEntry] = []

    private let storageKey = "com.remindernotes.notes"

    init() {
        load()
    }

    /// Adds a new note, stamped with the current date and time.
    func add(text: String) {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        let note = NoteEntry(text: trimmed)
        notes.insert(note, at: 0)
        save()
    }

    func delete(at offsets: IndexSet) {
        notes.remove(atOffsets: offsets)
        save()
    }

    private func load() {
        guard let data = UserDefaults.standard.data(forKey: storageKey),
              let decoded = try? JSONDecoder().decode([NoteEntry].self, from: data) else { return }
        notes = decoded
    }

    private func save() {
        guard let data = try? JSONEncoder().encode(notes) else { return }
        UserDefaults.standard.set(data, forKey: storageKey)
    }
}
