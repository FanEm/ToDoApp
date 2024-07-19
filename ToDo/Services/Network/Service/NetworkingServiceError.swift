//
//  NetworkingServiceError.swift
//  ToDo
//
//  Created by Artem Novikov on 15.07.2024.
//

import Foundation

// MARK: - NetworkingServiceError
enum NetworkingServiceError: Error {
    case urlSessionError
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case parsingError
    case retryError
}

// MARK: - LocalizedError
extension NetworkingServiceError: LocalizedError {

    public var errorDescription: String? {
        let stringKey: String.LocalizationValue = switch self {
        case .httpStatusCode(let code):
            switch code {
            case 400: "network.error.code.400"
            case 401: "network.error.code.401"
            case 404: "network.error.code.404"
            case 400..<500: "network.error.code.4xx"
            case 500..<600: "network.error.code.5xx"
            default: "network.error.code.unknown"
            }
        case .urlRequestError(let error): "network.error.request.\(error.localizedDescription)"
        case .urlSessionError: "network.error.session"
        case .parsingError: "network.error.parsing"
        case .retryError: "network.error.retryError"
        }
        return String(localized: stringKey)
    }

}
