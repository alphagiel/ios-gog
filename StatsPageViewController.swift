//
//  StatsPageViewController.swift
//  Games of the General Arbiter
//
//  Created by Alpha Giel De Asis on 8/30/25.
//

import UIKit

class StatsPageViewController: UIViewController {
    
    // UI Elements
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let titleLabel = UILabel()
    private let sessionSummaryView = UIView()
    private let player1StatsLabel = UILabel()
    private let player2StatsLabel = UILabel()
    private let overallStatsLabel = UILabel()
    
    private let battlesHeaderLabel = UILabel()
    private let tableView = UITableView()
    private let homeButton = UIButton()
    
    // Data
    var gameSession: GameSession_Stats?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        loadSessionData()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Session Stats"
        navigationItem.hidesBackButton = true
        
        // Configure scroll view
        scrollView.showsVerticalScrollIndicator = true
        scrollView.alwaysBounceVertical = true
        
        // Configure title label
        titleLabel.text = "Battle Session Complete!"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 28)
        titleLabel.textAlignment = .center
        titleLabel.textColor = .label
        
        // Configure session summary view
        sessionSummaryView.backgroundColor = .systemGray6
        sessionSummaryView.layer.cornerRadius = 16
        sessionSummaryView.layer.shadowColor = UIColor.black.cgColor
        sessionSummaryView.layer.shadowOffset = CGSize(width: 0, height: 2)
        sessionSummaryView.layer.shadowOpacity = 0.1
        sessionSummaryView.layer.shadowRadius = 4
        
        // Configure stats labels
        player1StatsLabel.font = UIFont.boldSystemFont(ofSize: 18)
        player1StatsLabel.textAlignment = .center
        player1StatsLabel.numberOfLines = 0
        
        player2StatsLabel.font = UIFont.boldSystemFont(ofSize: 18)
        player2StatsLabel.textAlignment = .center
        player2StatsLabel.numberOfLines = 0
        
        overallStatsLabel.font = UIFont.systemFont(ofSize: 16)
        overallStatsLabel.textAlignment = .center
        overallStatsLabel.textColor = .secondaryLabel
        overallStatsLabel.numberOfLines = 0
        
        // Configure battles header
        battlesHeaderLabel.text = "Battle History"
        battlesHeaderLabel.font = UIFont.boldSystemFont(ofSize: 20)
        battlesHeaderLabel.textColor = .label
        
        // Configure table view
        tableView.backgroundColor = .systemBackground
        tableView.separatorStyle = .singleLine
        tableView.register(BattleHistoryCell.self, forCellReuseIdentifier: "BattleHistoryCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80
        tableView.layer.cornerRadius = 12
        tableView.layer.borderWidth = 1
        tableView.layer.borderColor = UIColor.systemGray4.cgColor
        
        // Add header to indicate tappable rows
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 30))
        let headerLabel = UILabel()
        headerLabel.text = "Tap any battle for details"
        headerLabel.font = UIFont.systemFont(ofSize: 12)
        headerLabel.textColor = .secondaryLabel
        headerLabel.textAlignment = .center
        headerLabel.frame = headerView.bounds
        headerLabel.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        headerView.addSubview(headerLabel)
        tableView.tableHeaderView = headerView
        
        // Configure home button
        homeButton.setTitle("Return to Home", for: .normal)
        homeButton.backgroundColor = .systemBlue
        homeButton.setTitleColor(.white, for: .normal)
        homeButton.layer.cornerRadius = 12
        homeButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        homeButton.addTarget(self, action: #selector(homeButtonTapped), for: .touchUpInside)
        
        // Add subviews
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        [titleLabel, sessionSummaryView, battlesHeaderLabel, tableView, homeButton].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        [player1StatsLabel, player2StatsLabel, overallStatsLabel].forEach {
            sessionSummaryView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
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
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Session summary view
            sessionSummaryView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            sessionSummaryView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            sessionSummaryView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Player 1 stats
            player1StatsLabel.topAnchor.constraint(equalTo: sessionSummaryView.topAnchor, constant: 20),
            player1StatsLabel.leadingAnchor.constraint(equalTo: sessionSummaryView.leadingAnchor, constant: 20),
            player1StatsLabel.trailingAnchor.constraint(equalTo: sessionSummaryView.trailingAnchor, constant: -20),
            
            // Player 2 stats
            player2StatsLabel.topAnchor.constraint(equalTo: player1StatsLabel.bottomAnchor, constant: 15),
            player2StatsLabel.leadingAnchor.constraint(equalTo: sessionSummaryView.leadingAnchor, constant: 20),
            player2StatsLabel.trailingAnchor.constraint(equalTo: sessionSummaryView.trailingAnchor, constant: -20),
            
            // Overall stats
            overallStatsLabel.topAnchor.constraint(equalTo: player2StatsLabel.bottomAnchor, constant: 15),
            overallStatsLabel.leadingAnchor.constraint(equalTo: sessionSummaryView.leadingAnchor, constant: 20),
            overallStatsLabel.trailingAnchor.constraint(equalTo: sessionSummaryView.trailingAnchor, constant: -20),
            overallStatsLabel.bottomAnchor.constraint(equalTo: sessionSummaryView.bottomAnchor, constant: -20),
            
            // Battles header
            battlesHeaderLabel.topAnchor.constraint(equalTo: sessionSummaryView.bottomAnchor, constant: 30),
            battlesHeaderLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            battlesHeaderLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Table view
            tableView.topAnchor.constraint(equalTo: battlesHeaderLabel.bottomAnchor, constant: 15),
            tableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            tableView.heightAnchor.constraint(equalToConstant: 300),
            
            // Home button
            homeButton.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 30),
            homeButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 40),
            homeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -40),
            homeButton.heightAnchor.constraint(equalToConstant: 56),
            homeButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30)
        ])
    }
    
    private func loadSessionData() {
        guard let session = gameSession else {
            print("❌ No session data to display")
            return
        }
        
        // Update stats labels
        player1StatsLabel.text = "🔴 \(session.player1Name): \(session.player1Wins) wins"
        player2StatsLabel.text = "🔵 \(session.player2Name): \(session.player2Wins) wins"
        
        if session.ties > 0 {
            overallStatsLabel.text = "Total Battles: \(session.totalBattles)\nTies: \(session.ties)"
        } else {
            overallStatsLabel.text = "Total Battles: \(session.totalBattles)"
        }
        
        // Determine session winner
        if session.player1Wins > session.player2Wins {
            titleLabel.text = "🏆 \(session.player1Name) Wins the Session!"
        } else if session.player2Wins > session.player1Wins {
            titleLabel.text = "🏆 \(session.player2Name) Wins the Session!"
        } else {
            titleLabel.text = "🤝 Session Ended in a Tie!"
        }
        
        // Reload table view
        tableView.reloadData()
    }
    
    @objc private func homeButtonTapped() {
        // Clear only the game session data (keep user logged in)
        GameSession.shared.reset()
        
        // Navigate back to landing page (find it in the navigation stack)
        guard let navigationController = navigationController else { return }
        
        // Find the LandingPageViewController in the stack
        for viewController in navigationController.viewControllers {
            if viewController is LandingPageViewController {
                navigationController.popToViewController(viewController, animated: true)
                return
            }
        }
        
        // Fallback: if landing page not found, create a new one and replace the stack
        let landingPageVC = LandingPageViewController()
        let loginVC = navigationController.viewControllers.first // Keep login as root
        if let loginViewController = loginVC {
            navigationController.setViewControllers([loginViewController, landingPageVC], animated: true)
        }
    }
}

// MARK: - UITableViewDataSource

extension StatsPageViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gameSession?.battles.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BattleHistoryCell", for: indexPath) as! BattleHistoryCell
        
        if let battles = gameSession?.battles {
            let battle = battles[indexPath.row]
            cell.configure(with: battle, battleNumber: battles.count - indexPath.row)
        }
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension StatsPageViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let battles = gameSession?.battles else { return }
        let battle = battles[indexPath.row]
        let battleNumber = battles.count - indexPath.row
        
        // Present battle details modal
        let detailsModal = BattleDetailsModalViewController()
        detailsModal.battleResult = battle
        detailsModal.battleNumber = battleNumber
        detailsModal.modalPresentationStyle = .overFullScreen
        detailsModal.modalTransitionStyle = .crossDissolve
        present(detailsModal, animated: true)
    }
}

// MARK: - Custom Battle History Cell

class BattleHistoryCell: UITableViewCell {
    
    private let battleNumberLabel = UILabel()
    private let timestampLabel = UILabel()
    private let player1Label = UILabel()
    private let versusLabel = UILabel()
    private let player2Label = UILabel()
    private let winnerLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        selectionStyle = .default
        backgroundColor = .systemBackground
        accessoryType = .disclosureIndicator
        
        // Configure battle number label
        battleNumberLabel.font = UIFont.boldSystemFont(ofSize: 16)
        battleNumberLabel.textColor = .label
        
        // Configure timestamp label
        timestampLabel.font = UIFont.systemFont(ofSize: 12)
        timestampLabel.textColor = .secondaryLabel
        
        // Configure player labels
        player1Label.font = UIFont.systemFont(ofSize: 14)
        player1Label.textAlignment = .center
        
        versusLabel.font = UIFont.boldSystemFont(ofSize: 12)
        versusLabel.text = "VS"
        versusLabel.textColor = .secondaryLabel
        versusLabel.textAlignment = .center
        
        player2Label.font = UIFont.systemFont(ofSize: 14)
        player2Label.textAlignment = .center
        
        // Configure winner label
        winnerLabel.font = UIFont.boldSystemFont(ofSize: 14)
        winnerLabel.textAlignment = .center
        
        // Add subviews
        [battleNumberLabel, timestampLabel, player1Label, versusLabel, player2Label, winnerLabel].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Battle number
            battleNumberLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            battleNumberLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            battleNumberLabel.widthAnchor.constraint(equalToConstant: 60),
            
            // Timestamp
            timestampLabel.topAnchor.constraint(equalTo: battleNumberLabel.bottomAnchor, constant: 4),
            timestampLabel.leadingAnchor.constraint(equalTo: battleNumberLabel.leadingAnchor),
            timestampLabel.trailingAnchor.constraint(equalTo: battleNumberLabel.trailingAnchor),
            timestampLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -12),
            
            // Player 1
            player1Label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            player1Label.leadingAnchor.constraint(equalTo: battleNumberLabel.trailingAnchor, constant: 16),
            player1Label.widthAnchor.constraint(equalToConstant: 80),
            
            // VS
            versusLabel.centerYAnchor.constraint(equalTo: player1Label.centerYAnchor),
            versusLabel.leadingAnchor.constraint(equalTo: player1Label.trailingAnchor, constant: 8),
            versusLabel.widthAnchor.constraint(equalToConstant: 30),
            
            // Player 2
            player2Label.centerYAnchor.constraint(equalTo: player1Label.centerYAnchor),
            player2Label.leadingAnchor.constraint(equalTo: versusLabel.trailingAnchor, constant: 8),
            player2Label.widthAnchor.constraint(equalToConstant: 80),
            
            // Winner
            winnerLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            winnerLabel.leadingAnchor.constraint(equalTo: player2Label.trailingAnchor, constant: 16),
            winnerLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            winnerLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -12)
        ])
    }
    
    func configure(with battle: BattleResult, battleNumber: Int) {
        battleNumberLabel.text = "#\(battleNumber)"
        
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        timestampLabel.text = formatter.string(from: battle.timestamp)
        
        // Get piece emoji for display
        let piece1Emoji = GamePiece.allCases.first { $0.rawValue == battle.player1Piece }?.emoji ?? "❓"
        let piece2Emoji = GamePiece.allCases.first { $0.rawValue == battle.player2Piece }?.emoji ?? "❓"
        
        player1Label.text = "\(battle.player1Name)\n\(piece1Emoji) \(battle.player1Piece)"
        player1Label.textColor = battle.player1UIColor
        player1Label.numberOfLines = 2
        
        player2Label.text = "\(battle.player2Name)\n\(piece2Emoji) \(battle.player2Piece)"
        player2Label.textColor = battle.player2UIColor
        player2Label.numberOfLines = 2
        
        switch battle.winner {
        case "player1":
            winnerLabel.text = "🏆 \(battle.player1Name)"
            winnerLabel.textColor = battle.player1UIColor
        case "player2":
            winnerLabel.text = "🏆 \(battle.player2Name)"
            winnerLabel.textColor = battle.player2UIColor
        default:
            winnerLabel.text = "🤝 Tie"
            winnerLabel.textColor = .secondaryLabel
        }
    }
}