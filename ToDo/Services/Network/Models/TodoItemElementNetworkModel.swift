//
//  TodoItemElementNetworkModel.swift
//  ToDo
//
//  Created by Artem Novikov on 15.07.2024.
//

import Foundation

// MARK: - TodoItemElementResponseModel
struct TodoItemElementResponseModel: Codable, Revisionable {
    let status: String
    let element: TodoItemNetworkModel
    let revision: Int
}

// MARK: - TodoItemElementRequestModel
struct TodoItemElementRequestModel: Codable {
    let element: TodoItemNetworkModel
}
