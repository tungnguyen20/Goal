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
    
    lazy var widescreenLayout: UICollectionViewCompositionalLayout = {
        return UICollectionViewCompositionalLayout { (sectionIndex: Int,
                                                      layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
            item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
            let group = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.6),
                    heightDimension: .estimated(Section(rawValue: sectionIndex) == .upcoming ? 200 : 240)
                ),
                subitem: item,
                count: 1
            )
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
            section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(40))
            let header = NSCollectionLayoutBoundarySupplementaryItem(
                            layoutSize: headerSize,
                            elementKind: UICollectionView.elementKindSectionHeader,
                            alignment: .top)
            section.boundarySupplementaryItems = [header]
            return section
        }
    }()
    
    lazy var compactWidthScreenLayout: UICollectionViewCompositionalLayout = {
        var configuration = UICollectionLayoutListConfiguration(appearance: .grouped)
        configuration.showsSeparators = false
        configuration.headerMode = .supplementary
        configuration.backgroundColor = .background1
        
        return UICollectionViewCompositionalLayout.list(
            using: configuration
        )
    }()
    
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
    
    lazy var filterButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        button.setImage(UIImage(systemName: "line.3.horizontal.decrease.circle"), for: .normal)
        return button
    }()
    
    lazy var badgeView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .primary
        view.cornerRadius = 4
        view.isUserInteractionEnabled = true
        return view
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
        viewModel.getAllMatches()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        if UIDevice.current.orientation.isLandscape {
            collectionView.setCollectionViewLayout(widescreenLayout, animated: true)
        } else {
            collectionView.setCollectionViewLayout(compactWidthScreenLayout, animated: true)
        }
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
            logoLabel,
            filterButton,
            badgeView
        ])
        NSLayoutConstraint.activate([
            logoLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            logoLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            filterButton.heightAnchor.constraint(equalToConstant: 40),
            filterButton.widthAnchor.constraint(equalToConstant: 40),
            filterButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            filterButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            badgeView.heightAnchor.constraint(equalToConstant: 8),
            badgeView.widthAnchor.constraint(equalToConstant: 8),
            badgeView.centerXAnchor.constraint(equalTo: filterButton.centerXAnchor, constant: 4),
            badgeView.centerYAnchor.constraint(equalTo: filterButton.centerYAnchor, constant: 4),
        ])
        
        badgeView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openFilter)))
        filterButton.addTarget(self, action: #selector(openFilter), for: .touchUpInside)
        collectionView.register(MatchCell.self, forCellWithReuseIdentifier: matchCellReuseIdentifier)
        collectionView.register(MatchesSectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "Header")
    }
    
    func bindViewModel() {
        Publishers.CombineLatest(viewModel.$upcomingMatches, viewModel.$previousMatches)
            .sink { [weak self] upcoming, previous in
                var snapshot = NSDiffableDataSourceSnapshot<Section, MatchItemViewModel>()
                snapshot.appendSections(Section.allCases)
                snapshot.appendItems(upcoming, toSection: .upcoming)
                snapshot.appendItems(previous, toSection: .previous)
                self?.dataSource.apply(snapshot, animatingDifferences: true)
            }
            .store(in: &subscriptions)
        
        viewModel.$filteringTeams
            .map { $0.isEmpty }
            .sink { [weak self] isEmpty in
                self?.badgeView.isHidden = isEmpty
            }
            .store(in: &subscriptions)
    }
    
    @objc func openFilter() {
        viewModel.route.send(.filter(teams: viewModel.filteringTeams))
    }
    
}

extension MatchesViewController {
    
    func createDataSource() -> UICollectionViewDiffableDataSource<Section, MatchItemViewModel> {
        let dataSource = UICollectionViewDiffableDataSource<Section, MatchItemViewModel>(collectionView: collectionView) { collectionView, indexPath, item in
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: self.matchCellReuseIdentifier,
                for: indexPath
            ) as! MatchCell
            cell.configure(viewModel: item)
            cell.selectHomeTeam
                .sink(receiveValue: { [weak self] _ in
                    self?.viewModel.route.send(.openTeam(team: item.matchItem.home))
                })
                .store(in: &cell.subscriptions)
            cell.selectAwayTeam
                .sink(receiveValue: { [weak self] _ in
                    self?.viewModel.route.send(.openTeam(team: item.matchItem.away))
                })
                .store(in: &cell.subscriptions)
            cell.selectHighlight
                .sink(receiveValue: { [weak self] _ in
                    guard let highlights = item.highlights, let url = URL(string: highlights) else {
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
