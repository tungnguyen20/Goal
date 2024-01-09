//
//  TeamFilterCell.swift
//  Goal
//
//  Created by Tung Nguyen on 08/01/2024.
//

import UIKit
import Combine

class TeamFilterCell: UICollectionViewCell {
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .body
        label.textColor = .primaryText
        label.numberOfLines = 2
        return label
    }()
    
    lazy var logoView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    lazy var checkmarkIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "checkmark")
        imageView.tintColor = .primary
        return imageView
    }()
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .background2
        view.cornerRadius = 12
        return view
    }()
    
    var cancellable: AnyCancellable?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .background1
        contentView.addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
        ])
        
        containerView.addSubviews([
            logoView,
            nameLabel,
            checkmarkIcon
        ])
        
        let logoHeight = logoView.heightAnchor.constraint(equalToConstant: 40)
        logoHeight.priority = .defaultHigh
        NSLayoutConstraint.activate([
            logoView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            logoView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            logoView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            logoView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            logoView.widthAnchor.constraint(equalToConstant: 40),
            logoHeight,
            
            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: logoView.trailingAnchor, constant: 16),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            
            checkmarkIcon.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 16),
            checkmarkIcon.widthAnchor.constraint(equalToConstant: 24),
            checkmarkIcon.heightAnchor.constraint(equalToConstant: 24),
            checkmarkIcon.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            checkmarkIcon.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        cancellable?.cancel()
        cancellable = nil
    }
    
    func configure(viewModel: TeamFilterItemViewModel) {
        nameLabel.text = viewModel.name
        cancellable = logoView.load(link: viewModel.logo)
        checkmarkIcon.isHidden = !viewModel.isSelecting
    }
    
}
