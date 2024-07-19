//
//  EditTodoItemRequest.swift
//  ToDo
//
//  Created by Artem Novikov on 15.07.2024.
//

import Foundation

// MARK: - EditTodoItemRequest
struct EditTodoItemRequest: NetworkRequest {

    let httpMethod: HttpMethod = .put
    let dto: EncodableAndSendable?
    let headers: [String: String]
    var endpoint: URL? {
        Endpoint.todoById(id: id).url
    }

    private let id: String

    init(id: String, dto: TodoItemElementRequestModel) {
        self.id = id
        self.dto = dto
        self.headers = [
            "X-Last-Known-Revision": "\(StorageService.shared.revision)"
        ]
    }

}
