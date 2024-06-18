//
//  FileCache.swift
//  ToDo
//
//  Created by Artem Novikov on 15.06.2024.
//

import Foundation

// MARK: - FileCache
final class FileCache {

    private let fileManager: FileManager

    private(set) var items: [String: TodoItem] = [:]

    init(fileManager: FileManager = FileManager.default) {
        self.fileManager = fileManager
    }

    func addItem(_ item: TodoItem) {
        items[item.id] = item
    }

    func removeItem(id: String) {
        items.removeValue(forKey: id)
    }

    func removeAllItems() {
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

    func saveJson(to file: String) throws {
        let jsonArray = items.values.map { $0.json }
        let jsonData = try JSONSerialization.data(withJSONObject: jsonArray, options: .prettyPrinted)
        try jsonData.write(to: filePath(file))
    }

    func loadJson(from file: String) throws {
        let data = try Data(contentsOf: filePath(file))
        let json = try JSONSerialization.jsonObject(with: data)
        guard let json = json as? [Any] else {
            throw FileCacheError.parseError
        }
        let itemsList = json.compactMap { TodoItem.parse(json: $0) }
        items = itemsList.reduce(into: [:], { result, item in
            result[item.id] = item
        })
    }

}

// MARK: - CSV serialization
extension FileCache {

    func saveCSV(to file: String) throws {
        let csvString: String = "\(TodoItem.csvHeader.joined(separator: ","))\n" 
                                + items.values.map({ $0.csv }).joined(separator: "\n")
        guard let csvData = csvString.data(using: .utf8) else {
            throw FileCacheError.encodingError
        }
        try csvData.write(to: filePath(file))
    }

    func loadCSV(from file: String) throws {
        let content = try String(contentsOf: filePath(file), encoding: .utf8)
        let rows = content.split(separator: "\n").map { String($0) }.dropFirst()
        let itemsList = rows.compactMap { TodoItem.parse(csv: $0) }
        items = itemsList.reduce(into: [:], { result, item in
            result[item.id] = item
        })
    }

}

// MARK: - FileCacheError
extension FileCache {

    enum FileCacheError: LocalizedError {
        case parseError, encodingError

        var errorDescription: String? {
            switch self {
            case .parseError: "Parsing failed"
            case .encodingError: "String encoding error"
            }
        }
    }

}
