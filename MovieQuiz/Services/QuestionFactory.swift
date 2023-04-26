//
//  File.swift
//  MovieQuiz
//
//  Created by Диана Симонян on 25.02.2023.
//

import Foundation

class QuestionFactory: QuestionFactoryProtocol {
    
    
    private let moviesLoader: MoviesLoading
        private weak var delegate: QuestionFactoryDelegate?

        init(moviesLoader: MoviesLoading, delegate: QuestionFactoryDelegate?) {
            self.moviesLoader = moviesLoader
            self.delegate = delegate
        }

 
    private var movies: [MostPopularMovie] = []
    
    func loadData() {
        moviesLoader.loadMovies { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                switch result {
                case .success(let mostPopularMovies):
                    self.movies = mostPopularMovies.items // сохраняем фильм в нашу новую переменную
                    self.delegate?.didLoadDataFromServer() // сообщаем, что данные загрузились
                case .failure(let error):
                    self.delegate?.didFailToLoadData(with: error) // сообщаем об ошибке нашему MovieQuizViewController
                }
                    }
                }
      }

    
    func requestNextQuestion() {
        DispatchQueue.global().async { [weak self] in
                guard let self = self else { return }
                let index = (0..<self.movies.count).randomElement() ?? 0
                
                guard let movie = self.movies[safe: index] else { return }
                
                var imageData = Data()

                do {
                   imageData = try Data(contentsOf: movie.resizedImageURL)
                } catch {
                    print("Failed to load image")
                }
                let rating = Float(movie.rating) ?? 0
                let ratingIndex = (3..<9).randomElement() ?? 0
                
                let text = "Рейтинг этого фильма больше чем \(ratingIndex)?"
                let correctAnswer = rating > Float(ratingIndex)
                
                let question = QuizQuestion(image: imageData,
                                             text: text,
                                             correctAnswer: correctAnswer)
                
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.delegate?.didReceiveNextQuestion(question: question)
                }
            }
        }
    
    }

