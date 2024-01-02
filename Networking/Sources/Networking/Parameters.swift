//
//  File.swift
//  
//
//  Created by Tung Nguyen on 03/01/2024.
//

import Foundation

public enum Parameters {
    case json(Data)
    case query([String: String])
    case plain
}
