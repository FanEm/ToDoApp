//
//  TodoItemNetworkModel.swift
//  ToDo
//
//  Created by Artem Novikov on 15.07.2024.
//

import Foundation

// MARK: - TodoItemNetworkModel
struct TodoItemNetworkModel: Codable {

    let id: String
    let text: String
    let importance: String
    let deadline: Int?
    let isDone: Bool
    let color: String?
    let createdAt: Int
    let modifiedAt: Int
    let lastUpdatedBy: String

    enum CodingKeys: String, CodingKey {
        case id, text, importance, deadline, color
        case isDone = "done"
        case createdAt = "created_at"
        case modifiedAt = "changed_at"
        case lastUpdatedBy = "last_updated_by"
    }

}

extension TodoItemNetworkModel {

    var toModel: TodoItem {
        TodoItem(
            id: id,
            text: text,
            importance: Importance(rawValue: importance) ?? .basic,
            deadline: deadline == nil ? nil : Date(timeIntervalSince1970: Double(deadline!)),
            isDone: isDone,
            createdAt: Date(timeIntervalSince1970: Double(createdAt)),
            modifiedAt: Date(timeIntervalSince1970: Double(modifiedAt)),
            color: color,
            category: nil
        )
    }

}
