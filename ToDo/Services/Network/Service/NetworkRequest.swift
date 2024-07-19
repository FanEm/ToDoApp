//
//  NetworkRequest.swift
//  ToDo
//
//  Created by Artem Novikov on 15.07.2024.
//

import Foundation

// MARK: - HttpMethod
enum HttpMethod: String {
    case delete, get, patch, post, put

    var name: String {
        rawValue.uppercased()
    }
}

typealias EncodableAndSendable = Encodable & Sendable

// MARK: - NetworkRequest
protocol NetworkRequest: Sendable {
    var endpoint: URL? { get }
    var httpMethod: HttpMethod { get }
    var dto: EncodableAndSendable? { get }
    var token: String { get }
    var headers: [String: String] { get }
}

// MARK: - NetworkRequest. Defaults
extension NetworkRequest {
    var httpMethod: HttpMethod { .get }
    var dto: EncodableAndSendable? { nil }
    var token: String { "Seregon" } // Nasty
    var headers: [String: String] { [:] }
}
