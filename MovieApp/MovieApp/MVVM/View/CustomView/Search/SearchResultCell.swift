//
//  SearchResultCell.swift
//  MovieApp
//
//  Created by Ketan on 1/7/19.
//  Copyright © 2019 Ketan. All rights reserved.
//

import UIKit
import FloatRatingView

class SearchResultCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblAvg: UILabel!
    @IBOutlet weak var lblAge: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var ivImage: UIImageView!
    @IBOutlet weak var viewRating: FloatRatingView!
    @IBOutlet weak var btnBuyTicket: UIButton!
    
    var movieObject : MovieObject!{
        didSet{
            self.lblTitle.text = movieObject.strTitle
            self.lblAvg.text = "\(movieObject.rating!)"
            self.lblAge.text = movieObject.strAge
            self.lblDesc.text = movieObject.strDesc
            self.lblDate.text = movieObject.strReleaseDate
            self.ivImage.sd_setImage(with: movieObject.urlImagePath, completed: nil)
            
            self.viewRating.rating = (movieObject.rating ?? 0)/2
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        btnBuyTicket.layer.cornerRadius = btnBuyTicket.frame.size.height/2
        ivImage.layer.cornerRadius = 8
        lblAge.layer.cornerRadius = lblAge.frame.size.height/2
        lblAge.layer.borderColor = UIColor.darkGray.cgColor
        lblAge.layer.borderWidth = 1
        
        viewRating.backgroundColor = UIColor.clear
        viewRating.contentMode = UIView.ContentMode.scaleAspectFit
        viewRating.type = .halfRatings
        viewRating.isUserInteractionEnabled = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
