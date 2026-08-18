# Reminder Notes

A SwiftUI iPhone app with two tabs:

- **Reminders** — schedule any number of local notifications per day, each at its
  own time, with fully custom notification text. Toggle, edit, or delete any
  reminder; they persist across launches and are rescheduled automatically with
  iOS's `UNUserNotificationCenter`.
- **Notes** — jot a note from within the app; each entry is saved with an
  automatic date/time stamp and kept in a running, most-recent-first log.

## Requirements

Building and running an iOS app requires **macOS with Xcode** (14.0+, targeting
iOS 16.0+). This project was authored on Windows and cannot be compiled or
simulated here — open it on a Mac to build/run.

## Getting started

1. Copy this `ReminderNotesApp` folder to a Mac.
2. Open `ReminderNotesApp.xcodeproj` in Xcode.
3. Select your Apple ID under Signing & Capabilities (Automatic signing is
   already configured) if you want to run on a physical device. The Simulator
   needs no signing.
4. Build & run (⌘R) on a simulator or device running iOS 16+.
5. On first launch the app requests notification permission — accept it so
   reminders can fire. If you decline, the Reminders tab shows a prompt to
   enable notifications in Settings.

## Project layout

```
ReminderNotesApp/
  ReminderNotesAppApp.swift      App entry point, requests notification auth
  ContentView.swift              Tab bar (Reminders / Notes)
  Models/
    ReminderTime.swift           Codable model for a scheduled reminder
    NoteEntry.swift               Codable model for a timestamped note
  Managers/
    NotificationManager.swift    Schedules/cancels UNUserNotificationCenter requests
    ReminderStore.swift          Persists reminders (UserDefaults/JSON), drives scheduling
    NoteStore.swift              Persists notes (UserDefaults/JSON)
  Views/
    RemindersListView.swift      List, enable/disable, delete reminders
    AddEditReminderView.swift    Time picker + custom message editor
    NotesListView.swift          Timestamped note log
    AddNoteView.swift            Note entry form
```

## Notes on persistence

Reminders and notes are stored locally as JSON in `UserDefaults` — no backend
or database required. Swapping in SwiftData/Core Data later would only mean
replacing the internals of `ReminderStore`/`NoteStore`; the views and models
wouldn't need to change.

## Customizing

- **Bundle identifier**: currently `com.athomas.RemindersNotes` — change it in
  the target's Build Settings (or General tab) before shipping to your own
  Apple Developer account.
- **App icon**: `Assets.xcassets/AppIcon.appiconset` is set up for a single
  1024×1024 image — drop yours in via Xcode's asset editor.
