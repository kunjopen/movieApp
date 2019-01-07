//
//  MovieCell.swift
//  MovieApp
//
//  Created by Ketan on 1/4/19.
//  Copyright © 2019 Ketan. All rights reserved.
//

import UIKit

class MovieCell: UICollectionViewCell {
    
    //MARK:- IBOutlet
    @IBOutlet weak var ivImage: UIImageView!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var lblPreSale: UILabel!
    @IBOutlet weak var btnBuyTicket: UIButton!
    
    override func awakeFromNib() {
        bgView.layer.cornerRadius = 10
        lblPreSale.layer.cornerRadius = 9
    }
}
