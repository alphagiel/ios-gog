//
//  PieceSelectionViewController.swift
//  Games of the General Arbiter
//
//  Created by Alpha Giel De Asis on 8/30/25.
//

import UIKit

class PieceSelectionViewController: UIViewController {
    
    // UI Elements
    private let titleLabel = UILabel()
    private let playerLabel = UILabel()
    private let instructionLabel = UILabel()
    private let tableView = UITableView()
    private let confirmButton = UIButton()
    
    // State
    var currentPlayer: Player?
    private var selectedPiece: GamePiece?
    private var availablePieces: [GamePiece] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupTableView()
        updateUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Select Piece"
        navigationItem.hidesBackButton = true
        
        // Configure title label
        titleLabel.text = "Choose Your Piece"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 28)
        titleLabel.textAlignment = .center
        titleLabel.textColor = .label
        
        // Configure player label
        playerLabel.font = UIFont.boldSystemFont(ofSize: 20)
        playerLabel.textAlignment = .center
        
        // Configure instruction label
        instructionLabel.text = "Select a piece for battle:"
        instructionLabel.font = UIFont.systemFont(ofSize: 16)
        instructionLabel.textAlignment = .center
        instructionLabel.textColor = .secondaryLabel
        
        // Configure table view
        tableView.backgroundColor = .systemBackground
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        
        // Configure confirm button
        confirmButton.setTitle("Confirm Selection", for: .normal)
        confirmButton.backgroundColor = .systemBlue
        confirmButton.setTitleColor(.white, for: .normal)
        confirmButton.layer.cornerRadius = 12
        confirmButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        confirmButton.isEnabled = false
        confirmButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
        
        // Add subviews
        [titleLabel, playerLabel, instructionLabel, tableView, confirmButton].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Title label
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            // Player label
            playerLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15),
            playerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            playerLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            // Instruction label
            instructionLabel.topAnchor.constraint(equalTo: playerLabel.bottomAnchor, constant: 10),
            instructionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            instructionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            // Table view
            tableView.topAnchor.constraint(equalTo: instructionLabel.bottomAnchor, constant: 30),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            tableView.bottomAnchor.constraint(equalTo: confirmButton.topAnchor, constant: -20),
            
            // Confirm button
            confirmButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            confirmButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            confirmButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            confirmButton.heightAnchor.constraint(equalToConstant: 56)
        ])
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(PieceSelectionCell.self, forCellReuseIdentifier: "PieceSelectionCell")
        tableView.rowHeight = 80
    }
    
    private func updateUI() {
        if let player = currentPlayer {
            playerLabel.text = "\(player.name) - \(player.totalRemainingPieces) pieces left"
            playerLabel.textColor = player.color
            
            // Update available pieces list
            availablePieces = player.availablePieces
            tableView.reloadData()
        }
        
        updateConfirmButton()
    }
    
    private func updateConfirmButton() {
        let isEnabled = selectedPiece != nil
        confirmButton.isEnabled = isEnabled
        confirmButton.backgroundColor = isEnabled ? .systemBlue : .systemGray
        
        UIView.animate(withDuration: 0.2) {
            self.confirmButton.alpha = isEnabled ? 1.0 : 0.6
        }
    }
    
    @objc private func confirmButtonTapped() {
        guard let selectedPiece = selectedPiece,
              let currentPlayer = currentPlayer else { return }
        
        // Update the current player's selected piece
        currentPlayer.selectedPiece = selectedPiece
        
        // Add haptic feedback
        let feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
        feedbackGenerator.impactOccurred()
        
        // Navigate back to battle session
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - UITableViewDataSource

extension PieceSelectionViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return availablePieces.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PieceSelectionCell", for: indexPath) as! PieceSelectionCell
        let piece = availablePieces[indexPath.row]
        let isSelected = selectedPiece == piece
        let remainingCount = currentPlayer?.remainingCount(for: piece) ?? 0
        
        cell.configure(with: piece, isSelected: isSelected, remainingCount: remainingCount)
        return cell
    }
}

// MARK: - UITableViewDelegate

extension PieceSelectionViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let piece = availablePieces[indexPath.row]
        selectedPiece = piece
        
        // Add haptic feedback
        let feedbackGenerator = UISelectionFeedbackGenerator()
        feedbackGenerator.selectionChanged()
        
        // Update table view
        tableView.reloadData()
        updateConfirmButton()
    }
}

// MARK: - Custom Cell

class PieceSelectionCell: UITableViewCell {
    
    private let containerView = UIView()
    private let emojiLabel = UILabel()
    private let nameLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let checkmarkImageView = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        selectionStyle = .none
        backgroundColor = .clear
        
        // Configure container view
        containerView.backgroundColor = .systemGray6
        containerView.layer.cornerRadius = 12
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOffset = CGSize(width: 0, height: 1)
        containerView.layer.shadowOpacity = 0.1
        containerView.layer.shadowRadius = 2
        
        // Configure emoji label
        emojiLabel.font = UIFont.systemFont(ofSize: 32)
        emojiLabel.textAlignment = .center
        
        // Configure name label
        nameLabel.font = UIFont.boldSystemFont(ofSize: 18)
        nameLabel.textColor = .label
        
        // Configure description label
        descriptionLabel.font = UIFont.systemFont(ofSize: 14)
        descriptionLabel.textColor = .secondaryLabel
        descriptionLabel.numberOfLines = 2
        
        // Configure checkmark
        checkmarkImageView.image = UIImage(systemName: "checkmark.circle.fill")
        checkmarkImageView.tintColor = .systemGreen
        checkmarkImageView.contentMode = .scaleAspectFit
        checkmarkImageView.isHidden = true
        
        // Add subviews
        contentView.addSubview(containerView)
        [emojiLabel, nameLabel, descriptionLabel, checkmarkImageView].forEach {
            containerView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        containerView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Container view
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            
            // Emoji label
            emojiLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            emojiLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            emojiLabel.widthAnchor.constraint(equalToConstant: 50),
            
            // Name label
            nameLabel.leadingAnchor.constraint(equalTo: emojiLabel.trailingAnchor, constant: 16),
            nameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: checkmarkImageView.leadingAnchor, constant: -16),
            
            // Description label
            descriptionLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            descriptionLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            descriptionLabel.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor, constant: -16),
            
            // Checkmark
            checkmarkImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            checkmarkImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            checkmarkImageView.widthAnchor.constraint(equalToConstant: 24),
            checkmarkImageView.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    func configure(with piece: GamePiece, isSelected: Bool, remainingCount: Int = 0) {
        emojiLabel.text = piece.emoji
        nameLabel.text = "\(piece.rawValue) (\(remainingCount) left)"
        descriptionLabel.text = piece.description
        checkmarkImageView.isHidden = !isSelected
        
        // Update appearance based on selection
        if isSelected {
            containerView.backgroundColor = .systemBlue.withAlphaComponent(0.2)
            containerView.layer.borderColor = UIColor.systemBlue.cgColor
            containerView.layer.borderWidth = 2
        } else {
            containerView.backgroundColor = .systemGray6
            containerView.layer.borderColor = UIColor.clear.cgColor
            containerView.layer.borderWidth = 0
        }
    }
}