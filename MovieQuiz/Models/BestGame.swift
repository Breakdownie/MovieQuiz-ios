//
//  BestGame.swift
//  MovieQuiz
//
//  Created by Alexander Ovchinnikov on 01.10.23.
//

import Foundation

struct BestGame: Codable {
    let correctAnswers: Int
    let totalAnswers: Int
    let date: Date
}


extension BestGame: Comparable {
    
    private var accuracy: Double {
        if totalAnswers == 0  {
            return 0
        }
        return Double(correctAnswers) / Double(totalAnswers)
    }
    
    static func < (lhs: BestGame, rhs: BestGame) -> Bool {
        lhs.accuracy < rhs.accuracy
    }
}
