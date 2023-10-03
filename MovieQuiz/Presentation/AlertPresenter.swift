//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Alexander Ovchinnikov on 30.09.23.
//

import UIKit

final class AlertPresenter {
    private weak var controller: UIViewController?
    
    init(controller: UIViewController) {
        self.controller = controller
    }
    
    func show(model: AlertModel) {
        guard let controller = controller else { return }
        let alert = UIAlertController(title: model.title, message: model.message, preferredStyle: .alert)
        let action = UIAlertAction(title: model.buttonText, style: .default) { _ in
            model.completion?()
        }
        alert.addAction(action)
        controller.present(alert, animated: true, completion: nil)
    }
}


