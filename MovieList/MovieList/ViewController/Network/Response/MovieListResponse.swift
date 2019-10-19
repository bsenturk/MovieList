//
//  MovieListResponse.swift
//  MovieList
//
//  Created by Burak Şentürk on 16.10.2019.
//  Copyright © 2019 Burak Şentürk. All rights reserved.
//

import Foundation
class MovieListResponse: Decodable {
    var results: [Movie]
}

class Movie: Decodable {
    var voteCount: Int
    var id: Int
    var posterPath: String
    var originalTitle: String
    var title: String
    var overview: String

    enum CodingKeys: String, CodingKey {
        case voteCount = "vote_count", id, posterPath = "poster_path", originalTitle = "original_title", title, overview
    }
}

extension Movie: Equatable {
    static func == (lhs: Movie, rhs: Movie) -> Bool {
        return lhs.id == rhs.id
    }
}
