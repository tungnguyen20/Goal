//
//  TeamDetailViewController.swift
//  Goal
//
//  Created by Tung Nguyen on 05/01/2024.
//

import UIKit
import Combine
import AVFoundation
import AVKit

class TeamDetailViewController: UIViewController {
    
    lazy var collectionView: UICollectionView = {
        var configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        configuration.showsSeparators = false
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
    
    lazy var backButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .primaryText
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        return button
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .h2
        label.textColor = .primaryText
        return label
    }()
    
    lazy var logoView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let matchCellReuseIdentifier = "MatchCell"
    
    private lazy var dataSource = createDataSource()
    private var subscriptions = Set<AnyCancellable>()
    var viewModel: TeamDetailViewModel
    
    init(viewModel: TeamDetailViewModel) {
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
            backButton,
            nameLabel,
            logoView,
            collectionView
        ])
        NSLayoutConstraint.activate([
            backButton.heightAnchor.constraint(equalToConstant: 40),
            backButton.widthAnchor.constraint(equalToConstant: 40),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            backButton.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 16),
            nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nameLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            logoView.heightAnchor.constraint(equalToConstant: 120),
            logoView.widthAnchor.constraint(equalToConstant: 120),
            logoView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 16),
            logoView.centerXAnchor.constraint(equalTo: nameLabel.centerXAnchor),
            collectionView.topAnchor.constraint(equalTo: logoView.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor)
        ])
        
        collectionView.register(TeamMatchCell.self, forCellWithReuseIdentifier: matchCellReuseIdentifier)
        backButton.addTarget(self, action: #selector(onTapBack), for: .touchUpInside)
    }
    
    func bindViewModel() {
        nameLabel.text = viewModel.team.name
        logoView.load(link: viewModel.team.logo)
        
        viewModel.$matchListObject
            .sink { [weak self] matches in
                var snapshot = NSDiffableDataSourceSnapshot<Section, MatchItem>()
                snapshot.appendSections(Section.allCases)
                
                snapshot.appendItems(matches.previous, toSection: .previous)
                snapshot.appendItems(matches.upcoming, toSection: .upcoming)
                
                self?.dataSource.apply(snapshot, animatingDifferences: true)
            }
            .store(in: &subscriptions)
    }
    
    @objc func onTapBack() {
        viewModel.didClose.send(())
    }
}

extension TeamDetailViewController {
    
    func createDataSource() -> UICollectionViewDiffableDataSource<Section, MatchItem> {
        return UICollectionViewDiffableDataSource(collectionView: collectionView) { collectionView, indexPath, item in
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: self.matchCellReuseIdentifier,
                for: indexPath
            ) as! TeamMatchCell
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
    }
    
}

extension TeamDetailViewController: AVPlayerViewControllerDelegate {
    
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

extension TeamDetailViewController {
    
    enum Section: Int, CaseIterable {
        case upcoming
        case previous
    }
    
}
