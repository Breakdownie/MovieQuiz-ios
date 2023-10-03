//
//  QuestionFactoryProtocol.swift
//  MovieQuiz
//
//  Created by Alexander Ovchinnikov on 30.09.23.
//

import Foundation

protocol QuestionFactoryProtocol {
    var delegate: QuestionFactoryDelegate? { get set }
    
    func requestNextQuestion()
}
