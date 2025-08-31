//
//  BattleSessionViewController.swift
//  Games of the General Arbiter
//
//  Created by Alpha Giel De Asis on 8/30/25.
//

import UIKit

class BattleSessionViewController: UIViewController {
    
    // UI Elements
    private let headerLabel = UILabel()
    private let instructionLabel = UILabel()
    private let player1Button = UIButton()
    private let player2Button = UIButton()
    private let statusLabel = UILabel()
    
    // State
    private var player1Selected = false
    private var player2Selected = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        updateUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("🔄 BattleSessionViewController viewWillAppear")
        
        // Update selection flags based on actual piece selection
        if GameSession.shared.player1?.selectedPiece != nil {
            player1Selected = true
        }
        if GameSession.shared.player2?.selectedPiece != nil {
            player2Selected = true
        }
        
        print("🔍 Checking pieces: P1=\(GameSession.shared.player1?.selectedPiece?.rawValue ?? "none"), P2=\(GameSession.shared.player2?.selectedPiece?.rawValue ?? "none")")
        print("🔍 Selection flags: P1Selected=\(player1Selected), P2Selected=\(player2Selected)")
        
        // Check if we should determine winner
        if player1Selected && player2Selected && 
           GameSession.shared.player1?.selectedPiece != nil && 
           GameSession.shared.player2?.selectedPiece != nil {
            print("🏆 Both players have selected pieces - checking for game completion")
            // Small delay to ensure UI is ready
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.checkForGameCompletion()
            }
        }
        
        // Ensure UI is updated when returning to this view
        updateUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("🔄 BattleSessionViewController viewDidAppear")
        
        // Force another UI update to ensure everything is correct
        updateUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Battle Session"
        navigationItem.hidesBackButton = true
        
        // Configure header label
        headerLabel.text = "Battle Arena"
        headerLabel.font = UIFont.boldSystemFont(ofSize: 32)
        headerLabel.textAlignment = .center
        headerLabel.textColor = .label
        
        // Configure instruction label
        instructionLabel.text = "Players, select your names to choose pieces."
        instructionLabel.font = UIFont.systemFont(ofSize: 18)
        instructionLabel.textAlignment = .center
        instructionLabel.textColor = .secondaryLabel
        instructionLabel.numberOfLines = 2
        
        // Configure player buttons
        setupPlayerButtons()
        
        // Configure status label
        statusLabel.text = ""
        statusLabel.font = UIFont.systemFont(ofSize: 16)
        statusLabel.textAlignment = .center
        statusLabel.textColor = .secondaryLabel
        statusLabel.numberOfLines = 0
        
        // Add subviews
        [headerLabel, instructionLabel, player1Button, player2Button, statusLabel].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func setupPlayerButtons() {
        guard let player1 = GameSession.shared.player1,
              let player2 = GameSession.shared.player2 else { return }
        
        // Player 1 button
        player1Button.setTitle("Player 1: \(player1.name)", for: .normal)
        player1Button.setTitleColor(.white, for: .normal)
        player1Button.backgroundColor = player1.color
        player1Button.layer.cornerRadius = 16
        player1Button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        player1Button.layer.shadowColor = UIColor.black.cgColor
        player1Button.layer.shadowOffset = CGSize(width: 0, height: 2)
        player1Button.layer.shadowOpacity = 0.2
        player1Button.layer.shadowRadius = 4
        player1Button.addTarget(self, action: #selector(player1ButtonTapped), for: .touchUpInside)
        
        // Player 2 button
        player2Button.setTitle("Player 2: \(player2.name)", for: .normal)
        player2Button.setTitleColor(.white, for: .normal)
        player2Button.backgroundColor = player2.color
        player2Button.layer.cornerRadius = 16
        player2Button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        player2Button.layer.shadowColor = UIColor.black.cgColor
        player2Button.layer.shadowOffset = CGSize(width: 0, height: 2)
        player2Button.layer.shadowOpacity = 0.2
        player2Button.layer.shadowRadius = 4
        player2Button.addTarget(self, action: #selector(player2ButtonTapped), for: .touchUpInside)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Header label
            headerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            headerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            headerLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            // Instruction label
            instructionLabel.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 30),
            instructionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            instructionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            // Player 1 button
            player1Button.topAnchor.constraint(equalTo: instructionLabel.bottomAnchor, constant: 60),
            player1Button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            player1Button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            player1Button.heightAnchor.constraint(equalToConstant: 64),
            
            // Player 2 button
            player2Button.topAnchor.constraint(equalTo: player1Button.bottomAnchor, constant: 24),
            player2Button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            player2Button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            player2Button.heightAnchor.constraint(equalToConstant: 64),
            
            // Status label
            statusLabel.topAnchor.constraint(equalTo: player2Button.bottomAnchor, constant: 40),
            statusLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            statusLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
    }
    
    private func updateUI() {
        print("🔄 UpdateUI called - player1Selected: \(player1Selected), player2Selected: \(player2Selected)")
        
        // Auto-reset selection status if pieces were cleared
        if player1Selected && GameSession.shared.player1?.selectedPiece == nil {
            player1Selected = false
        }
        if player2Selected && GameSession.shared.player2?.selectedPiece == nil {
            player2Selected = false
        }
        
        if !player1Selected && !player2Selected {
            print("📱 Setting UI for initial piece selection")
            instructionLabel.text = "Players, select your names to choose pieces."
            statusLabel.text = ""
        } else if player1Selected && !player2Selected {
            print("📱 Player 1 selected, waiting for Player 2")
            instructionLabel.text = "Player 1 has chosen their piece."
            statusLabel.text = "Player 2, select your name to choose your piece."
        } else if !player1Selected && player2Selected {
            print("📱 Player 2 selected, waiting for Player 1")
            instructionLabel.text = "Player 2 has chosen their piece."
            statusLabel.text = "Player 1, select your name to choose your piece."
        }
        
        // Update button states based on selection status
        if player1Selected && GameSession.shared.player1?.selectedPiece != nil {
            player1Button.alpha = 0.6
            player1Button.setTitle("✓ \(GameSession.shared.player1?.name ?? "Player 1")", for: .normal)
        } else {
            player1Button.alpha = 1.0
            player1Button.setTitle("Player 1: \(GameSession.shared.player1?.name ?? "")", for: .normal)
        }
        
        if player2Selected && GameSession.shared.player2?.selectedPiece != nil {
            player2Button.alpha = 0.6
            player2Button.setTitle("✓ \(GameSession.shared.player2?.name ?? "Player 2")", for: .normal)
        } else {
            player2Button.alpha = 1.0
            player2Button.setTitle("Player 2: \(GameSession.shared.player2?.name ?? "")", for: .normal)
        }
        
        // Both buttons remain enabled - players can change their selection
        player1Button.isEnabled = true
        player2Button.isEnabled = true
        
        print("✅ UI updated - P1 enabled: \(player1Button.isEnabled), P2 enabled: \(player2Button.isEnabled)")
    }
    
    @objc private func player1ButtonTapped() {
        print("🔴 Player 1 button tapped - player1Selected: \(player1Selected), player2Selected: \(player2Selected)")
        
        guard let player1 = GameSession.shared.player1 else { 
            print("❌ Player 1 is nil")
            return 
        }
        
        print("🎯 Player 1 selecting piece")
        player1Selected = true
        updateUI()
        
        // Navigate to piece selection for Player 1
        let pieceSelectionVC = PieceSelectionViewController()
        pieceSelectionVC.currentPlayer = player1
        navigationController?.pushViewController(pieceSelectionVC, animated: true)
    }
    
    @objc private func player2ButtonTapped() {
        print("🔵 Player 2 button tapped - player1Selected: \(player1Selected), player2Selected: \(player2Selected)")
        
        guard let player2 = GameSession.shared.player2 else { 
            print("❌ Player 2 is nil")
            return 
        }
        
        print("🎯 Player 2 selecting piece")
        player2Selected = true
        updateUI()
        
        // Navigate to piece selection for Player 2
        let pieceSelectionVC = PieceSelectionViewController()
        pieceSelectionVC.currentPlayer = player2
        navigationController?.pushViewController(pieceSelectionVC, animated: true)
    }
    
    private func checkForGameCompletion() {
        print("🏁 checkForGameCompletion called")
        
        guard let player1 = GameSession.shared.player1,
              let player2 = GameSession.shared.player2 else {
            print("❌ Missing players: P1=\(GameSession.shared.player1?.name ?? "nil"), P2=\(GameSession.shared.player2?.name ?? "nil")")
            return
        }
        
        guard let piece1 = player1.selectedPiece,
              let piece2 = player2.selectedPiece else {
            print("❌ Missing pieces: P1=\(player1.selectedPiece?.rawValue ?? "nil"), P2=\(player2.selectedPiece?.rawValue ?? "nil")")
            return
        }
        
        print("🎮 Both players ready! \(player1.name)(\(piece1.rawValue)) vs \(player2.name)(\(piece2.rawValue))")
        
        // Both players have selected pieces, determine winner
        let result = GameLogic.determineWinner(player1: player1, player2: player2)
        print("🏆 Game result: \(result)")
        
        // Consume pieces based on battle result
        switch result {
        case .player1Wins:
            // Player 1 wins: Player 2 loses their piece, Player 1 keeps theirs
            _ = player2.usePiece(piece2)
            print("📉 \(player2.name) lost \(piece2.rawValue) - \(player2.remainingCount(for: piece2)) left")
        case .player2Wins:
            // Player 2 wins: Player 1 loses their piece, Player 2 keeps theirs
            _ = player1.usePiece(piece1)
            print("📉 \(player1.name) lost \(piece1.rawValue) - \(player1.remainingCount(for: piece1)) left")
        case .tie:
            // Both pieces are eliminated in a tie
            _ = player1.usePiece(piece1)
            _ = player2.usePiece(piece2)
            print("📉 Both players lost their pieces in a tie")
        }
        
        // Save battle result to stats
        BattleStatsManager.shared.addBattleResult(player1: player1, player2: player2, result: result)
        
        // Show winner modal
        let winnerModal = WinnerModalViewController()
        winnerModal.gameResult = result
        winnerModal.modalPresentationStyle = .overFullScreen
        winnerModal.modalTransitionStyle = .crossDissolve
        present(winnerModal, animated: true)
    }
    
    func resetForNewRound() {
        print("🔄 Resetting for new round...")
        
        // Reset local state first
        player1Selected = false
        player2Selected = false
        
        // Clear selected pieces from players
        GameSession.shared.player1?.selectedPiece = nil
        GameSession.shared.player2?.selectedPiece = nil
        
        // Reset game session
        GameSession.shared.startNewRound()
        
        // Force immediate UI reset on main thread
        if Thread.isMainThread {
            performReset()
        } else {
            DispatchQueue.main.sync { [weak self] in
                self?.performReset()
            }
        }
    }
    
    private func performReset() {
        print("🔧 Performing UI reset...")
        
        // Explicitly reset button states
        player1Button.isEnabled = true
        player1Button.alpha = 1.0
        player2Button.isEnabled = true
        player2Button.alpha = 1.0
        
        // Reset button titles to original format
        if let player1Name = GameSession.shared.player1?.name {
            player1Button.setTitle("Player 1: \(player1Name)", for: .normal)
        }
        if let player2Name = GameSession.shared.player2?.name {
            player2Button.setTitle("Player 2: \(player2Name)", for: .normal)
        }
        
        // Reset instruction and status labels
        instructionLabel.text = "Players, select your names to choose pieces."
        statusLabel.text = ""
        
        // Force UI update
        updateUI()
        
        // Force view to redraw
        view.setNeedsLayout()
        view.layoutIfNeeded()
        
        print("✅ Reset complete:")
        print("   - player1Selected: \(player1Selected)")
        print("   - player2Selected: \(player2Selected)")
        print("   - P1 enabled: \(player1Button.isEnabled)")
        print("   - P2 enabled: \(player2Button.isEnabled)")
        print("   - P1 piece: \(GameSession.shared.player1?.selectedPiece?.rawValue ?? "none")")
        print("   - P2 piece: \(GameSession.shared.player2?.selectedPiece?.rawValue ?? "none")")
    }
}