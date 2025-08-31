//
//  PlayerSetupViewController.swift
//  Games of the General Arbiter
//
//  Created by Alpha Giel De Asis on 8/30/25.
//

import UIKit

class PlayerSetupViewController: UIViewController {
    
    // UI Elements
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let titleLabel = UILabel()
    
    // Player 1 Elements
    private let player1TitleLabel = UILabel()
    private let player1NameTextField = UITextField()
    private let player1ColorLabel = UILabel()
    private let player1ColorStackView = UIStackView()
    
    // Player 2 Elements
    private let player2TitleLabel = UILabel()
    private let player2NameTextField = UITextField()
    private let player2ColorLabel = UILabel()
    private let player2ColorStackView = UIStackView()
    
    private let startBattleButton = UIButton()
    
    // State
    private var selectedPlayer1Color: UIColor?
    private var selectedPlayer2Color: UIColor?
    private var player1ColorButtons: [UIButton] = []
    private var player2ColorButtons: [UIButton] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupTextFieldDelegates()
        updateStartBattleButton()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Setup Players"
        
        // Configure scroll view
        scrollView.showsVerticalScrollIndicator = true
        scrollView.alwaysBounceVertical = true
        
        // Configure title label
        titleLabel.text = "Battle Setup"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 28)
        titleLabel.textAlignment = .center
        
        // Configure Player 1 section
        player1TitleLabel.text = "Player 1"
        player1TitleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        player1TitleLabel.textColor = .label
        
        player1NameTextField.placeholder = "Enter Player 1 Name"
        player1NameTextField.borderStyle = .roundedRect
        player1NameTextField.autocapitalizationType = .words
        player1NameTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        player1ColorLabel.text = "Select Color:"
        player1ColorLabel.font = UIFont.systemFont(ofSize: 16)
        
        setupColorButtons(for: .player1)
        
        // Configure Player 2 section
        player2TitleLabel.text = "Player 2"
        player2TitleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        player2TitleLabel.textColor = .label
        
        player2NameTextField.placeholder = "Enter Player 2 Name"
        player2NameTextField.borderStyle = .roundedRect
        player2NameTextField.autocapitalizationType = .words
        player2NameTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        player2ColorLabel.text = "Select Color:"
        player2ColorLabel.font = UIFont.systemFont(ofSize: 16)
        
        setupColorButtons(for: .player2)
        
        // Configure start battle button
        startBattleButton.setTitle("Start Battle", for: .normal)
        startBattleButton.backgroundColor = .systemGreen
        startBattleButton.setTitleColor(.white, for: .normal)
        startBattleButton.layer.cornerRadius = 12
        startBattleButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        startBattleButton.isEnabled = false
        startBattleButton.addTarget(self, action: #selector(startBattleTapped), for: .touchUpInside)
        
        // Add subviews
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        [titleLabel, player1TitleLabel, player1NameTextField, player1ColorLabel, player1ColorStackView,
         player2TitleLabel, player2NameTextField, player2ColorLabel, player2ColorStackView, startBattleButton].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private enum PlayerType {
        case player1, player2
    }
    
    private func setupColorButtons(for playerType: PlayerType) {
        let stackView = playerType == .player1 ? player1ColorStackView : player2ColorStackView
        
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 12
        
        for (index, colorInfo) in GameColors.availableColors.enumerated() {
            let button = UIButton()
            button.backgroundColor = colorInfo.color
            button.layer.cornerRadius = 25
            button.layer.borderWidth = 3
            button.layer.borderColor = UIColor.systemGray4.cgColor
            button.tag = index
            button.addTarget(self, action: #selector(colorButtonTapped), for: .touchUpInside)
            
            // Store player type in button
            if playerType == .player1 {
                button.accessibilityIdentifier = "player1Color"
                player1ColorButtons.append(button)
            } else {
                button.accessibilityIdentifier = "player2Color"
                player2ColorButtons.append(button)
            }
            
            stackView.addArrangedSubview(button)
            
            NSLayoutConstraint.activate([
                button.widthAnchor.constraint(equalToConstant: 50),
                button.heightAnchor.constraint(equalToConstant: 50)
            ])
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Scroll view
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // Content view
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // Title label
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 30),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Player 1 section
            player1TitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40),
            player1TitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            player1TitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            player1NameTextField.topAnchor.constraint(equalTo: player1TitleLabel.bottomAnchor, constant: 15),
            player1NameTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            player1NameTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            player1NameTextField.heightAnchor.constraint(equalToConstant: 50),
            
            player1ColorLabel.topAnchor.constraint(equalTo: player1NameTextField.bottomAnchor, constant: 20),
            player1ColorLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            player1ColorStackView.topAnchor.constraint(equalTo: player1ColorLabel.bottomAnchor, constant: 10),
            player1ColorStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            player1ColorStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Player 2 section
            player2TitleLabel.topAnchor.constraint(equalTo: player1ColorStackView.bottomAnchor, constant: 40),
            player2TitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            player2TitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            player2NameTextField.topAnchor.constraint(equalTo: player2TitleLabel.bottomAnchor, constant: 15),
            player2NameTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            player2NameTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            player2NameTextField.heightAnchor.constraint(equalToConstant: 50),
            
            player2ColorLabel.topAnchor.constraint(equalTo: player2NameTextField.bottomAnchor, constant: 20),
            player2ColorLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            player2ColorStackView.topAnchor.constraint(equalTo: player2ColorLabel.bottomAnchor, constant: 10),
            player2ColorStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            player2ColorStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Start battle button
            startBattleButton.topAnchor.constraint(equalTo: player2ColorStackView.bottomAnchor, constant: 50),
            startBattleButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 40),
            startBattleButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -40),
            startBattleButton.heightAnchor.constraint(equalToConstant: 56),
            startBattleButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30)
        ])
    }
    
    private func setupTextFieldDelegates() {
        player1NameTextField.delegate = self
        player2NameTextField.delegate = self
    }
    
    @objc private func colorButtonTapped(_ sender: UIButton) {
        let colorInfo = GameColors.availableColors[sender.tag]
        let isPlayer1 = sender.accessibilityIdentifier == "player1Color"
        
        if isPlayer1 {
            // Check if Player 2 already selected this color
            if selectedPlayer2Color == colorInfo.color {
                showAlert(title: "Color Conflict", message: "Player 2 has already selected this color. Please choose a different color.")
                return
            }
            
            // Update Player 1 selection
            selectedPlayer1Color = colorInfo.color
            updateColorButtonSelection(for: .player1, selectedIndex: sender.tag)
        } else {
            // Check if Player 1 already selected this color
            if selectedPlayer1Color == colorInfo.color {
                showAlert(title: "Color Conflict", message: "Player 1 has already selected this color. Please choose a different color.")
                return
            }
            
            // Update Player 2 selection
            selectedPlayer2Color = colorInfo.color
            updateColorButtonSelection(for: .player2, selectedIndex: sender.tag)
        }
        
        updateStartBattleButton()
    }
    
    private func updateColorButtonSelection(for playerType: PlayerType, selectedIndex: Int) {
        let buttons = playerType == .player1 ? player1ColorButtons : player2ColorButtons
        
        for (index, button) in buttons.enumerated() {
            if index == selectedIndex {
                button.layer.borderColor = UIColor.label.cgColor
                button.layer.borderWidth = 4
                button.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            } else {
                button.layer.borderColor = UIColor.systemGray4.cgColor
                button.layer.borderWidth = 3
                button.transform = CGAffineTransform.identity
            }
        }
    }
    
    @objc private func textFieldDidChange() {
        updateStartBattleButton()
    }
    
    private func updateStartBattleButton() {
        let player1NameValid = isValidName(player1NameTextField.text)
        let player2NameValid = isValidName(player2NameTextField.text)
        let colorsSelected = selectedPlayer1Color != nil && selectedPlayer2Color != nil
        
        let isFormValid = player1NameValid && player2NameValid && colorsSelected
        
        startBattleButton.isEnabled = isFormValid
        startBattleButton.backgroundColor = isFormValid ? .systemGreen : .systemGray
    }
    
    private func isValidName(_ name: String?) -> Bool {
        guard let name = name?.trimmingCharacters(in: .whitespaces),
              !name.isEmpty,
              name.count <= 20 else {
            return false
        }
        
        let alphanumericSet = CharacterSet.alphanumerics.union(CharacterSet.whitespaces)
        return name.rangeOfCharacter(from: alphanumericSet.inverted) == nil
    }
    
    @objc private func startBattleTapped() {
        guard let player1Name = player1NameTextField.text?.trimmingCharacters(in: .whitespaces),
              let player2Name = player2NameTextField.text?.trimmingCharacters(in: .whitespaces),
              let player1Color = selectedPlayer1Color,
              let player2Color = selectedPlayer2Color else {
            showAlert(title: "Invalid Input", message: "Please fill in all required fields.")
            return
        }
        
        if player1Name.lowercased() == player2Name.lowercased() {
            showAlert(title: "Name Conflict", message: "Players must have different names.")
            return
        }
        
        // Create players and save to game session
        let player1 = Player(name: player1Name, color: player1Color)
        let player2 = Player(name: player2Name, color: player2Color)
        
        GameSession.shared.player1 = player1
        GameSession.shared.player2 = player2
        
        // Start new battle stats session
        BattleStatsManager.shared.startNewSession(player1Name: player1Name, player2Name: player2Name)
        
        // Navigate to battle session
        let battleSessionVC = BattleSessionViewController()
        navigationController?.pushViewController(battleSessionVC, animated: true)
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UITextFieldDelegate

extension PlayerSetupViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        // Limit to 20 characters
        if updatedText.count > 20 {
            return false
        }
        
        // Allow only alphanumeric characters and spaces
        let allowedCharacters = CharacterSet.alphanumerics.union(CharacterSet.whitespaces)
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == player1NameTextField {
            player2NameTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
}