//
//  GameModels.swift
//  Games of the General Arbiter
//
//  Created by Alpha Giel De Asis on 8/30/25.
//

import UIKit

// MARK: - Game Models

class Player {
    let name: String
    let color: UIColor
    var selectedPiece: GamePiece?
    var pieceInventory: [GamePiece: Int]
    
    init(name: String, color: UIColor, selectedPiece: GamePiece? = nil) {
        self.name = name
        self.color = color
        self.selectedPiece = selectedPiece
        
        // Initialize inventory with standard Salpakan piece counts
        self.pieceInventory = [:]
        for piece in GamePiece.allCases {
            self.pieceInventory[piece] = piece.initialCount
        }
    }
    
    func remainingCount(for piece: GamePiece) -> Int {
        return pieceInventory[piece] ?? 0
    }
    
    func canUsePiece(_ piece: GamePiece) -> Bool {
        return remainingCount(for: piece) > 0
    }
    
    func usePiece(_ piece: GamePiece) -> Bool {
        guard canUsePiece(piece) else { return false }
        pieceInventory[piece] = (pieceInventory[piece] ?? 0) - 1
        return true
    }
    
    func restorePiece(_ piece: GamePiece) {
        pieceInventory[piece] = (pieceInventory[piece] ?? 0) + 1
    }
    
    var totalRemainingPieces: Int {
        return pieceInventory.values.reduce(0, +)
    }
    
    var availablePieces: [GamePiece] {
        return GamePiece.allCases.filter { canUsePiece($0) }
    }
}

enum GamePiece: String, CaseIterable {
    case fiveStarGeneral = "Five-Star General"
    case fourStarGeneral = "Four-Star General"
    case threeStarGeneral = "Three-Star General"
    case twoStarGeneral = "Two-Star General"
    case oneStarGeneral = "One-Star General"
    case colonel = "Colonel"
    case lieutenantColonel = "Lieutenant Colonel"
    case major = "Major"
    case captain = "Captain"
    case firstLieutenant = "1st Lieutenant"
    case secondLieutenant = "2nd Lieutenant"
    case sergeant = "Sergeant"
    case `private` = "Private"
    case spy = "Spy"
    case flag = "Flag"
    
    var emoji: String {
        switch self {
        case .fiveStarGeneral: return "⭐"
        case .fourStarGeneral: return "🌟"
        case .threeStarGeneral: return "✨"
        case .twoStarGeneral: return "🔸"
        case .oneStarGeneral: return "🔹"
        case .colonel: return "🎖️"
        case .lieutenantColonel: return "🏅"
        case .major: return "🎗️"
        case .captain: return "👨‍✈️"
        case .firstLieutenant: return "🥇"
        case .secondLieutenant: return "🥈"
        case .sergeant: return "⚡"
        case .private: return "🔫"
        case .spy: return "🕵️"
        case .flag: return "🚩"
        }
    }
    
    var rank: Int {
        switch self {
        case .fiveStarGeneral: return 15
        case .fourStarGeneral: return 14
        case .threeStarGeneral: return 13
        case .twoStarGeneral: return 12
        case .oneStarGeneral: return 11
        case .colonel: return 10
        case .lieutenantColonel: return 9
        case .major: return 8
        case .captain: return 7
        case .firstLieutenant: return 6
        case .secondLieutenant: return 5
        case .sergeant: return 4
        case .private: return 3
        case .spy: return 2
        case .flag: return 1
        }
    }
    
    var initialCount: Int {
        switch self {
        case .fiveStarGeneral, .fourStarGeneral, .threeStarGeneral, .twoStarGeneral, .oneStarGeneral,
             .colonel, .lieutenantColonel, .major, .captain, .firstLieutenant, .secondLieutenant,
             .sergeant, .flag:
            return 1
        case .private:
            return 6
        case .spy:
            return 2
        }
    }
    
    var description: String {
        switch self {
        case .fiveStarGeneral: return "Highest ranking officer - defeats all except Spy"
        case .fourStarGeneral: return "High ranking officer - defeats most pieces"
        case .threeStarGeneral: return "Senior officer - strong command authority"
        case .twoStarGeneral: return "Field officer - experienced commander"
        case .oneStarGeneral: return "Junior general - tactical leader"
        case .colonel: return "Senior field officer"
        case .lieutenantColonel: return "Deputy commander"
        case .major: return "Battalion commander"
        case .captain: return "Company commander"
        case .firstLieutenant: return "Platoon leader"
        case .secondLieutenant: return "Junior officer"
        case .sergeant: return "Non-commissioned officer"
        case .private: return "Basic soldier - can only defeat Spy"
        case .spy: return "Special agent - defeats all officers"
        case .flag: return "Victory objective - protect at all costs"
        }
    }
}

enum GameResult {
    case player1Wins
    case player2Wins
    case tie
}

// MARK: - Game Colors

struct GameColors {
    static let availableColors: [(name: String, color: UIColor)] = [
        ("Red", .systemRed),
        ("Blue", .systemBlue),
        ("Green", .systemGreen),
        ("Yellow", .systemYellow),
        ("Purple", .systemPurple),
        ("Orange", .systemOrange)
    ]
}

// MARK: - Game Logic

class GameLogic {
    static func determineWinner(player1: Player, player2: Player) -> GameResult {
        guard let piece1 = player1.selectedPiece,
              let piece2 = player2.selectedPiece else {
            return .tie
        }
        
        // Same pieces result in both being eliminated (tie)
        if piece1 == piece2 {
            return .tie
        }
        
        let player1Wins = doesPiece(piece1, beat: piece2)
        return player1Wins ? .player1Wins : .player2Wins
    }
    
    private static func doesPiece(_ attacker: GamePiece, beat defender: GamePiece) -> Bool {
        // Special cases for Spy
        if attacker == .spy {
            // Spy defeats all officers (Sergeant to Five-Star General)
            return defender.rank >= 4 && defender != .spy && defender != .flag
        }
        
        if attacker == .private {
            // Private can only defeat Spy
            return defender == .spy
        }
        
        if attacker == .flag {
            // Flag cannot defeat anyone in battle
            return false
        }
        
        // For all other pieces, higher rank defeats lower rank
        // Exception: Spy defeats officers, Private defeats Spy
        if defender == .spy {
            return attacker == .private
        }
        
        if defender == .flag {
            // Anyone can defeat the Flag
            return true
        }
        
        // Normal rank-based combat
        return attacker.rank > defender.rank
    }
}

// MARK: - Game Session Manager

class GameSession {
    static let shared = GameSession()
    
    var player1: Player?
    var player2: Player?
    
    private init() {}
    
    func reset() {
        player1 = nil
        player2 = nil
    }
    
    func startNewRound() {
        player1?.selectedPiece = nil
        player2?.selectedPiece = nil
    }
}