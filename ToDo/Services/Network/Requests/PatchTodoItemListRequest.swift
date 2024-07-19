//
//  PatchTodoItemListRequest.swift
//  ToDo
//
//  Created by Artem Novikov on 15.07.2024.
//

import Foundation

// MARK: - PatchTodoItemListRequest
struct PatchTodoItemListRequest: NetworkRequest {

    let endpoint: URL? = Endpoint.list.url
    let httpMethod: HttpMethod = .patch
    let dto: EncodableAndSendable?
    let headers: [String: String]

    init(dto: TodoItemListRequestModel) {
        self.dto = dto
        self.headers = [
            "X-Last-Known-Revision": "\(StorageService.shared.revision)"
        ]
    }

}
