//
//  Category.swift
//  ToDo
//
//  Created by Artem Novikov on 03.07.2024.
//

import Foundation
import FileCache
import SwiftData

// MARK: - Category
@Model
final class Category: StringIdentifiable {

    @Attribute(.unique) let id: String
    var text: String
    var color: String?
    let createdAt: Date

    init(id: String = UUID().uuidString, text: String = "", color: String? = nil, createdAt: Date = .now) {
        self.id = id
        self.text = text
        self.color = color
        self.createdAt = createdAt
    }

    enum Keys: String {
        case id, text, color, createdAt
    }

}

// MARK: - Equatable
extension Category: Equatable {

    static func == (lhs: Category, rhs: Category) -> Bool {
        lhs.id == rhs.id &&
        lhs.text == rhs.text &&
        lhs.color == rhs.color &&
        lhs.createdAt == rhs.createdAt
    }

}
