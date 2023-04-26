//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Диана Симонян on 24.04.2023.
//

import Foundation

import UIKit


final class MovieQuizPresenter {
        let questionsAmount: Int = 10
        private var currentQuestionIndex: Int = 0
        var currentQuestion: QuizQuestion?
        weak var viewController: MovieQuizViewController?
        
        func isLastQuestion() -> Bool {
            currentQuestionIndex == questionsAmount - 1
        }
        
        func resetQuestionIndex() {
            currentQuestionIndex = 0
        }
        
        func switchToNextQuestion() {
            currentQuestionIndex += 1
        }

    func convert(model: QuizQuestion) -> QuizStepViewModel {
       return QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
    

    
    func yesButtonClicked(){
        didAnswer(isYes: true)
    }
    
    
    func noButtonClicked() {
        didAnswer(isYes: false)
        }
    
    
    private func didAnswer(isYes: Bool) {
           guard let currentQuestion = currentQuestion else {
               return
           }
           
           let givenAnswer = isYes
           
           viewController?.showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
       }
    
    
    
    func didRecieveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.show(quiz: viewModel)
        }
        }
    
    
    
    private func showNextQuestionOrResults() {
        
        let competion: (() -> Void) =  {
         self.allAmountOfCorrectAnswers = 0
         self.presenter.resetQuestionIndex()
         self.questionFactory?.requestNextQuestion()
         self.makeButtonsActive()
             }

        
        if self.isLastQuestion() {
            statisticServiceImplementation!.store(correct: allAmountOfCorrectAnswers, total: presenter.questionsAmount, date: Date())
            let dateFormatterPrint = DateFormatter()
            dateFormatterPrint.dateFormat = "dd.MM.YY hh:mm"
           
            statisticServiceImplementation!.bestGame = GameRecord(correct: UserDefaults.standard.integer(forKey:  Keys.bestGameCountCorrect.rawValue),
                                                                  total:
                                                                    UserDefaults.standard.integer(forKey: Keys.bestGameTotalAmount.rawValue),
                                                                  date:  UserDefaults.standard.object(forKey: Keys.bestGameDate.rawValue) as! Date)
            

            let thisBestGame = statisticServiceImplementation!.bestGame
            
            
            let alertModel = AlertModel(title: "Этот раунд окончен!",
                                        message: "Ваш результат: \(allAmountOfCorrectAnswers) из \(presenter.questionsAmount) \n Количество сыгранных квизов: \(String(describing: statisticServiceImplementation!.gamesCount))  \n Рекорд: \(String(describing: thisBestGame.correct)) / \(String(describing: thisBestGame.total)) (\(dateFormatterPrint.string(from: thisBestGame.date)) ) \n Средняя точность: \(String(format: "%.2f", statisticServiceImplementation!.totalAccuracy))%",
                                        buttonText: "Сыграть ещё раз",
                                        completion: competion)
            alertPresenter?.show(model: alertModel)
            
        } else {
            makeButtonsActive()
            presenter.switchToNextQuestion()
            // увеличиваем индекс текущего урока на 1; таким образом мы сможем получить следующий урок
            questionFactory?.requestNextQuestion()
            // показать следующий вопрос
        }
    }
    
}
