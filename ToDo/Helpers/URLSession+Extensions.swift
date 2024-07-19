//
//  URLSession+Extensions.swift
//  ToDo
//
//  Created by Artem Novikov on 08.07.2024.
//

import Foundation

final class URLSessionDataTaskManager: @unchecked Sendable {

    private var task: URLSessionDataTask?
    private var isCancelled: Bool = false
    private let queue = DispatchQueue(label: "syncQueue")

    func cancel() {
        queue.async {
            self.isCancelled = true
            self.task?.cancel()
        }
    }

    func set(_ dataTask: URLSessionDataTask) {
        queue.async {
            if self.isCancelled {
                dataTask.cancel()
            } else {
                self.task = dataTask
                dataTask.resume()
            }
        }
    }

}

extension URLSession {

    func dataTask(for urlRequest: URLRequest) async throws -> (Data, URLResponse) {
        let taskManager = URLSessionDataTaskManager()
        return try await withTaskCancellationHandler {
            try await withCheckedThrowingContinuation { continuation in
                assert(!Thread.isMainThread)
                let task = dataTask(with: urlRequest) { data, response, error in
                    assert(!Thread.isMainThread)
                    if let error {
                        if (error as NSError).code == NSURLErrorCancelled {
                            return continuation.resume(throwing: CancellationError())
                        }
                        return continuation.resume(throwing: error)
                    }
                    if let data, let response {
                        return continuation.resume(returning: (data, response))
                    }
                    continuation.resume(throwing: URLError(.unknown))
                }
                taskManager.set(task)
            }
        } onCancel: {
            taskManager.cancel()
        }
    }

}
