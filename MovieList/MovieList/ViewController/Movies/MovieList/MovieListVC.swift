//
//  MovieListVC.swift
//  MovieList
//
//  Created by Burak Şentürk on 16.10.2019.
//  Copyright © 2019 Burak Şentürk. All rights reserved.
//

import UIKit
class MovieListVC: BaseVC, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.register(MovieListCell.self)
            collectionView.delegate = self
            collectionView.dataSource = self
        }
    }

    private let viewModel = MovieListViewModel()

    var isGrid: Bool = false
    var isSearch: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar(title: "Contents", image: #imageLiteral(resourceName: "grid"))
        initializeViewModel()
        addSearchBar()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }

    private func initializeViewModel() {
        viewModel.getMovies()
        viewModel.reloadCollectionView = { [weak self] () in
            self?.collectionView.reloadData()
        }

        viewModel.showProgress = { [weak self] () in
            self?.showProgress()
        }

        viewModel.hideProgress = { [weak self] () in
            self?.hideProgress()
        }
    }

    @objc func handleRefreshPage() {

    }

    func addSearchBar() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
    }

    override func rightBarButtonAction() {
        super.rightBarButtonAction()
        isGrid = !isGrid
        isGrid ? setupRightBarButton(image: #imageLiteral(resourceName: "list")) : setupRightBarButton(image: #imageLiteral(resourceName: "grid"))
        collectionView.reloadData()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.moviesCount
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieListCell",
                                                      for: indexPath) as! MovieListCell
        cell.setCornerRadius(viewType: isGrid)
        cell.favouriteButton.tag = indexPath.item
        cell.delegate = self
        cell.movie = viewModel.movies[indexPath.item]
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let gridSize = CGSize(width: (screenWidth - 12 - 20) / 2, height: 300)
        let listSize = CGSize(width: screenWidth, height: 400)
        return isGrid ? gridSize : listSize
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return isGrid ? UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10) : UIEdgeInsets.zero
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == viewModel.movies.count - 1 {
            viewModel.getMovies()
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movieListDetailVC = MovieListDetailVC()
        movieListDetailVC.viewModelData = viewModel.didSelectMovie(at: indexPath)
        navigationController?.pushViewController(movieListDetailVC, animated: true)
    }
}
//Protocols
extension MovieListVC: FavouriteActionDelegate {
    func didTappedFavoriteButton(id: Int, index: Int) {
        viewModel.id = id
        let isFavourite = viewModel.getFavouriteMovie()
        isFavourite ? viewModel.removeMovie() : viewModel.saveMovie()
        let indexPath = IndexPath(item: index, section: 0)
        collectionView.reloadItems(at: [indexPath])
    }

}
//Search
extension MovieListVC: UISearchResultsUpdating, UISearchBarDelegate {

    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        if text != "" && isSearch {
            viewModel.query = text
            viewModel.searchMovie()
        }
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.movies = viewModel.searchedMovies
        isSearch = false
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if viewModel.movies != viewModel.searchedMovies {
            searchBar.text = viewModel.query
        }
        isSearch = false
        DispatchQueue.main.async {
            self.hideProgress()
        }
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
        viewModel.movies = viewModel.searchedMovies
        }
       isSearch = true
    }
    
}
