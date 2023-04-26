//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Диана Симонян on 27.03.2023.
//

import Foundation
protocol StatisticService {
    
    
    func store(correct count: Int, total amount: Int, date dateRecord: Date)
    var totalAccuracy: Double { get }
    var gamesCount: Int { get }
    var bestGame: GameRecord {get set}
}



final class StatisticServiceImplementation: StatisticService {
    func store(correct count: Int, total amount: Int, date dateRecord: Date) {
    
        let recordCountCorrect = UserDefaults.standard.integer(forKey: Keys.bestGameCountCorrect.rawValue)
        let recordTotalAmount  = UserDefaults.standard.integer(forKey: Keys.bestGameTotalAmount.rawValue)
        
        let sumCorrect = UserDefaults.standard.integer(forKey: Keys.bestGameSumCorrect.rawValue) + count
        UserDefaults.standard.set(sumCorrect, forKey: Keys.bestGameSumCorrect.rawValue)
        
        
        let countAllGames = UserDefaults.standard.integer(forKey: Keys.countAllGames.rawValue)+1
        UserDefaults.standard.set(countAllGames, forKey: Keys.countAllGames.rawValue)
        
        let sumAmount = UserDefaults.standard.integer(forKey: Keys.recordSumAmount.rawValue) + amount
        UserDefaults.standard.set(sumAmount, forKey: Keys.recordSumAmount.rawValue)
        
        
        
        if recordTotalAmount == 0 || Double(count)/Double(amount) >= Double(recordCountCorrect)/Double(recordTotalAmount) {
            UserDefaults.standard.set(count, forKey: Keys.bestGameCountCorrect.rawValue)
            UserDefaults.standard.set(amount, forKey: Keys.bestGameTotalAmount.rawValue)
            UserDefaults.standard.set(dateRecord, forKey:Keys.bestGameDate.rawValue)
            
        }
            
    }
    
    var totalAccuracy: Double {
        get {
        Double(UserDefaults.standard.integer(forKey: Keys.bestGameSumCorrect.rawValue))/Double(UserDefaults.standard.integer(forKey:  Keys.recordSumAmount.rawValue))*100
    }
    }
    
    var gamesCount: Int {get {UserDefaults.standard.integer(forKey: Keys.countAllGames.rawValue)}}
    
    var bestGame: GameRecord {
            get {
                guard let data = userDefaults.data(forKey: Keys.bestGame.rawValue),
                let record = try? JSONDecoder().decode(GameRecord.self, from: data) else {
                    return .init(correct: 0, total: 0, date: Date())
                }
                
                return record
            }
            
            set {
                guard let data = try? JSONEncoder().encode(newValue) else {
                    print("Невозможно сохранить результат")
                    return
                }
                
                userDefaults.set(data, forKey: Keys.bestGame.rawValue)
            }
        }

    
    private let userDefaults = UserDefaults.standard
    
}

struct GameRecord: Codable {
    let correct: Int
    let total: Int
    let date: Date
}


enum Keys: String {
    case correct, total, bestGame, gamesCount, bestGameCountCorrect, bestGameTotalAmount, bestGameDate, bestGameSumCorrect , countAllGames, recordSumAmount
}



