import Foundation
import SwiftSoup

enum PlayerCountError: Error {
    case gameOffline
    case networkError(Error)
    case parseError(String)
}

struct PlayerCountService {
    func fetchPlayerCount() async throws -> Int {
        let html = try await fetchHomepageHTML()
        let text = try extractPlayerCountText(from: html)
        return try extractNumber(from: text)
    }

    private func fetchHomepageHTML() async throws -> String {
        let url = URL(string: "https://oldschool.runescape.com/")!
        let (data, _) = try await URLSession.shared.data(from: url)
        return String(decoding: data, as: UTF8.self)
    }

    private func extractPlayerCountText(from html: String) throws -> String {
        let doc = try SwiftSoup.parse(html)
        let elements = try doc.select("p.player-count")

        guard let element = elements.first() else {
            throw PlayerCountError.gameOffline
        }

        return try element.text()
    }

    private func extractNumber(from text: String) throws -> Int {
        let pattern = #"\d{1,3}(?:,\d{3})*"#
        let regex = try NSRegularExpression(pattern: pattern)

        let range = NSRange(text.startIndex..<text.endIndex, in: text)
        guard let match = regex.firstMatch(in: text, range: range) else {
            throw PlayerCountError.parseError("Unable to parse number in: \(text)")
        }

        let raw = (text as NSString).substring(with: match.range)
        let clean = raw.replacingOccurrences(of: ",", with: "")
        return Int(clean) ?? 0
    }
}
