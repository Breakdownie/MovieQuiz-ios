//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Alexander Ovchinnikov on 30.09.23.
//

import Foundation

struct AlertModel {
    var title: String
    var message: String
    var buttonText: String
    let completion: (() -> Void)?
}
