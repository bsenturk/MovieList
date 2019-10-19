//
//  MovieListCell.swift
//  MovieList
//
//  Created by Burak Şentürk on 16.10.2019.
//  Copyright © 2019 Burak Şentürk. All rights reserved.
//

import UIKit
import SDWebImage

protocol FavouriteActionDelegate: class {
    func didTappedFavoriteButton(id: Int, index: Int)
}

class MovieListCell: UICollectionViewCell {

    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var favouriteButton: UIButton!

    weak var delegate: FavouriteActionDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    var movie: Movie? {
        didSet {
            configureView()
        }
    }

    func configureView() {
        guard let movie = movie else { return }
        movieTitleLabel.text = movie.title
        let isFavourite = UserDefaults.standard.bool(forKey: "\(movie.id)")
        favouriteButton.isHidden = !isFavourite
        guard let url = URL(string: EndPoints.imageUrl + movie.posterPath) else { return }
        movieImageView.sd_setImage(with: url)
    }

    @IBAction func favouriteButtonAction(_ sender: UIButton) {
        guard let movie = movie else { return }
        self.delegate?.didTappedFavoriteButton(id: movie.id, index: sender.tag)
    }

    func setCornerRadius(viewType: Bool) {
        if viewType {
            self.layer.cornerRadius = 8
        } else {
            self.layer.cornerRadius = 0
        }
    }

}
