import SwiftUI

struct PlayerCountView: View {
    @EnvironmentObject private var model: PlayerCountModel

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let count = model.count {
                Text("Players Online: \(model.formatPlayerCountExact(count))")
                    .font(.headline)
                    .foregroundStyle(.green)
            } else if model.isOffline {
                Text("Game Worlds Offline")
                    .foregroundStyle(.orange)
            } else {
                Text("Unable to fetch")
                    .foregroundStyle(.red)
            }

            if let date = model.lastUpdated {
                Text("Updated: \(date.formatted(date: .omitted, time: .shortened))")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Button("Refresh Now") {
                Task { await model.refresh() }
            }

            Divider()

            Button("Quit") {
                NSApplication.shared.terminate(nil)
            }
        }
    }
}
