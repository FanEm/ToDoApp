//
//  Category+CSV.swift
//  ToDo
//
//  Created by Artem Novikov on 03.07.2024.
//

import Foundation
import FileCache

// MARK: - Parse CSV
extension Category: FileCachableCsv {

    var csv: String {
        "\(id),\(text),\(color == nil ? " " : color!),\(String(createdAt.timeIntervalSince1970))"
    }

    static var csvHeader: [String] {
        [Keys.id, Keys.text, Keys.color, Keys.createdAt].map { $0.rawValue}
    }

    static func parse(csv: String) -> Category? {
        let row = csv.split(separator: ",").map { String($0) }

        var dict = [String: String]()
        for (index, value) in row.enumerated() {
            dict[csvHeader[index]] = value
        }

        guard let id = dict[Keys.id.rawValue],
              let text = dict[Keys.text.rawValue],
              let color = dict[Keys.color.rawValue],
              let createdAtString = dict[Keys.createdAt.rawValue],
              let createdAtTimeInterval = TimeInterval(createdAtString)
        else {
            return nil
        }
        let createdAt = Date(timeIntervalSince1970: createdAtTimeInterval)
        return Category(id: id, text: text, color: color, createdAt: createdAt)
    }

}
