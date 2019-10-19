//
//  BaseVC.swift
//  MovieList
//
//  Created by Burak Şentürk on 16.10.2019.
//  Copyright © 2019 Burak Şentürk. All rights reserved.
//

import UIKit
class BaseVC: UIViewController {

    let screenWidth = UIScreen.main.bounds.size.width
    let screenHeight = UIScreen.main.bounds.size.height
    var viewModelData: AnyObject?
    let activityIndicator = UIActivityIndicatorView(style: .large)
    let progressView = UIView()

    func setupNavigationBar(title: String, image: UIImage) {
        navigationItem.title = title
        
        setupRightBarButton(image: image)
    }

    func setupRightBarButton(image: UIImage) {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image,
                                                                  style: .plain,
                                                                  target: self,
                                                                  action: #selector(rightBarButtonAction))
    }

    @objc func rightBarButtonAction() {

    }

    func showProgress() {
        progressView.frame = CGRect(x: 0,
                                    y: 0,
                                    width: 100,
                                    height: 100)
        progressView.backgroundColor = .lightGray
        progressView.layer.cornerRadius = 8
        progressView.center = view.center
        view.addSubview(progressView)

        activityIndicator.hidesWhenStopped = true

        progressView.addSubview(activityIndicator)
        activityIndicator.center = CGPoint(x: progressView.bounds.midX, y: progressView.bounds.midY)
        activityIndicator.startAnimating()
    }

    func hideProgress() {
        progressView.removeFromSuperview()
        activityIndicator.stopAnimating()
    }
}
