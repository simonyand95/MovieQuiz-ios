//
//  AlertPresenterProtocol.swift
//  MovieQuiz
//
//  Created by Диана Симонян on 24.03.2023.
//

import Foundation
import UIKit

protocol AlertPresenterProtocol: AnyObject {
    func show(model: AlertModel)
}
