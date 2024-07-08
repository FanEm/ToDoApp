import SwiftUI

public protocol StringIdentifiable: Identifiable where ID == String {}

public protocol FileCachableJson {
    var json: Any { get }
    static func parse(json: Any) -> Self?
}

public protocol FileCachableCsv {
    var csv: String { get }
    static var csvHeader: [String] { get }
    static func parse(csv: String) -> Self?
}

public typealias FileCachable = StringIdentifiable & FileCachableJson & FileCachableCsv

// MARK: - FileCache
open class FileCache<T: FileCachable>: ObservableObject {

    @Published public private(set) var items: [String: T] = [:]
    private let fileManager: FileManager = FileManager.default
    private let defaultFileName: String

    public init(defaultFileName: String) {
        self.defaultFileName = defaultFileName
    }

    public func addItemAndSaveJson(_ item: T) {
        addItem(item)
        try? saveJson()
    }

    public func removeItemAndSaveJson(id: String) {
        removeItem(id: id)
        try? saveJson()
    }

    public func addItem(_ item: T) {
        items[item.id] = item
    }

    @discardableResult
    public func removeItem(id: String) -> T? {
        items.removeValue(forKey: id)
    }

    public func removeAllItems() {
        items = [:]
    }

    private func filePath(_ file: String) -> URL {
        fileManager
            .urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appending(path: file, directoryHint: .notDirectory)
    }

}

// MARK: - JSON serialization
extension FileCache {

    public func saveJson(to file: String? = nil) throws {
        let fileName = file ?? defaultFileName
        let jsonArray = items.values.map { $0.json }
        let jsonData = try JSONSerialization.data(withJSONObject: jsonArray, options: .prettyPrinted)
        try jsonData.write(to: filePath(fileName))
    }

    public func loadJson(from file: String? = nil) throws {
        let fileName = file ?? defaultFileName
        let data = try Data(contentsOf: filePath(fileName))
        let json = try JSONSerialization.jsonObject(with: data)
        guard let json = json as? [Any] else {
            throw FileCacheError.parseError
        }
        let itemsList = json.compactMap { T.parse(json: $0) }
        items = itemsList.reduce(into: [:], { result, item in
            result[item.id] = item
        })
    }

}

// MARK: - CSV serialization
extension FileCache {

    public func saveCSV(to file: String) throws {
        let csvString: String = "\(T.csvHeader.joined(separator: ","))\n"
                                + items.values.map({ $0.csv }).joined(separator: "\n")
        guard let csvData = csvString.data(using: .utf8) else {
            throw FileCacheError.encodingError
        }
        try csvData.write(to: filePath(file))
    }

    public func loadCSV(from file: String) throws {
        let content = try String(contentsOf: filePath(file), encoding: .utf8)
        let rows = content.split(separator: "\n").map { String($0) }.dropFirst()
        let itemsList = rows.compactMap { T.parse(csv: $0) }
        items = itemsList.reduce(into: [:], { result, item in
            result[item.id] = item
        })
    }

}

// MARK: - FileCacheError
extension FileCache {

    public enum FileCacheError: LocalizedError {
        case parseError, encodingError

        public var errorDescription: String? {
            switch self {
            case .parseError: "Parsing failed"
            case .encodingError: "String encoding error"
            }
        }
    }

}
