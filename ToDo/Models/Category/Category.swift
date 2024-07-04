//
//  Category.swift
//  ToDo
//
//  Created by Artem Novikov on 03.07.2024.
//

import Foundation

// MARK: - Category
struct Category: StringIdentifiable {

    let id: String
    let text: String
    let color: String?
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

    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id &&
        lhs.text == rhs.text &&
        lhs.color == rhs.color &&
        lhs.createdAt == rhs.createdAt
    }

}
