//
//  BattleStatsManager.swift
//  Games of the General Arbiter
//
//  Created by Alpha Giel De Asis on 8/30/25.
//

import Foundation
import UIKit

// MARK: - Battle Stats Models

struct BattleResult: Codable {
    let id = UUID()
    let player1Name: String
    let player1Color: String // Store as hex string
    let player1Piece: String
    let player2Name: String
    let player2Color: String // Store as hex string
    let player2Piece: String
    let winner: String // "player1", "player2", or "tie"
    let timestamp: Date
    
    init(player1: Player, player2: Player, result: GameResult) {
        self.player1Name = player1.name
        self.player1Color = player1.color.toHexString()
        self.player1Piece = player1.selectedPiece?.rawValue ?? "Unknown"
        self.player2Name = player2.name
        self.player2Color = player2.color.toHexString()
        self.player2Piece = player2.selectedPiece?.rawValue ?? "Unknown"
        
        switch result {
        case .player1Wins:
            self.winner = "player1"
        case .player2Wins:
            self.winner = "player2"
        case .tie:
            self.winner = "tie"
        }
        
        self.timestamp = Date()
    }
    
    var winnerName: String {
        switch winner {
        case "player1":
            return player1Name
        case "player2":
            return player2Name
        default:
            return "Tie"
        }
    }
    
    var player1UIColor: UIColor {
        return UIColor(hexString: player1Color) ?? .systemBlue
    }
    
    var player2UIColor: UIColor {
        return UIColor(hexString: player2Color) ?? .systemRed
    }
}

struct GameSession_Stats: Codable {
    let sessionId = UUID()
    let player1Name: String
    let player2Name: String
    let startTime: Date
    var battles: [BattleResult]
    var endTime: Date?
    
    init(player1Name: String, player2Name: String) {
        self.player1Name = player1Name
        self.player2Name = player2Name
        self.startTime = Date()
        self.battles = []
    }
    
    var player1Wins: Int {
        return battles.filter { $0.winner == "player1" }.count
    }
    
    var player2Wins: Int {
        return battles.filter { $0.winner == "player2" }.count
    }
    
    var ties: Int {
        return battles.filter { $0.winner == "tie" }.count
    }
    
    var totalBattles: Int {
        return battles.count
    }
}

// MARK: - Local Storage Manager

class BattleStatsManager {
    static let shared = BattleStatsManager()
    private let userDefaults = UserDefaults.standard
    private let currentSessionKey = "current_game_session"
    private let allSessionsKey = "all_game_sessions"
    
    private init() {}
    
    // MARK: - Current Session Management
    
    func startNewSession(player1Name: String, player2Name: String) {
        let session = GameSession_Stats(player1Name: player1Name, player2Name: player2Name)
        saveCurrentSession(session)
        print("📊 Started new session: \(player1Name) vs \(player2Name)")
    }
    
    func getCurrentSession() -> GameSession_Stats? {
        guard let data = userDefaults.data(forKey: currentSessionKey) else { return nil }
        return try? JSONDecoder().decode(GameSession_Stats.self, from: data)
    }
    
    func addBattleResult(player1: Player, player2: Player, result: GameResult) {
        guard var session = getCurrentSession() else {
            print("❌ No current session to add battle result")
            return
        }
        
        let battle = BattleResult(player1: player1, player2: player2, result: result)
        session.battles.append(battle)
        saveCurrentSession(session)
        
        print("⚔️ Battle added: \(battle.player1Name)(\(battle.player1Piece)) vs \(battle.player2Name)(\(battle.player2Piece)) - Winner: \(battle.winnerName)")
    }
    
    func endCurrentSession() -> GameSession_Stats? {
        guard var session = getCurrentSession() else { return nil }
        
        session.endTime = Date()
        
        // Save to all sessions history
        saveSessionToHistory(session)
        
        // Clear current session
        userDefaults.removeObject(forKey: currentSessionKey)
        
        print("📊 Session ended: \(session.totalBattles) battles, \(session.player1Name): \(session.player1Wins) wins, \(session.player2Name): \(session.player2Wins) wins, Ties: \(session.ties)")
        
        return session
    }
    
    private func saveCurrentSession(_ session: GameSession_Stats) {
        if let data = try? JSONEncoder().encode(session) {
            userDefaults.set(data, forKey: currentSessionKey)
        }
    }
    
    // MARK: - Session History Management
    
    func getAllSessions() -> [GameSession_Stats] {
        guard let data = userDefaults.data(forKey: allSessionsKey),
              let sessions = try? JSONDecoder().decode([GameSession_Stats].self, from: data) else {
            return []
        }
        return sessions.sorted { $0.startTime > $1.startTime } // Most recent first
    }
    
    private func saveSessionToHistory(_ session: GameSession_Stats) {
        var allSessions = getAllSessions()
        allSessions.append(session)
        
        if let data = try? JSONEncoder().encode(allSessions) {
            userDefaults.set(data, forKey: allSessionsKey)
        }
    }
    
    // MARK: - Utility
    
    func clearAllData() {
        userDefaults.removeObject(forKey: currentSessionKey)
        userDefaults.removeObject(forKey: allSessionsKey)
        print("🗑️ All battle stats data cleared")
    }
}

// MARK: - UIColor Extensions

extension UIColor {
    func toHexString() -> String {
        guard let components = cgColor.components, components.count >= 3 else {
            return "#000000"
        }
        
        let r = Float(components[0])
        let g = Float(components[1])
        let b = Float(components[2])
        
        return String(format: "#%02lX%02lX%02lX",
                     lroundf(r * 255),
                     lroundf(g * 255),
                     lroundf(b * 255))
    }
    
    convenience init?(hexString: String) {
        var hexSanitized = hexString.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        
        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else { return nil }
        
        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}