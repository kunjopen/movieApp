//
//  LoadMore.swift
//  MovieApp
//
//  Created by Ketan on 1/7/19.
//  Copyright © 2019 Ketan. All rights reserved.
//

import UIKit

class LoadMore: NSObject {

    static let sharedInstance = LoadMore()
    
    var footerView:UIView!
    
    // MARK: - LoadMore
    
    func showLoadingInTable(tbl: UITableView, text:String) {
        DispatchQueue.main.async {
            tbl.tableFooterView = self.footerView
        }
    }
    
    func hideLoadingInTable(tbl: UITableView) {
        DispatchQueue.main.async {
            tbl.tableFooterView = nil
        }
    }
    
    func setLoadingFooter() {
        footerView = UIView()
        footerView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44)
        footerView.backgroundColor = #colorLiteral(red: 0.1271243393, green: 0.2286310792, blue: 0.3835525513, alpha: 1)
        let activity = UIActivityIndicatorView()
        activity.center = footerView.center
        activity.color = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        activity.startAnimating()
        footerView.addSubview(activity)
    }
    
}
