//
//  MovieListTests.swift
//  MovieListTests
//
//  Created by Burak Şentürk on 16.10.2019.
//  Copyright © 2019 Burak Şentürk. All rights reserved.
//

import XCTest
@testable import MovieList

class MovieListTests: XCTestCase {

    var movieListViewModel: MovieListViewModel!

    override func setUp() {
        super.setUp()
        movieListViewModel = MovieListViewModel()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testMovieListViewModel() {

        let indexPath = IndexPath(item: 1, section: 0)

        movieListViewModel.getMovies()

        movieListViewModel.reloadCollectionView = { [weak self] () in
            guard let self = self else { return }
            XCTAssert(!self.movieListViewModel.movies.isEmpty)

            let movieDetail = self.movieListViewModel.didSelectMovie(at: indexPath)

            let movie = self.movieListViewModel.movies[indexPath.item]

            let movieDetailData = MovieListDetailViewModelData(id: movie.id,
                                                               movieImageUrl: movie.posterPath,
                                                               movieName: movie.originalTitle,
                                                               movieDescription: movie.overview,
                                                               voteCount: movie.voteCount)

            XCTAssertEqual(movieDetail.id, movieDetailData.id)
        }
    }

    func testSearchMovie() {
        movieListViewModel.query = "The Lord of The Rings"
        movieListViewModel.searchMovie()

        movieListViewModel.hideProgress = { [weak self] () in
            guard let self = self else { return }
            XCTAssertTrue(!self.movieListViewModel.movies.isEmpty)
        }
    }

    func testFavouriteMovie() {
        movieListViewModel.id = 100
        movieListViewModel.saveMovie()

        let isMovieExists = movieListViewModel.getFavouriteMovie()

        XCTAssertTrue(isMovieExists)

        movieListViewModel.removeMovie()

        let isRemovedMovie = movieListViewModel.getFavouriteMovie()

        XCTAssertFalse(isRemovedMovie)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
