//
//  File.swift
//
//
//  Created by Tung Nguyen on 03/01/2024.
//

import Foundation
import Combine

open class ApiClient {
    private var session: URLSession
    
    public init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    public func request<E: Endpoint, T: Decodable>(_ endpoint: E) -> AnyPublisher<T, ApiError> {
        session.dataTaskPublisher(for: URLRequest(endpoint: endpoint))
            .tryMap({ result in
                guard let httpResponse = result.response as? HTTPURLResponse else {
                    throw ApiError.requestFailed
                }
                if (200..<300) ~= httpResponse.statusCode {
                    return result.data
                }
                throw ApiError.invalidResponse
            })
            .receive(on: RunLoop.main)
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError({ error -> ApiError in
                if let error = error as? ApiError {
                    return error
                }
                return ApiError.decodeFailed
            })
            .eraseToAnyPublisher()
    }
    
}
