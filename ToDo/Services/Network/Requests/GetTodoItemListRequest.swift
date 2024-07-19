//
//  GetTodoItemListRequest.swift
//  ToDo
//
//  Created by Artem Novikov on 15.07.2024.
//

import Foundation

// MARK: - GetTodoItemListRequest
struct GetTodoItemListRequest: NetworkRequest {

    let endpoint: URL? = Endpoint.list.url
    let httpMethod: HttpMethod = .get

}
