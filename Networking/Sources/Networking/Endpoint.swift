//
//  File.swift
//  
//
//  Created by Tung Nguyen on 03/01/2024.
//

import Foundation

public protocol Endpoint {
    var baseURL: URL { get }
    var path: String { get }
    var headers: [String: String] { get }
    var method: HTTPMethod { get }
    var parameters: Parameters { get }
}

extension URLRequest {

    init(endpoint: Endpoint) {
        var url = endpoint.baseURL
        var headers = endpoint.headers
        var body: Data?
        
        switch endpoint.parameters {
        case .json(let data):
            headers["Content-Type"] = "application/json"
            body = data
        case .query(let params):
            var urlComponents = URLComponents(url: endpoint.baseURL, resolvingAgainstBaseURL: false)
            let queryItems = urlComponents?.queryItems ?? [URLQueryItem]()
            let encodedQueryItems = params.map { URLQueryItem(name: $0.key, value: $0.value) }
            urlComponents?.queryItems = queryItems + encodedQueryItems
            url = urlComponents?.url ?? url
        case .plain:
            ()
        }
        self.init(url: url)
        httpMethod = endpoint.method.rawValue
        httpBody = body
        headers.forEach { setValue($0.value, forHTTPHeaderField: $0.key) }
    }
}
