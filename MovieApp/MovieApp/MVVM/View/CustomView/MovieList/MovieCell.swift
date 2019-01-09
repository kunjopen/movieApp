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
    @IBOutlet weak var btnBuyTicket: UIButton!
    @IBOutlet weak var ivImage: UIImageView!
    @IBOutlet weak var lblPreSale: UILabel!
    @IBOutlet weak var bgView: UIView!
    
    var movieObject : MovieObject!{
        didSet{
            self.ivImage.sd_setImage(with: movieObject.urlImagePath, completed: nil)
            self.lblPreSale.isHidden = movieObject.isPreSeal!
        }
    }
    
    override func awakeFromNib() {
        bgView.layer.cornerRadius = 10
        lblPreSale.layer.cornerRadius = 9
    }
}
