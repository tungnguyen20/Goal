//
//  TeamsFilterViewController.swift
//  Goal
//
//  Created by Tung Nguyen on 08/01/2024.
//

import UIKit
import Combine

class TeamsFilterViewController: UIViewController {
    
    lazy var collectionView: UICollectionView = {
        var configuration = UICollectionLayoutListConfiguration(appearance: .grouped)
        configuration.showsSeparators = false
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
    
    lazy var backButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .primaryText
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        return button
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .h2
        label.textColor = .primaryText
        label.text = "FILTER"
        return label
    }()
    
    let teamFilterCellIdentifier = "TeamFilterCell"
    let viewModel: TeamsFilterViewModel
    private lazy var dataSource = createDataSource()
    var subscriptions = Set<AnyCancellable>()
    
    init(viewModel: TeamsFilterViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubviews()
        bindViewModel()
        viewModel.getAllTeams()
    }
    
    func addSubviews() {
        view.backgroundColor = .background1
        view.addSubviews([
            backButton,
            titleLabel,
            collectionView
        ])
        NSLayoutConstraint.activate([
            backButton.heightAnchor.constraint(equalToConstant: 40),
            backButton.widthAnchor.constraint(equalToConstant: 40),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            backButton.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 16),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor)
        ])
        
        collectionView.delegate = self
        collectionView.register(TeamFilterCell.self, forCellWithReuseIdentifier: teamFilterCellIdentifier)
        collectionView.register(TeamMatchesSectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "Header")
        backButton.addTarget(self, action: #selector(onTapBack), for: .touchUpInside)
    }
    
    func bindViewModel() {
        viewModel.$teamItemViewModels
            .sink { [weak self] items in
                var snapshot = NSDiffableDataSourceSnapshot<Int, TeamFilterItemViewModel>()
                snapshot.appendSections([0])
                snapshot.appendItems(items, toSection: 0)
                self?.dataSource.apply(snapshot, animatingDifferences: true)
            }
            .store(in: &subscriptions)
            
    }
    
    @objc func onTapBack() {
        viewModel.didClose.send(Array(viewModel.selectingTeams))
    }
    
}

extension TeamsFilterViewController {
    
    func createDataSource() -> UICollectionViewDiffableDataSource<Int, TeamFilterItemViewModel> {
        let dataSource = UICollectionViewDiffableDataSource<Int, TeamFilterItemViewModel>(collectionView: collectionView) { collectionView, indexPath, item in
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: self.teamFilterCellIdentifier,
                for: indexPath
            ) as! TeamFilterCell
            cell.configure(viewModel: item)
            return cell
        }
        return dataSource
    }
    
}

extension TeamsFilterViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let selectedItem = dataSource.itemIdentifier(for: indexPath) else { return }
        viewModel.toggleItem(item: selectedItem)
    }
    
}
