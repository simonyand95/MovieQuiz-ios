//
//  Movie.swift
//  MovieQuiz
//
//  Created by Диана Симонян on 26.03.2023.
//

import Foundation


struct Movie: Codable {
  let id: String
  let rank: String
  let title: String
  let fullTitle: String
  let year: String
  let image: String
  let crew: String
  let imDbRating: String
  let imDbRatingCount: String
}

struct Top: Decodable {
    let items: [Movie]
}


