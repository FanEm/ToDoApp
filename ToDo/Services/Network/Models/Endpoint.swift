//
//  Endpoint.swift
//  ToDo
//
//  Created by Artem Novikov on 15.07.2024.
//

import Foundation

// MARK: - Endpoint
enum Endpoint {

    case list
    case todoById(id: String)

    static let baseURL: URL? = URL(string: "https://hive.mrdekk.ru/")

    var path: String {
        switch self {
        case .list: "todo/list"
        case .todoById(let id): "todo/list/\(id)"
        }
    }

    var url: URL? {
        switch self {
        case .list: URL(string: Endpoint.list.path, relativeTo: Endpoint.baseURL)
        case .todoById(let id): URL(string: Endpoint.todoById(id: id).path, relativeTo: Endpoint.baseURL)
        }
    }

}
