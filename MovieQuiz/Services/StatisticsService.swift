//
//  StatisticsService.swift
//  MovieQuiz
//
//  Created by Alexander Ovchinnikov on 01.10.23.
//

import Foundation

protocol StatisticsService {
    var totalAccuracy: Double { get }
    var gamesCount: Int { get }
    var bestGame: BestGame? { get }
    
    
    func store(correct: Int, total: Int)
    
}

final class StatisticsServiceImpl {
    
    private enum Keys: String {
        case correctAnswers, totalAnswers, bestGame, gamesCount
    }
    
    private let userDefaults: UserDefaults
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder
    
    
    init(userDefaults: UserDefaults = .standard,
         decoder: JSONDecoder = JSONDecoder(),
         encoder: JSONEncoder = JSONEncoder())
    {
        self.userDefaults = userDefaults
        self.decoder = decoder
        self.encoder = encoder
    }
}

extension StatisticsServiceImpl: StatisticsService {
    
    var gamesCount: Int {
        get {
            userDefaults.integer(forKey: Keys.gamesCount.rawValue)
        }
        set {
            userDefaults.setValue(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }
    
    var totalAnswers: Int {
        get {
            userDefaults.integer(forKey: Keys.totalAnswers.rawValue)
        }
        set {
            userDefaults.setValue(newValue, forKey: Keys.totalAnswers.rawValue)
        }
    }
    
    var correctAnswers: Int {
        get {
            userDefaults.integer(forKey: Keys.correctAnswers.rawValue)
        }
        set {
            userDefaults.setValue(newValue, forKey: Keys.correctAnswers.rawValue)
        }
    }
    
    var bestGame: BestGame? {
        get {
            guard
                let data = userDefaults.data(forKey: Keys.bestGame.rawValue),
                let bestGame = try? decoder.decode(BestGame.self, from: data) else {
                return nil
            }
            return bestGame
        }
        set {
            let data = try? encoder.encode(newValue)
            userDefaults.set(data, forKey: Keys.bestGame.rawValue)
        }
    }
    
    var totalAccuracy: Double {
        return Double(correctAnswers) / Double(totalAnswers) * 100
    }
    
    
    func store(correct: Int, total: Int) {
        self.correctAnswers += correct
        self.totalAnswers += total
        self.gamesCount += 1
        
        let currentBestGame = BestGame(correctAnswers: correct, totalAnswers: total, date: Date())
        
        if let previousBestGame = bestGame  {
            if currentBestGame > previousBestGame {
                bestGame = currentBestGame
            }
        } else {
            bestGame = currentBestGame
        }
    }
}
