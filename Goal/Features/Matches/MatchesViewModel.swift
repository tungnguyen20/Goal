//
//  MatchesViewModel.swift
//  Goal
//
//  Created by Tung Nguyen on 03/01/2024.
//

import Foundation
import Combine

class MatchesViewModel {
    @Published var matchList: MatchListObject = .init(upcoming: [], previous: [])
    var route = PassthroughSubject<MatchesCoordinator.Route, Never>()
    let matchRepository: MatchRepositoryProtocol
    
    init(matchRepository: MatchRepositoryProtocol) {
        self.matchRepository = matchRepository
        
        matchRepository.getMatchList()
            .replaceError(with: .init(upcoming: [], previous: []))
            .assign(to: &self.$matchList)
    }
}
