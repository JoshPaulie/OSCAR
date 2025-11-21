import SwiftUI

struct PlayerCountMenuLabel: View {
    @EnvironmentObject private var model: PlayerCountModel

    var body: some View {
        HStack(spacing: 4) {
            if model.isLoading {
                Image(systemName: "hourglass")
                Text("OSCAR")
            } else if let count = model.count {
                Image(systemName: "person.2.fill")
                Text(model.formatPlayerCount(count))
            } else if model.isOffline {
                Image(systemName: "xmark.circle")
                Text("Offline")
            } else {
                Image(systemName: "exclamationmark.arrow.trianglehead.2.clockwise.rotate.90")
                Text("OSCAR")
            }
        }
    }
}
