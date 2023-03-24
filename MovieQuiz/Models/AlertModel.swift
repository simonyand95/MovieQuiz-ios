//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Диана Симонян on 23.03.2023.
//

import Foundation
struct AlertModel {
        let title: String
        let message: String
        let buttonText: String
        let completion: (() -> Void)?
    }
 
