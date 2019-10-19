//
//  UICollectionView+Extensions.swift
//  MovieList
//
//  Created by Burak Şentürk on 16.10.2019.
//  Copyright © 2019 Burak Şentürk. All rights reserved.
//

import UIKit
extension UICollectionView {
    func register<T: UICollectionViewCell>(_ type: T.Type) {
        let name = String(describing: type).components(separatedBy: ".")[0]
        register(UINib(nibName: name, bundle: nil),
                 forCellWithReuseIdentifier: name)
    }
}
