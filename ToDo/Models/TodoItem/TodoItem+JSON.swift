//
//  TodoItem+JSON.swift
//  ToDo
//
//  Created by Artem Novikov on 28.06.2024.
//

import Foundation
import FileCache

// MARK: - Parse JSON
extension TodoItem: FileCachableJson {

    var json: Any {
        var dict: [String: Any] = [
            Keys.id.rawValue: id,
            Keys.text.rawValue: text,
            Keys.createdAt.rawValue: createdAt.timeIntervalSince1970,
            Keys.isDone.rawValue: isDone
        ]

        if importance != .basic {
            dict[Keys.importance.rawValue] = importance.rawValue
        }

        if let deadline {
            dict[Keys.deadline.rawValue] = deadline.timeIntervalSince1970
        }

        if let color {
            dict[Keys.color.rawValue] = color
        }

        if let category {
            dict[Keys.category.rawValue] = category.id
        }

        if let modifiedAt {
            dict[Keys.modifiedAt.rawValue] = modifiedAt.timeIntervalSince1970
        }

        return dict
    }

    static func parse(json: Any) -> TodoItem? {
        switch json {
        case let jsonString as String: parse(string: jsonString)
        case let jsonData as Data: parse(data: jsonData)
        case let jsonDict as [String: Any]: parse(dict: jsonDict)
        default: nil
        }
    }

    // MARK: - Private methods
    private static func parse(string: String) -> TodoItem? {
        guard let data = string.data(using: .utf8) else { return nil }
        return parse(data: data)
    }

    private static func parse(data: Data) -> TodoItem? {
        guard let dict = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else { return nil }
        return parse(dict: dict)
    }

    private static func parse(dict: [String: Any]) -> TodoItem? {
        guard
           let id = dict[Keys.id.rawValue] as? String,
           let text = dict[Keys.text.rawValue] as? String,
           let createdAtTimeInterval = dict[Keys.createdAt.rawValue] as? TimeInterval,
           let isDone = dict[Keys.isDone.rawValue] as? Bool
        else { return nil }

        let createdAt = Date(timeIntervalSince1970: createdAtTimeInterval)

        let importanceString = dict[Keys.importance.rawValue] as? String ?? ""
        let importance = Importance(rawValue: importanceString) ?? .basic

        let deadlineTimeInterval = dict[Keys.deadline.rawValue] as? TimeInterval
        let deadline = deadlineTimeInterval.flatMap { Date(timeIntervalSince1970: $0) }

        let modifiedAtTimeInterval = dict[Keys.modifiedAt.rawValue] as? TimeInterval
        let modifiedAt = modifiedAtTimeInterval.flatMap { Date(timeIntervalSince1970: $0) }

        let color = dict[Keys.color.rawValue] as? String
        let categoryId = dict[Keys.category.rawValue] as? String

        return TodoItem(
           id: id,
           text: text,
           importance: importance,
           deadline: deadline,
           isDone: isDone,
           createdAt: createdAt,
           modifiedAt: modifiedAt,
           color: color,
           category: categoryId == nil ? nil : Category(id: categoryId!)
        )
    }

}
