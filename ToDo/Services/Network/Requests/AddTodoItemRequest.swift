//
//  AddTodoItemRequest.swift
//  ToDo
//
//  Created by Artem Novikov on 15.07.2024.
//

import Foundation

// MARK: - AddTodoItemRequest
struct AddTodoItemRequest: NetworkRequest {

    let endpoint: URL? = Endpoint.list.url
    let httpMethod: HttpMethod = .post
    let headers: [String: String]
    let dto: EncodableAndSendable?

    init(dto: TodoItemElementRequestModel) {
        self.dto = dto
        self.headers = [
            "X-Last-Known-Revision": "\(StorageService.shared.revision)"
        ]
    }

}
