//
//  TeamMatchCell.swift
//  Goal
//
//  Created by Tung Nguyen on 03/01/2024.
//

import UIKit
import Combine

class TeamMatchCell: UICollectionViewCell {
    let selectHomeTeam = PassthroughSubject<Void, Never>()
    let selectAwayTeam = PassthroughSubject<Void, Never>()
    let selectHighlight = PassthroughSubject<Void, Never>()
    
    lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .bodyL
        label.textColor = .buttonText
        return label
    }()
    
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .caption
        label.textColor = .primaryText
        return label
    }()
    
    lazy var timeContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .primary
        view.cornerRadius = 8
        return view
    }()
    
    lazy var homeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .body
        label.textColor = .primaryText
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()
    
    lazy var awayLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .body
        label.textColor = .primaryText
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()
    
    lazy var homeAvatarView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    lazy var awayAvatarView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .background2
        view.cornerRadius = 12
        return view
    }()
    
    lazy var highlightView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .background1
        view.cornerRadius = 12
        view.isUserInteractionEnabled = true
        return view
    }()
    
    lazy var highlightLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .caption
        label.textColor = .primaryText
        label.text = "Watch highlights"
        return label
    }()
    
    lazy var highlightIndicator: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.cornerRadius = 4
        view.backgroundColor = .red
        return view
    }()
    
    var teamsLabelBottomToHighlight: NSLayoutConstraint?
    var teamsLabelBottomToBottom: NSLayoutConstraint?
    var highlightBottomToBottom: NSLayoutConstraint?
    
    var subscriptions = Set<AnyCancellable>()
    var cancellables: [AnyCancellable] = []
    
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
            dateLabel,
            timeContainerView,
            homeLabel,
            awayLabel,
            homeAvatarView,
            awayAvatarView,
            highlightView
        ])
        
        timeContainerView.addSubview(timeLabel)
        
        highlightView.addSubviews([
            highlightIndicator,
            highlightLabel
        ])
        
        teamsLabelBottomToBottom = awayLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -24)
        teamsLabelBottomToHighlight = awayLabel.bottomAnchor.constraint(equalTo: highlightView.topAnchor, constant: -16)
        highlightBottomToBottom = highlightView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -24)
        let awayLabelTop = awayLabel.topAnchor.constraint(equalTo: awayAvatarView.bottomAnchor, constant: 16)
        awayLabelTop.priority = .defaultHigh
        
        NSLayoutConstraint.activate([
            homeAvatarView.heightAnchor.constraint(equalToConstant: 80),
            homeAvatarView.widthAnchor.constraint(equalToConstant: 80),
            homeAvatarView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 24),
            NSLayoutConstraint(item: homeAvatarView, attribute: .centerX, relatedBy: .equal, toItem: containerView, attribute: .centerX, multiplier: 0.5, constant: 0),
            homeLabel.centerXAnchor.constraint(equalTo: homeAvatarView.centerXAnchor),
            
            awayAvatarView.heightAnchor.constraint(equalToConstant: 80),
            awayAvatarView.widthAnchor.constraint(equalToConstant: 80),
            awayAvatarView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 24),
            NSLayoutConstraint(item: awayAvatarView, attribute: .centerX, relatedBy: .equal, toItem: containerView, attribute: .centerX, multiplier: 1.5, constant: 0),
            awayLabel.centerXAnchor.constraint(equalTo: awayAvatarView.centerXAnchor),
            awayLabelTop,
            awayLabel.centerYAnchor.constraint(equalTo: homeLabel.centerYAnchor),
            
            timeContainerView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            timeContainerView.centerYAnchor.constraint(equalTo: homeAvatarView.centerYAnchor),
            timeLabel.topAnchor.constraint(equalTo: timeContainerView.topAnchor, constant: 4),
            timeLabel.bottomAnchor.constraint(equalTo: timeContainerView.bottomAnchor, constant: -4),
            timeLabel.leadingAnchor.constraint(equalTo: timeContainerView.leadingAnchor, constant: 8),
            timeLabel.trailingAnchor.constraint(equalTo: timeContainerView.trailingAnchor, constant: -8),
            
            dateLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            dateLabel.bottomAnchor.constraint(equalTo: timeContainerView.topAnchor, constant: -8),
            
            highlightView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            highlightIndicator.leadingAnchor.constraint(equalTo: highlightView.leadingAnchor, constant: 8),
            highlightIndicator.heightAnchor.constraint(equalToConstant: 8),
            highlightIndicator.widthAnchor.constraint(equalToConstant: 8),
            highlightLabel.leadingAnchor.constraint(equalTo: highlightIndicator.trailingAnchor, constant: 8),
            highlightLabel.centerYAnchor.constraint(equalTo: highlightIndicator.centerYAnchor),
            highlightLabel.trailingAnchor.constraint(equalTo: highlightView.trailingAnchor, constant: -8),
            highlightLabel.topAnchor.constraint(equalTo: highlightView.topAnchor, constant: 8),
            highlightLabel.bottomAnchor.constraint(equalTo: highlightView.bottomAnchor, constant: -8),
        ])
        
        // Gestures
        homeAvatarView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapHomeTeam(_:))))
        awayAvatarView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapAwayTeam(_:))))
        highlightView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapHighlight(_:))))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func tapHomeTeam(_ gesture: UITapGestureRecognizer) {
        selectHomeTeam.send(())
    }
    
    @objc func tapAwayTeam(_ gesture: UITapGestureRecognizer) {
        selectAwayTeam.send(())
    }
    
    @objc func tapHighlight(_ gesture: UITapGestureRecognizer) {
        selectHighlight.send(())
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        teamsLabelBottomToBottom?.isActive = false
        teamsLabelBottomToHighlight?.isActive = false
        highlightBottomToBottom?.isActive = false
        homeAvatarView.image = nil
        awayAvatarView.image = nil
        subscriptions.removeAll()
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
    }
    
    func configure(viewModel: MatchItemViewModel) {
        let hasHighlights = viewModel.highlights != nil
        dateLabel.text = viewModel.date
        timeLabel.text = viewModel.time
        homeLabel.text = viewModel.homeName
        awayLabel.text = viewModel.awayName
        if let cancellable = homeAvatarView.load(link: viewModel.homeLogo) {
            cancellables.append(cancellable)
        }
        if let cancellable = awayAvatarView.load(link: viewModel.awayLogo) {
            cancellables.append(cancellable)
        }
        if viewModel.isPrevious {
            let homeOpacity: Float = viewModel.isHomeWinner ? 0.8 : 0.3
            let awayOpacity: Float = viewModel.isAwayWinner ? 0.8 : 0.3
            homeAvatarView.layer.opacity = homeOpacity
            homeLabel.layer.opacity = homeOpacity
            awayAvatarView.layer.opacity = awayOpacity
            awayLabel.layer.opacity = awayOpacity
        } else {
            homeAvatarView.layer.opacity = 1
            homeLabel.layer.opacity = 1
            awayAvatarView.layer.opacity = 1
            awayLabel.layer.opacity = 1
        }
        timeContainerView.layer.opacity = viewModel.isPrevious ? 0.6 : 1
        highlightView.isHidden = !hasHighlights
        teamsLabelBottomToBottom?.isActive = !hasHighlights
        teamsLabelBottomToHighlight?.isActive = hasHighlights
        highlightBottomToBottom?.isActive = hasHighlights
        layoutIfNeeded()
    }
}
