//
//  NSObjectExtension.swift
//  MovieApp
//
//  Created by Ketan on 1/9/19.
//  Copyright © 2019 Ketan. All rights reserved.
//

import UIKit

extension UITableView {
    /// Register a XIB file with UITableView
    internal func registerNib(_ nibName: String) {
        let cellNib = UINib.init(nibName: nibName, bundle: nil)
        register(cellNib, forCellReuseIdentifier: nibName)
    }
}

extension UICollectionView {
    /// use to register nibs in view
    internal func registerNib(_ nibName: String) {
        let cellNib = UINib.init(nibName: nibName, bundle: nil)
        register(cellNib, forCellWithReuseIdentifier: nibName)
    }
}
