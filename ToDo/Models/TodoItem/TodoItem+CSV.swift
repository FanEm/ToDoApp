//
//  TodoItem+CSV.swift
//  ToDo
//
//  Created by Artem Novikov on 28.06.2024.
//

import Foundation
import FileCache

// MARK: - Parse CSV
extension TodoItem: FileCachableCsv {

    var csv: String {
        "\(id),\(text),\(importance == .basic ? " " : importance.rawValue)," +
        "\(deadline == nil ? " " : String(deadline!.timeIntervalSince1970))," +
        "\(String(isDone)),\(String(createdAt.timeIntervalSince1970))," +
        "\(modifiedAt == nil ? " " : String(modifiedAt!.timeIntervalSince1970))," +
        "\(color == nil ? " " : color!),\(category == nil ? " " : category!.id)"
    }

    static var csvHeader: [String] {
        [
            Keys.id, Keys.text, Keys.importance, Keys.deadline, Keys.isDone,
            Keys.createdAt, Keys.modifiedAt, Keys.color, Keys.category
        ].map { $0.rawValue }
    }

    static func parse(csv: String) -> TodoItem? {
        let row = csv.split(separator: ",").map { String($0) }

        var dict = [String: String]()
        for (index, value) in row.enumerated() {
            dict[csvHeader[index]] = value
        }

        guard let id = dict[Keys.id.rawValue],
              let text = dict[Keys.text.rawValue],
              let isDoneString = dict[Keys.isDone.rawValue],
              let isDone = Bool(isDoneString),
              let createdAtString = dict[Keys.createdAt.rawValue],
              let createdAtTimeInterval = TimeInterval(createdAtString)
        else {
            return nil
        }

        let createdAt = Date(timeIntervalSince1970: createdAtTimeInterval)
        let importance = Importance(rawValue: dict[Keys.importance.rawValue] ?? "") ?? .basic
        let deadline = TimeInterval(dict[Keys.deadline.rawValue] ?? "")
                            .flatMap { Date(timeIntervalSince1970: $0) }
        let modifiedAt = TimeInterval(dict[Keys.modifiedAt.rawValue] ?? "")
                            .flatMap { Date(timeIntervalSince1970: $0) }
        let color = dict[Keys.color.rawValue] == " " ? nil : dict[Keys.color.rawValue]
        let categoryId = dict[Keys.category.rawValue] == " " ? nil : dict[Keys.category.rawValue]

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
