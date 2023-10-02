//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Alexander Ovchinnikov on 30.09.23.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(_ question: QuizQuestion?)
}
