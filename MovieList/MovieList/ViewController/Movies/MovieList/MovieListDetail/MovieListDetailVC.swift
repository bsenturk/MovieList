//
//  MovieListDetailVC.swift
//  MovieList
//
//  Created by Burak Şentürk on 17.10.2019.
//  Copyright © 2019 Burak Şentürk. All rights reserved.
//

import UIKit

class MovieListDetailVC: BaseVC {

    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieDescriptionLabel: UILabel!
    @IBOutlet weak var voteCountLabel: UILabel!

    private let viewModel = MovieListDetailViewModel()
    var isFavourite: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        let backButton = UIBarButtonItem()
        backButton.title = ""
        navigationController?.navigationBar.topItem?.backBarButtonItem = backButton

        if let data = viewModelData as? MovieListDetailViewModelData {

            updateUI(imageUrlPath: data.movieImageUrl,
                     movieTitle: data.movieName,
                     movieDescription: data.movieDescription,
                     voteCount: "\(data.voteCount)")
            viewModel.id = data.id

        }

        setRightBarButtonImage()
        initializeViewModel()

    }

    func setRightBarButtonImage() {
        viewModel.getFavouriteMovie() ? setupRightBarButton(image: #imageLiteral(resourceName: "starFill")) : setupRightBarButton(image: #imageLiteral(resourceName: "star"))
    }

    func initializeViewModel() {
        viewModel.updateRightBarButtonImage = { [weak self] () in
            self?.setRightBarButtonImage()
        }
    }

    func updateUI(imageUrlPath: String,
                  movieTitle: String,
                  movieDescription: String,
                  voteCount: String) {
        guard let url = URL(string: EndPoints.imageUrl + imageUrlPath) else { return }
        movieImageView.sd_setImage(with: url)

        movieTitleLabel.text = movieTitle

        movieDescriptionLabel.text = movieDescription

        voteCountLabel.text = "Vote Count: \(voteCount)"
    }

    override func rightBarButtonAction() {
        super.rightBarButtonAction()
        viewModel.favouriteButtonTapped()
    }

}
