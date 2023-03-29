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
        let recordCountCorrect = UserDefaults.standard.integer(forKey: "recordCountCorrect")
        let recordTotalAmount  = UserDefaults.standard.integer(forKey: "recordTotalAmount")
        let sumCorrect = UserDefaults.standard.integer(forKey: "recordSumCorrect") + count
        UserDefaults.standard.set(sumCorrect, forKey: "recordSumCorrect")
        
        
        let countAllGames = UserDefaults.standard.integer(forKey: "countAllGames")+1
        UserDefaults.standard.set(countAllGames, forKey: "countAllGames")
        
        let sumAmount = UserDefaults.standard.integer(forKey: "recordSumAmount") + amount
        UserDefaults.standard.set(sumAmount, forKey: "recordSumAmount")
        
        if recordTotalAmount == 0 {
            UserDefaults.standard.set(count, forKey: "recordCountCorrect")
            UserDefaults.standard.set(amount, forKey: "recordTotalAmount")
            UserDefaults.standard.set(dateRecord, forKey: "recordDate")
            
        } else {
                if count/amount >= recordCountCorrect/recordTotalAmount {
                    UserDefaults.standard.set(count, forKey: "recordCountCorrect")
                    UserDefaults.standard.set(amount, forKey: "recordTotalAmount")
                    UserDefaults.standard.set(dateRecord, forKey: "recordDate")
                }
            }
    }
    
    var totalAccuracy: Double {
        get {
        Double(UserDefaults.standard.integer(forKey: "recordSumCorrect"))/Double(UserDefaults.standard.integer(forKey: "recordSumAmount"))*100
    }
    }
    
    var gamesCount: Int {get {UserDefaults.standard.integer(forKey: "countAllGames")}}
    
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


private enum Keys: String {
    case correct, total, bestGame, gamesCount
}



