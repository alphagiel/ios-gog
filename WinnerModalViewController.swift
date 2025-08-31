//
//  WinnerModalViewController.swift
//  Games of the General Arbiter
//
//  Created by Alpha Giel De Asis on 8/30/25.
//

import UIKit

class WinnerModalViewController: UIViewController {
    
    // UI Elements
    private let backgroundView = UIView()
    private let modalView = UIView()
    private let resultIconLabel = UILabel()
    private let resultLabel = UILabel()
    private let summaryLabel = UILabel()
    private let continueButton = UIButton()
    private let endSessionButton = UIButton()
    
    // State
    var gameResult: GameResult = .tie
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        updateContent()
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
        
        // Configure modal view
        modalView.backgroundColor = .systemBackground
        modalView.layer.cornerRadius = 20
        modalView.layer.shadowColor = UIColor.black.cgColor
        modalView.layer.shadowOffset = CGSize(width: 0, height: 10)
        modalView.layer.shadowOpacity = 0.3
        modalView.layer.shadowRadius = 20
        modalView.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        modalView.alpha = 0
        
        // Configure result icon
        resultIconLabel.font = UIFont.systemFont(ofSize: 80)
        resultIconLabel.textAlignment = .center
        
        // Configure result label
        resultLabel.font = UIFont.boldSystemFont(ofSize: 32)
        resultLabel.textAlignment = .center
        resultLabel.numberOfLines = 2
        
        // Configure summary label
        summaryLabel.font = UIFont.systemFont(ofSize: 16)
        summaryLabel.textAlignment = .center
        summaryLabel.textColor = .secondaryLabel
        summaryLabel.numberOfLines = 0
        
        // Configure continue button
        continueButton.setTitle("Continue", for: .normal)
        continueButton.backgroundColor = .systemBlue
        continueButton.setTitleColor(.white, for: .normal)
        continueButton.layer.cornerRadius = 12
        continueButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        continueButton.addTarget(self, action: #selector(continueButtonTapped), for: .touchUpInside)
        
        // Configure end session button
        endSessionButton.setTitle("End Session", for: .normal)
        endSessionButton.backgroundColor = .systemRed
        endSessionButton.setTitleColor(.white, for: .normal)
        endSessionButton.layer.cornerRadius = 12
        endSessionButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        endSessionButton.addTarget(self, action: #selector(endSessionButtonTapped), for: .touchUpInside)
        
        // Add subviews
        view.addSubview(backgroundView)
        view.addSubview(modalView)
        
        [resultIconLabel, resultLabel, summaryLabel, continueButton, endSessionButton].forEach {
            modalView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        modalView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Background view
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // Modal view
            modalView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            modalView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            modalView.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 40),
            modalView.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -40),
//            modalView.widthAnchor.constraint(lessThanOrEqualToConstant: 350),
            modalView.widthAnchor.constraint(equalToConstant: 300),


            
            // Result icon
            resultIconLabel.topAnchor.constraint(equalTo: modalView.topAnchor, constant: 30),
            resultIconLabel.centerXAnchor.constraint(equalTo: modalView.centerXAnchor),
            
            // Result label
            resultLabel.topAnchor.constraint(equalTo: resultIconLabel.bottomAnchor, constant: 20),
            resultLabel.leadingAnchor.constraint(equalTo: modalView.leadingAnchor, constant: 20),
            resultLabel.trailingAnchor.constraint(equalTo: modalView.trailingAnchor, constant: -20),
            
            // Summary label
            summaryLabel.topAnchor.constraint(equalTo: resultLabel.bottomAnchor, constant: 15),
            summaryLabel.leadingAnchor.constraint(equalTo: modalView.leadingAnchor, constant: 20),
            summaryLabel.trailingAnchor.constraint(equalTo: modalView.trailingAnchor, constant: -20),
            
            // Continue button
            continueButton.topAnchor.constraint(equalTo: summaryLabel.bottomAnchor, constant: 30),
            continueButton.leadingAnchor.constraint(equalTo: modalView.leadingAnchor, constant: 20),
            continueButton.trailingAnchor.constraint(equalTo: modalView.trailingAnchor, constant: -20),
            continueButton.heightAnchor.constraint(equalToConstant: 50),
            
            // End session button
            endSessionButton.topAnchor.constraint(equalTo: continueButton.bottomAnchor, constant: 12),
            endSessionButton.leadingAnchor.constraint(equalTo: modalView.leadingAnchor, constant: 20),
            endSessionButton.trailingAnchor.constraint(equalTo: modalView.trailingAnchor, constant: -20),
            endSessionButton.heightAnchor.constraint(equalToConstant: 50),
            endSessionButton.bottomAnchor.constraint(equalTo: modalView.bottomAnchor, constant: -30)
        ])
    }
    
    private func updateContent() {
        guard let player1 = GameSession.shared.player1,
              let player2 = GameSession.shared.player2 else { return }
        
//        let player1Piece = player1.selectedPiece?.rawValue ?? "Unknown"
//        let player2Piece = player2.selectedPiece?.rawValue ?? "Unknown"
//        let player1Icon = player1.selectedPiece?.emoji ?? "❓"
//        let player2Icon = player2.selectedPiece?.emoji ?? "❓"
        
//        summaryLabel.text = "\(player1.name) (\(player1Icon) \(player1Piece)) vs \(player2.name) (\(player2Icon) \(player2Piece))"
        summaryLabel.text = "\(player1.name) vs \(player2.name)"
        
        switch gameResult {
        case .player1Wins:
            resultIconLabel.text = "🏆"
            resultLabel.text = "\(player1.name) Wins!"
            resultLabel.textColor = player1.color
            
            // Add winner's color accent to modal
            modalView.layer.borderWidth = 3
            modalView.layer.borderColor = player1.color.cgColor
            
        case .player2Wins:
            resultIconLabel.text = "🏆"
            resultLabel.text = "\(player2.name) Wins!"
            resultLabel.textColor = player2.color
            
            // Add winner's color accent to modal
            modalView.layer.borderWidth = 3
            modalView.layer.borderColor = player2.color.cgColor
            
        case .tie:
            resultIconLabel.text = "🤝"
            resultLabel.text = "It's a Tie!"
            resultLabel.textColor = .label
            
            // Add neutral accent to modal
            modalView.layer.borderWidth = 3
            modalView.layer.borderColor = UIColor.systemGray.cgColor
        }
    }
    
    private func animatePresentation() {
        // Trigger haptic feedback
        let feedbackGenerator = UINotificationFeedbackGenerator()
        
        switch gameResult {
        case .player1Wins, .player2Wins:
            feedbackGenerator.notificationOccurred(.success)
        case .tie:
            feedbackGenerator.notificationOccurred(.warning)
        }
        
        // Animate modal presentation
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: [], animations: {
            self.backgroundView.alpha = 1.0
            self.modalView.alpha = 1.0
            self.modalView.transform = CGAffineTransform.identity
        }, completion: { _ in
            // Add a subtle bounce animation to the result icon
            UIView.animate(withDuration: 0.6, delay: 0.2, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.8, options: [], animations: {
                self.resultIconLabel.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            }, completion: { _ in
                UIView.animate(withDuration: 0.4) {
                    self.resultIconLabel.transform = CGAffineTransform.identity
                }
            })
        })
    }
    
    @objc private func continueButtonTapped() {
        print("🔄 Continue button tapped - starting reset process")
        
        // Add haptic feedback
        let feedbackGenerator = UIImpactFeedbackGenerator(style: .light)
        feedbackGenerator.impactOccurred()
        
        // Find and reset the battle session BEFORE dismissing modal
        if let navigationController = self.presentingViewController as? UINavigationController {
            for viewController in navigationController.viewControllers {
                if let battleSessionVC = viewController as? BattleSessionViewController {
                    print("🎯 Found BattleSessionViewController - calling reset")
                    battleSessionVC.resetForNewRound()
                    break
                }
            }
        }
        
        // Small delay to ensure reset completes, then dismiss
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            // Animate dismissal
            UIView.animate(withDuration: 0.3, animations: {
                self.backgroundView.alpha = 0
                self.modalView.alpha = 0
                self.modalView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            }, completion: { _ in
                self.dismiss(animated: false) {
                    print("✅ Modal dismissed - reset should be complete")
                }
            })
        }
    }
    
    @objc private func endSessionButtonTapped() {
        print("🏁 End Session button tapped")
        
        // Add haptic feedback
        let feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
        feedbackGenerator.impactOccurred()
        
        // End the session and get stats
        guard let sessionStats = BattleStatsManager.shared.endCurrentSession() else {
            print("❌ No session to end")
            return
        }
        
        print("📊 Navigating to stats page with \(sessionStats.totalBattles) battles")
        
        // Get the navigation controller first
        guard let navigationController = self.presentingViewController as? UINavigationController else {
            print("❌ Could not find navigation controller")
            return
        }
        
        // Create stats view controller
        let statsVC = StatsPageViewController()
        statsVC.gameSession = sessionStats
        
        // Dismiss modal first, then navigate
        self.dismiss(animated: false) {
            print("📱 Modal dismissed, now pushing stats view controller")
            
            // Small delay to ensure modal is fully dismissed
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                navigationController.pushViewController(statsVC, animated: true)
                print("✅ Stats view controller pushed")
            }
        }
    }
}
