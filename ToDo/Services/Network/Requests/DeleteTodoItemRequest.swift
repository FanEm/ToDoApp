//
//  DeleteTodoItemRequest.swift
//  ToDo
//
//  Created by Artem Novikov on 15.07.2024.
//

import Foundation

// MARK: - DeleteTodoItemRequest
struct DeleteTodoItemRequest: NetworkRequest {

    let httpMethod: HttpMethod = .delete
    let headers: [String: String]
    var endpoint: URL? {
        Endpoint.todoById(id: id).url
    }

    private let id: String

    init(id: String) {
        self.id = id
        self.headers = [
            "X-Last-Known-Revision": "\(StorageService.shared.revision)"
        ]
    }

}
