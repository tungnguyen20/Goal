//
//  File.swift
//  
//
//  Created by Tung Nguyen on 03/01/2024.
//

import Foundation

public enum ApiError: Error {
    case requestFailed
    case invalidResponse
    case decodeFailed
}
