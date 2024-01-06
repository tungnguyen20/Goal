//
//  UIImageViewExtensions.swift
//  Goal
//
//  Created by Tung Nguyen on 04/01/2024.
//

import UIKit
import Combine

extension UIImageView {
    func load(url: URL) -> AnyCancellable? {
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .compactMap { UIImage(data: $0) }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error: \(error)")
                }
            }, receiveValue: { [weak self] image in
                self?.image = image
            })
    }
    
    func load(link: String) -> AnyCancellable? {
        guard let url = URL(string: link) else {
            return nil
        }
        return load(url: url)
    }
}
