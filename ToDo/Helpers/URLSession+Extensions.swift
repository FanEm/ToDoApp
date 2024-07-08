//
//  URLSession+Extensions.swift
//  ToDo
//
//  Created by Artem Novikov on 08.07.2024.
//

import Foundation

extension URLSession {

    func dataTask(for urlRequest: URLRequest) async throws -> (Data, URLResponse) {
        var task: URLSessionDataTask?
        return try await withTaskCancellationHandler {
            try await withCheckedThrowingContinuation { continuation in
                task = dataTask(with: urlRequest) { data, response, error in
                    if Task.isCancelled {
                        continuation.resume(throwing: CancellationError())
                        return
                    }
                    if let error {
                        continuation.resume(throwing: error)
                        return
                    }
                    if let data, let response {
                        continuation.resume(returning: (data, response))
                        return
                    }
                    continuation.resume(throwing: URLError(.unknown))
                }
                if Task.isCancelled {
                    continuation.resume(throwing: CancellationError())
                    return
                }
                task?.resume()
            }
        } onCancel: { [weak task] in
            task?.cancel()
        }
    }

}
