import SwiftUI

@main
struct OSCARApp: App {
    @StateObject private var playerCountModel = PlayerCountModel()

    var body: some Scene {
        MenuBarExtra {
            PlayerCountView()
                .environmentObject(playerCountModel)
                .frame(width: 200)
                .padding()
        } label: {
            PlayerCountMenuLabel()
                .environmentObject(playerCountModel)
        }
    }
}
