import Foundation

final class Secrets {
    static let shared = Secrets()

    private var secrets: [String: Any] = [:]

    private init() {
        if let url = Bundle.main.url(forResource: "Secrets", withExtension: "plist"),
           let data = try? Data(contentsOf: url),
           let dict = try? PropertyListSerialization.propertyList(from: data, options: [], format: nil) as? [String: Any] {
            secrets = dict
        }
    }

    func apiKey(for key: String) -> String? {
        return secrets[key] as? String
    }
}

