//
//  MovieListDetailViewModel.swift
//  MovieList
//
//  Created by Burak Şentürk on 17.10.2019.
//  Copyright © 2019 Burak Şentürk. All rights reserved.
//

import Foundation

class MovieListDetailViewModelData: NSObject {
    var id: Int
    var movieImageUrl: String
    var movieName: String
    var movieDescription: String
    var voteCount: Int

    init(id: Int,
         movieImageUrl: String,
         movieName: String,
         movieDescription: String,
         voteCount: Int) {
        self.id = id
        self.movieImageUrl = movieImageUrl
        self.movieName = movieName
        self.movieDescription = movieDescription
        self.voteCount = voteCount
    }
}

class MovieListDetailViewModel {
    var id: Int = 0
    var updateRightBarButtonImage: (()->())?

    func favouriteButtonTapped() {
        getFavouriteMovie() ? removeMovie() : saveMovie()
        self.updateRightBarButtonImage?()
    }

    func getFavouriteMovie() -> Bool {
        return UserDefaults.standard.bool(forKey: "\(id)")
    }

    func saveMovie() {
        UserDefaults.standard.set(true, forKey: "\(id)")
    }

    func removeMovie() {
        UserDefaults.standard.removeObject(forKey: "\(id)")
    }
    
}
