//
//  BattleDetailsModalViewController.swift
//  Games of the General Arbiter
//
//  Created by Alpha Giel De Asis on 8/30/25.
//

import UIKit

class BattleDetailsModalViewController: UIViewController {
    
    // UI Elements
    private let backgroundView = UIView()
    private let modalView = UIView()
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let titleLabel = UILabel()
    private let battleNumberLabel = UILabel()
    private let timestampLabel = UILabel()
    
    private let versusContainerView = UIView()
    private let player1ContainerView = UIView()
    private let player1NameLabel = UILabel()
    private let player1PieceLabel = UILabel()
    private let player1RoleLabel = UILabel()
    
    private let vsLabel = UILabel()
    
    private let player2ContainerView = UIView()
    private let player2NameLabel = UILabel()
    private let player2PieceLabel = UILabel()
    private let player2RoleLabel = UILabel()
    
    private let resultContainerView = UIView()
    private let resultIconLabel = UILabel()
    private let resultLabel = UILabel()
    private let resultDescriptionLabel = UILabel()
    
    private let closeButton = UIButton()
    
    // Data
    var battleResult: BattleResult?
    var battleNumber: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        loadBattleData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animatePresentation()
    }
    
    private func setupUI() {
        view.backgroundColor = .clear
        
        // Configure background view
        backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        backgroundView.alpha = 0
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped))
        backgroundView.addGestureRecognizer(tapGesture)
        
        // Configure modal view
        modalView.backgroundColor = .systemBackground
        modalView.layer.cornerRadius = 20
        modalView.layer.shadowColor = UIColor.black.cgColor
        modalView.layer.shadowOffset = CGSize(width: 0, height: 10)
        modalView.layer.shadowOpacity = 0.3
        modalView.layer.shadowRadius = 20
        modalView.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        modalView.alpha = 0
        
        // Configure scroll view
        scrollView.showsVerticalScrollIndicator = true
        scrollView.alwaysBounceVertical = true
        
        // Configure title
        titleLabel.text = "Battle Details"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.textAlignment = .center
        titleLabel.textColor = .label
        
        // Configure battle number
        battleNumberLabel.font = UIFont.boldSystemFont(ofSize: 18)
        battleNumberLabel.textAlignment = .center
        battleNumberLabel.textColor = .systemBlue
        
        // Configure timestamp
        timestampLabel.font = UIFont.systemFont(ofSize: 14)
        timestampLabel.textAlignment = .center
        timestampLabel.textColor = .secondaryLabel
        
        // Configure versus container
        versusContainerView.backgroundColor = .systemGray6
        versusContainerView.layer.cornerRadius = 12
        
        // Configure player containers
        setupPlayerContainer(player1ContainerView, nameLabel: player1NameLabel, pieceLabel: player1PieceLabel, roleLabel: player1RoleLabel)
        setupPlayerContainer(player2ContainerView, nameLabel: player2NameLabel, pieceLabel: player2PieceLabel, roleLabel: player2RoleLabel)
        
        // Configure VS label
        vsLabel.text = "VS"
        vsLabel.font = UIFont.boldSystemFont(ofSize: 16)
        vsLabel.textAlignment = .center
        vsLabel.textColor = .secondaryLabel
        
        // Configure result container
        resultContainerView.backgroundColor = .systemGray6
        resultContainerView.layer.cornerRadius = 12
        
        // Configure result elements
        resultIconLabel.font = UIFont.systemFont(ofSize: 40)
        resultIconLabel.textAlignment = .center
        
        resultLabel.font = UIFont.boldSystemFont(ofSize: 20)
        resultLabel.textAlignment = .center
        
        resultDescriptionLabel.font = UIFont.systemFont(ofSize: 14)
        resultDescriptionLabel.textAlignment = .center
        resultDescriptionLabel.textColor = .secondaryLabel
        resultDescriptionLabel.numberOfLines = 0
        
        // Configure close button
        closeButton.setTitle("Close", for: .normal)
        closeButton.backgroundColor = .systemBlue
        closeButton.setTitleColor(.white, for: .normal)
        closeButton.layer.cornerRadius = 10
        closeButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        
        // Add subviews
        view.addSubview(backgroundView)
        view.addSubview(modalView)
        modalView.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        [titleLabel, battleNumberLabel, timestampLabel, versusContainerView, resultContainerView, closeButton].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        [player1ContainerView, vsLabel, player2ContainerView].forEach {
            versusContainerView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        [resultIconLabel, resultLabel, resultDescriptionLabel].forEach {
            resultContainerView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        modalView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupPlayerContainer(_ container: UIView, nameLabel: UILabel, pieceLabel: UILabel, roleLabel: UILabel) {
        container.backgroundColor = .systemBackground
        container.layer.cornerRadius = 8
        container.layer.borderWidth = 1
        container.layer.borderColor = UIColor.systemGray4.cgColor
        
        nameLabel.font = UIFont.boldSystemFont(ofSize: 16)
        nameLabel.textAlignment = .center
        
        pieceLabel.font = UIFont.systemFont(ofSize: 24)
        pieceLabel.textAlignment = .center
        
        roleLabel.font = UIFont.systemFont(ofSize: 12)
        roleLabel.textAlignment = .center
        roleLabel.textColor = .secondaryLabel
        
        [nameLabel, pieceLabel, roleLabel].forEach {
            container.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 12),
            nameLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 8),
            nameLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -8),
            
            pieceLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            pieceLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 8),
            pieceLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -8),
            
            roleLabel.topAnchor.constraint(equalTo: pieceLabel.bottomAnchor, constant: 4),
            roleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 8),
            roleLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -8),
            roleLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -12)
        ])
    }
    
    private func setupConstraints() {
        // Set up height constraints with priorities
        let minHeightConstraint = modalView.heightAnchor.constraint(greaterThanOrEqualToConstant: 400)
        let maxHeightConstraint = modalView.heightAnchor.constraint(lessThanOrEqualTo: view.heightAnchor, constant: -100)
        maxHeightConstraint.priority = UILayoutPriority(999)
        
        NSLayoutConstraint.activate([
            // Background view
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // Modal view
            modalView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            modalView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            modalView.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 30),
            modalView.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -30),
            modalView.widthAnchor.constraint(lessThanOrEqualToConstant: 400),
            minHeightConstraint,
            maxHeightConstraint,
            
            // Scroll view
            scrollView.topAnchor.constraint(equalTo: modalView.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: modalView.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: modalView.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: modalView.bottomAnchor),
            
            // Content view
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // Title
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Battle number
            battleNumberLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            battleNumberLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            battleNumberLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Timestamp
            timestampLabel.topAnchor.constraint(equalTo: battleNumberLabel.bottomAnchor, constant: 4),
            timestampLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            timestampLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Versus container
            versusContainerView.topAnchor.constraint(equalTo: timestampLabel.bottomAnchor, constant: 20),
            versusContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            versusContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Player containers within versus container
            player1ContainerView.topAnchor.constraint(equalTo: versusContainerView.topAnchor, constant: 16),
            player1ContainerView.leadingAnchor.constraint(equalTo: versusContainerView.leadingAnchor, constant: 16),
            player1ContainerView.widthAnchor.constraint(equalTo: versusContainerView.widthAnchor, multiplier: 0.35),
            player1ContainerView.bottomAnchor.constraint(equalTo: versusContainerView.bottomAnchor, constant: -16),
            
            vsLabel.centerXAnchor.constraint(equalTo: versusContainerView.centerXAnchor),
            vsLabel.centerYAnchor.constraint(equalTo: versusContainerView.centerYAnchor),
            vsLabel.widthAnchor.constraint(equalToConstant: 40),
            
            player2ContainerView.topAnchor.constraint(equalTo: versusContainerView.topAnchor, constant: 16),
            player2ContainerView.trailingAnchor.constraint(equalTo: versusContainerView.trailingAnchor, constant: -16),
            player2ContainerView.widthAnchor.constraint(equalTo: versusContainerView.widthAnchor, multiplier: 0.35),
            player2ContainerView.bottomAnchor.constraint(equalTo: versusContainerView.bottomAnchor, constant: -16),
            
            // Result container
            resultContainerView.topAnchor.constraint(equalTo: versusContainerView.bottomAnchor, constant: 20),
            resultContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            resultContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Result elements
            resultIconLabel.topAnchor.constraint(equalTo: resultContainerView.topAnchor, constant: 16),
            resultIconLabel.centerXAnchor.constraint(equalTo: resultContainerView.centerXAnchor),
            
            resultLabel.topAnchor.constraint(equalTo: resultIconLabel.bottomAnchor, constant: 8),
            resultLabel.leadingAnchor.constraint(equalTo: resultContainerView.leadingAnchor, constant: 16),
            resultLabel.trailingAnchor.constraint(equalTo: resultContainerView.trailingAnchor, constant: -16),
            
            resultDescriptionLabel.topAnchor.constraint(equalTo: resultLabel.bottomAnchor, constant: 8),
            resultDescriptionLabel.leadingAnchor.constraint(equalTo: resultContainerView.leadingAnchor, constant: 16),
            resultDescriptionLabel.trailingAnchor.constraint(equalTo: resultContainerView.trailingAnchor, constant: -16),
            resultDescriptionLabel.bottomAnchor.constraint(equalTo: resultContainerView.bottomAnchor, constant: -16),
            
            // Close button
            closeButton.topAnchor.constraint(equalTo: resultContainerView.bottomAnchor, constant: 20),
            closeButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            closeButton.widthAnchor.constraint(equalToConstant: 100),
            closeButton.heightAnchor.constraint(equalToConstant: 44),
            closeButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
    
    private func loadBattleData() {
        guard let battle = battleResult else { return }
        
        battleNumberLabel.text = "Battle #\(battleNumber)"
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        timestampLabel.text = formatter.string(from: battle.timestamp)
        
        // Load player 1 data
        player1NameLabel.text = battle.player1Name
        player1NameLabel.textColor = battle.player1UIColor
        
        let piece1Emoji = GamePiece.allCases.first { $0.rawValue == battle.player1Piece }?.emoji ?? "❓"
        player1PieceLabel.text = "\(piece1Emoji) \(battle.player1Piece)"
        player1RoleLabel.text = "Attacker"
        
        player1ContainerView.layer.borderColor = battle.player1UIColor.cgColor
        
        // Load player 2 data
        player2NameLabel.text = battle.player2Name
        player2NameLabel.textColor = battle.player2UIColor
        
        let piece2Emoji = GamePiece.allCases.first { $0.rawValue == battle.player2Piece }?.emoji ?? "❓"
        player2PieceLabel.text = "\(piece2Emoji) \(battle.player2Piece)"
        player2RoleLabel.text = "Defender"
        
        player2ContainerView.layer.borderColor = battle.player2UIColor.cgColor
        
        // Load result data
        switch battle.winner {
        case "player1":
            resultIconLabel.text = "🏆"
            resultLabel.text = "\(battle.player1Name) Wins!"
            resultLabel.textColor = battle.player1UIColor
            resultDescriptionLabel.text = "\(battle.player1Piece) defeats \(battle.player2Piece)"
        case "player2":
            resultIconLabel.text = "🏆"
            resultLabel.text = "\(battle.player2Name) Wins!"
            resultLabel.textColor = battle.player2UIColor
            resultDescriptionLabel.text = "\(battle.player2Piece) defeats \(battle.player1Piece)"
        default:
            resultIconLabel.text = "🤝"
            resultLabel.text = "Tie!"
            resultLabel.textColor = .label
            resultDescriptionLabel.text = "Both \(battle.player1Piece) and \(battle.player2Piece) were eliminated"
        }
    }
    
    private func animatePresentation() {
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: [], animations: {
            self.backgroundView.alpha = 1.0
            self.modalView.alpha = 1.0
            self.modalView.transform = CGAffineTransform.identity
        })
    }
    
    @objc private func backgroundTapped() {
        closeModal()
    }
    
    @objc private func closeButtonTapped() {
        closeModal()
    }
    
    private func closeModal() {
        UIView.animate(withDuration: 0.3, animations: {
            self.backgroundView.alpha = 0
            self.modalView.alpha = 0
            self.modalView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }, completion: { _ in
            self.dismiss(animated: false)
        })
    }
}