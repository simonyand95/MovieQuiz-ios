//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Диана Симонян on 23.03.2023.
//

import Foundation
import UIKit


class AlertPresenter: AlertPresenterProtocol {
    weak var vc: UIViewController?
    
    init(vc: UIViewController?) {
        self.vc = vc
    }
    
    func show(model: AlertModel) {
        let alert = UIAlertController(
            title: model.title,
            message: model.message,
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: model.buttonText,
                                   style: .default,
                                   handler: { _ in
            model.completion?()
        }
)
        
        alert.addAction(action)
        vc?.present(alert, animated: true)
    }
    
}
