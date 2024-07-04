//
//  Category+JSON.swift
//  ToDo
//
//  Created by Artem Novikov on 03.07.2024.
//

import Foundation

// MARK: - Parse JSON
extension Category: FileCachableJson {

    var json: Any {
        var dict: [String: Any] = [
            Keys.id.rawValue: id,
            Keys.text.rawValue: text,
            Keys.createdAt.rawValue: createdAt.timeIntervalSince1970
        ]

        if let color {
            dict[Keys.color.rawValue] = color
        }

        return dict
    }

    static func parse(json: Any) -> Category? {
        switch json {
        case let jsonString as String: parse(string: jsonString)
        case let jsonData as Data: parse(data: jsonData)
        case let jsonDict as [String: Any]: parse(dict: jsonDict)
        default: nil
        }
    }

    // MARK: - Private methods
    private static func parse(string: String) -> Category? {
        guard let data = string.data(using: .utf8) else { return nil }
        return parse(data: data)
    }

    private static func parse(data: Data) -> Category? {
        guard let dict = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else { return nil }
        return parse(dict: dict)
    }

    private static func parse(dict: [String: Any]) -> Category? {
        guard
           let id = dict[Keys.id.rawValue] as? String,
           let text = dict[Keys.text.rawValue] as? String,
           let color = dict[Keys.color.rawValue] as? String,
           let createdAtTimeInterval = dict[Keys.createdAt.rawValue] as? TimeInterval
        else { return nil }
        let createdAt = Date(timeIntervalSince1970: createdAtTimeInterval)
        return Category(id: id, text: text, color: color, createdAt: createdAt)
    }

}
