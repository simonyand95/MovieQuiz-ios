//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Диана Симонян on 22.03.2023.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {               // 1
    func didReceiveNextQuestion(question: QuizQuestion?)    // 2
    func didLoadDataFromServer() // сообщение об успешной загрузке
    func didFailToLoadData(with error: Error) // сообщение об ошибке загрузки
    func yesButtonClicked()
    func noButtonClicked()
    func makeResultsMessage() -> String
    func restartGame()
}
