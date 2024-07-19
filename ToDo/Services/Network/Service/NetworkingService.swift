//
//  NetworkingService.swift
//  ToDo
//
//  Created by Artem Novikov on 15.07.2024.
//

import Foundation

// MARK: - NetworkingService
protocol NetworkingService: Sendable {
    func send(request: NetworkRequest) async throws -> Data
    func send<T: Decodable>(request: NetworkRequest, type: T.Type) async throws -> T
    func sendRequestWithRetry<T: Decodable>(
        request: NetworkRequest,
        type: T.Type,
        maxAttempts: Int,
        minDelay: TimeInterval,
        maxDelay: TimeInterval,
        factor: Double,
        jitter: Double
    ) async throws -> T
}

// MARK: - DefaultNetworkingService
struct DefaultNetworkingService: NetworkingService {

    private let session: URLSession
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder

    init(session: URLSession = URLSession.shared,
         decoder: JSONDecoder = JSONDecoder(),
         encoder: JSONEncoder = JSONEncoder()) {
        self.session = session
        self.decoder = decoder
        self.encoder = encoder
    }

    func send(request: NetworkRequest) async throws -> Data {
        guard let urlRequest = create(request: request) else {
            throw NetworkingServiceError.urlSessionError
        }

        let (data, response) = try await session.dataTask(for: urlRequest)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkingServiceError.urlSessionError
        }

        guard 200..<300 ~= httpResponse.statusCode else {
            throw NetworkingServiceError.httpStatusCode(httpResponse.statusCode)
        }

        return data
    }

    func send<T: Decodable>(request: NetworkRequest, type: T.Type) async throws -> T {
        let data = try await send(request: request)
        return try parse(data: data, type: type)
    }

    func sendRequestWithRetry<T: Decodable>(
        request: NetworkRequest,
        type: T.Type,
        maxAttempts: Int = 3,
        minDelay: TimeInterval = 2,
        maxDelay: TimeInterval = 120,
        factor: Double = 1.5,
        jitter: Double = 0.05
    ) async throws -> T {
        var currentAttempt = 0
        func calculateDelay(attempt: Int) -> TimeInterval {
            let baseDelay = minDelay * pow(factor, Double(attempt))
            let jitterValue = baseDelay * jitter * (Double.random(in: -1.0...1.0))
            return min(maxDelay, baseDelay + jitterValue)
        }

        while currentAttempt < maxAttempts {
            do {
                let data = try await send(request: request)
                return try parse(data: data, type: type)
            } catch {
                currentAttempt += 1
                if currentAttempt >= maxAttempts {
                    throw error
                }
                let delay = calculateDelay(attempt: currentAttempt)
                Logger.info("Attempt \(currentAttempt) failed. Retrying in \(delay) seconds...")
                try await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
            }
        }
        throw NetworkingServiceError.retryError
    }

    // MARK: - Private
    private func create(request: NetworkRequest) -> URLRequest? {
        guard let endpoint = request.endpoint else {
            assertionFailure("Empty endpoint")
            return nil
        }

        var urlRequest = URLRequest(url: endpoint)
        urlRequest.httpMethod = request.httpMethod.name
        urlRequest.setValue("Bearer \(request.token)", forHTTPHeaderField: "Authorization")

        for (header, value) in request.headers {
            urlRequest.setValue(value, forHTTPHeaderField: header)
        }

        if let dto = request.dto,
           let dtoEncoded = try? encoder.encode(dto) {
            assert(!Thread.isMainThread)
            Logger.verbose("\(String(data: dtoEncoded, encoding: .utf8) ?? "")")
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.httpBody = dtoEncoded
        }

        return urlRequest
    }

    private func parse<T: Decodable>(data: Data, type: T.Type) throws -> T {
        do {
            let parsedData = try decoder.decode(T.self, from: data)
            assert(!Thread.isMainThread)
            updateRevisionIfPossible(parsedData: parsedData)
            return parsedData
        } catch {
            throw NetworkingServiceError.parsingError
        }
    }

    private func updateRevisionIfPossible(parsedData: Decodable) {
        guard let revisionableData = parsedData as? Revisionable else { return }
        StorageService.shared.revision = max(StorageService.shared.revision, revisionableData.revision)
    }

}
