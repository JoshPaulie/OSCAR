import Foundation
import Combine

@MainActor
final class PlayerCountModel: ObservableObject {
    @Published var count: Int?
    @Published var isLoading: Bool = false
    @Published var lastUpdated: Date?
    @Published var isOffline: Bool = false
    
    private let service = PlayerCountService()
    private var timer: Timer?
    
    init() {
        Task { await refresh() }
        startTimer()
    }
    
    func formatPlayerCount(_ count: Int) -> String {
        if count < 10000 {
            return String(count)
        }
        
        let thousands = Double(count) / 1000.0
        return String(format: "%.1fK", thousands)
    }
    
    func formatPlayerCountExact(_ count: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: count)) ?? String(count)
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 300, repeats: true) { _ in
            Task { await self.refresh() }
        }
    }
    
    func refresh() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let result = try await service.fetchPlayerCount()
            count = result
            isOffline = false
            lastUpdated = Date()
        } catch PlayerCountError.gameOffline {
            count = nil
            isOffline = true
        } catch {
            count = nil
            isOffline = false
        }
    }
}
