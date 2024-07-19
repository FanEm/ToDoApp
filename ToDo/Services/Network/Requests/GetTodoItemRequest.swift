//
//  GetTodoItemRequest.swift
//  ToDo
//
//  Created by Artem Novikov on 15.07.2024.
//

import Foundation

// MARK: - GetTodoItemRequest
struct GetTodoItemRequest: NetworkRequest {

    let httpMethod: HttpMethod = .get

    var endpoint: URL? {
        Endpoint.todoById(id: id).url
    }

    private let id: String

    init(id: String) {
        self.id = id
    }

}
