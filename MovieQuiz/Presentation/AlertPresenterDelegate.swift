//
//  AlertPresenterDelegate.swift
//  MovieQuiz
//
//  Created by Диана Симонян on 29.03.2023.
//

import Foundation
import UIKit

protocol AlertPresenterDelegate: AnyObject {               // 1
    func present(_ viewControllerToPresent: UIViewController)   // 2
}
