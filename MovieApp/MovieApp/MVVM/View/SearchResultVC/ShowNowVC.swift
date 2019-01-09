//
//  ShowNowVC.swift
//  MovieApp
//
//  Created by Ketan on 1/7/19.
//  Copyright © 2019 Ketan. All rights reserved.
//

import UIKit

class ShowNowVC: UIViewController {
    
    //MARK:- IBOutlate
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK:- Variables
    var strSearchText:String!
    var strType:String!
    var pageNumber: Int!
    let movieModel = MovieModel()
    var isWSCall: Bool = false
    
    //RefreshTableView
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.refreshData(_:)), for: UIControl.Event.valueChanged)
        refreshControl.tintColor = #colorLiteral(red: 0.1271243393, green: 0.2286310792, blue: 0.3835525513, alpha: 1)
        return refreshControl
    }()
    
    
    
    //List of all movies
    private var movieObjects = [MovieObject]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.refreshControl = refreshControl
        self.tableView.estimatedRowHeight = 155
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.tableFooterView = UIView()
        pageNumber = 0
        self.getAllMoviewsFromServer()
        
    }
    
    //MARK:- Get all Movie list
    
    @objc private func refreshData(_ sender: Any) {
        getAllMoviewsFromServer()
    }
    
    private func getAllMoviewsFromServer() {
        
        let params = ["keyword": strSearchText, "offset": "\(pageNumber!)", "type": strType]
        
        movieModel.getSearchResultFromServer(dictParams: params as [String : AnyObject], success: { (response) in
            
            DispatchQueue.main.async {
                self.tableView.refreshControl?.endRefreshing()
            }
            
            self.movieObjects = response!
            
            if(self.movieObjects.count > 0) {
                DispatchQueue.main.async {
                    self.tableView.isHidden = false
                    self.activity.isHidden = true
                    self.tableView.reloadData()
                }
            }
            
        }) { (error) in
            DispatchQueue.main.async {
                self.activity.isHidden = true
            }
        }
    }
}


extension ShowNowVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieObjects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let searchResultCell: SearchResultCell = tableView.dequeueReusableCell(withIdentifier: "SearchResultCell") as! SearchResultCell
        searchResultCell.selectionStyle = .none
        searchResultCell.movieObject = movieObjects[indexPath.row]
        return searchResultCell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if(indexPath.row == (movieObjects.count-1)) {
            
            if(isWSCall == false) {
                LoadMore.sharedInstance.showLoadingInTable(tbl:self.tableView, text: "")
                
                self.pageNumber = self.pageNumber + 1
                let params = ["keyword": strSearchText, "offset": "\(pageNumber!)", "type": strType]
                
                isWSCall = true
                
                movieModel.loadMoreSearchResultFromServer(dictParams: params as [String : AnyObject], success: { (response) in
                    self.movieObjects = self.movieObjects + response!
                    self.isWSCall = false
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    
                }) { (error) in
                    LoadMore.sharedInstance.hideLoadingInTable(tbl: self.tableView)
                    self.pageNumber = self.pageNumber - 1
                    self.isWSCall = false
                }
            }
        }
    }
}
