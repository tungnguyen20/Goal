//
//  MatchesViewController.swift
//  Goal
//
//  Created by Tung Nguyen on 02/01/2024.
//

import UIKit
import Combine
import AVFoundation
import AVKit

class MatchesViewController: UIViewController {
    
    lazy var collectionView: UICollectionView = {
        var configuration = UICollectionLayoutListConfiguration(appearance: .grouped)
        configuration.showsSeparators = false
        configuration.headerMode = .supplementary
        configuration.backgroundColor = .background1
        
        let layout = UICollectionViewCompositionalLayout.list(
            using: configuration
        )
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        collectionView.backgroundView = nil
        collectionView.backgroundColor = .background1
        collectionView.bounces = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    lazy var headerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var logoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .title
        label.textColor = .white
        label.text = "GOAL"
        return label
    }()
    
    let matchCellReuseIdentifier = "MatchCell"
    
    private lazy var dataSource = createDataSource()
    private var subscriptions = Set<AnyCancellable>()
    var viewModel: MatchesViewModel
    
    init(viewModel: MatchesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(true, animated: true)
        addSubviews()
        bindViewModel()
    }
    
    func addSubviews() {
        view.backgroundColor = .background1
        view.addSubviews([
            headerView,
            collectionView
        ])
        NSLayoutConstraint.activate([
            headerView.heightAnchor.constraint(equalToConstant: 48),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            collectionView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor)
        ])
        
        headerView.addSubviews([
            logoLabel
        ])
        NSLayoutConstraint.activate([
            logoLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            logoLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor)
        ])
        
        collectionView.register(MatchCell.self, forCellWithReuseIdentifier: matchCellReuseIdentifier)
        collectionView.register(MatchesSectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "Header")
    }
    
    func bindViewModel() {
        viewModel.$matchList
            .sink { [weak self] matches in
                var snapshot = NSDiffableDataSourceSnapshot<Section, MatchItem>()
                snapshot.appendSections(Section.allCases)
                
                snapshot.appendItems(matches.previous, toSection: .previous)
                snapshot.appendItems(matches.upcoming, toSection: .upcoming)
                
                self?.dataSource.apply(snapshot, animatingDifferences: true)
            }
            .store(in: &subscriptions)
    }
    
}

extension MatchesViewController {
    
    func createDataSource() -> UICollectionViewDiffableDataSource<Section, MatchItem> {
        let dataSource = UICollectionViewDiffableDataSource<Section, MatchItem>(collectionView: collectionView) { collectionView, indexPath, item in
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: self.matchCellReuseIdentifier,
                for: indexPath
            ) as! MatchCell
            cell.configure(item: item, isPrevious: indexPath.section == Section.previous.rawValue)
            cell.selectHomeTeam
                .sink(receiveValue: { [weak self] _ in
                    self?.viewModel.route.send(.openTeam(team: item.home))
                })
                .store(in: &cell.subscriptions)
            cell.selectAwayTeam
                .sink(receiveValue: { [weak self] _ in
                    self?.viewModel.route.send(.openTeam(team: item.away))
                })
                .store(in: &cell.subscriptions)
            cell.selectHighlight
                .sink(receiveValue: { [weak self] _ in
                    guard let highlights = item.match.highlights, let url = URL(string: highlights) else {
                        return
                    }
                    self?.playVideo(url: url)
                })
                .store(in: &cell.subscriptions)
            return cell
        }
        
        dataSource.supplementaryViewProvider = { (collectionView, kind, indexPath) in
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Header", for: indexPath) as? MatchesSectionHeader else {
                fatalError("Could not dequeue section header")
            }
            header.configure(title: Section(rawValue: indexPath.section)?.title)
            return header
        }
        
        return dataSource
    }
    
}

extension MatchesViewController: AVPlayerViewControllerDelegate {
    
    func playVideo(url: URL) {
        let item = AVPlayerItem(url: url)
        let player = AVQueuePlayer(playerItem: item)
        player.actionAtItemEnd = .pause
        let controller = AVPlayerViewController()
        controller.delegate = self
        controller.player = player
        present(controller, animated: true) {
            player.play()
        }
    }
    
}

extension MatchesViewController {
    
    enum Section: Int, CaseIterable {
        case upcoming = 0
        case previous = 1
        
        var title: String {
            switch self {
            case .upcoming:
                return "Upcoming matches"
            case .previous:
                return "Previous matches"
            }
        }
    }
    
}
