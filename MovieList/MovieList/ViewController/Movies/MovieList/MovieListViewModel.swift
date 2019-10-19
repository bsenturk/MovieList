//
//  MovieListViewModel.swift
//  MovieList
//
//  Created by Burak Şentürk on 16.10.2019.
//  Copyright © 2019 Burak Şentürk. All rights reserved.
//

import Foundation

class MovieListViewModel {

    var movies: [Movie] = [] {
        didSet {
            self.reloadCollectionView?()
            self.hideProgress?()
        }
    }

    var searchedMovies: [Movie] = []

    var moviesCount: Int {
        return movies.count
    }

    var id: Int = 0
    var page: Int = 1
    var query: String = ""

    var reloadCollectionView: (() -> ())?
    var showProgress: (()->())?
    var hideProgress: (()->())?

    func didSelectMovie(at indexPath: IndexPath) -> MovieListDetailViewModelData {
        let movie = movies[indexPath.item]
        let movieImageUrl = movie.posterPath
        let movieName = movie.originalTitle
        let movieDescription = movie.overview
        let voteCount = movie.voteCount
        let id = movie.id
        
        return MovieListDetailViewModelData(id: id,
                                            movieImageUrl: movieImageUrl,
                                            movieName: movieName,
                                            movieDescription: movieDescription, voteCount: voteCount)
    }

    func getMovies() {

        showProgress?()

        let urlParameters = ["language": "en-US",
                             "api_key": EndPoints.apiKey,
                             "page": "\(page)"]

        BaseRequest.request(path: EndPoints.movies,
                            method: .get,
                            urlParameters: urlParameters,
                            succeed: parseMovies)
        page += 1
    }

    func parseMovies(_ response: MovieListResponse) {
        movies.append(contentsOf: response.results)
        searchedMovies.append(contentsOf: response.results)
    }

    func searchMovie() {

        showProgress?()

       let replacingQuery = query.replacingOccurrences(of: " ", with: "+")

        let urlParameters = ["api_key": EndPoints.apiKey,
                             "query": replacingQuery]

        BaseRequest.request(path: "",
                            method: .get,
                            baseUrl: EndPoints.searchUrl,
                            urlParameters: urlParameters,
                            succeed: parseSearchMovies)
    }

    func parseSearchMovies(_ response: MovieListResponse) {
        movies = response.results
        hideProgress?()
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
