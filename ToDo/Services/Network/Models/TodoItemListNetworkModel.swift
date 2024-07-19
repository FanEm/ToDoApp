//
//  TodoItemListNetworkModel.swift
//  ToDo
//
//  Created by Artem Novikov on 15.07.2024.
//

import Foundation

// MARK: - TodoItemListResponseModel
struct TodoItemListResponseModel: Codable, Revisionable {
    let status: String
    let list: [TodoItemNetworkModel]
    let revision: Int
}

// MARK: - TodoItemListRequestModel
struct TodoItemListRequestModel: Codable {
    let list: [TodoItemNetworkModel]
}
