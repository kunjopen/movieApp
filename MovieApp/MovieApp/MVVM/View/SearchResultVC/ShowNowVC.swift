//
//  ShowNowVC.swift
//  MovieApp
//
//  Created by Ketan on 1/7/19.
//  Copyright © 2019 Ketan. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ShowNowVC: UIViewController {
    
    //MARK:- IBOutlate
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK:- Variables
    let disposeBag = DisposeBag()
    let movieViewModel = MovieViewModel()
    var isWSCall: Bool = false
    var strSearchText:String!
    var pageNumber = 0
    var strType:String!
    
    //RefreshTableView
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.refreshData(_:)), for: UIControl.Event.valueChanged)
        refreshControl.tintColor = #colorLiteral(red: 0.1271243393, green: 0.2286310792, blue: 0.3835525513, alpha: 1)
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setInitialUI()
        self.bindLoading()
        self.bindList()
    }
    
    //MARK:- UI Binding
    
    private func bindList() {
        
        self.movieViewModel.movieObjects.asObservable()
            .bind(to: tableView.rx.items) { (tableView, row, movieObject) in
                let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultCell") as! SearchResultCell
                cell.movieObject = movieObject
                return cell
            }
            .disposed(by: disposeBag)
        
        tableView.rx
            .willDisplayCell
            .subscribe(onNext: { cell, indexPath in
                if(indexPath.row == (self.movieViewModel.movieObjects.value.count-1)) {
                    if(self.isWSCall == false) {
                        self.loadMoreDataFromServer()
                    }
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func bindLoading() {
        
        self.movieViewModel.movieObjects.asObservable().subscribe({
            _ in
            
            if(!(self.movieViewModel.movieObjects.value.isEmpty)) {
                
                DispatchQueue.main.async {
                    self.tableView.refreshControl?.endRefreshing()
                    self.tableView.isHidden = false
                    self.activity.isHidden = true
                    self.isWSCall = false
                }
            }
        } ).disposed(by: disposeBag)
    }
    
    //MARK:- Get all Movie list
    @objc private func refreshData(_ sender: Any) {
        getAllMoviewsFromServer()
    }
    
    //MARK:- Custom Methods
    
    private func setInitialUI() {
        
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.registerNib("SearchResultCell")
        self.tableView.refreshControl = refreshControl
        self.tableView.tableFooterView = UIView()
        self.tableView.estimatedRowHeight = 155        
        self.getAllMoviewsFromServer()
    }
    
    private func getAllMoviewsFromServer() {
        let params = ["keyword": strSearchText, "offset": "\(pageNumber)", "type": strType]
        movieViewModel.getSearchResultFromServer(dictParams: params as [String : AnyObject])
    }
    
    private func loadMoreDataFromServer() {
        LoadMore.sharedInstance.showLoadingInTable(tbl:self.tableView, text: "")
        self.pageNumber = self.pageNumber + 1
        let params = ["keyword": strSearchText, "offset": "\(pageNumber)", "type": strType]
        isWSCall = true
        movieViewModel.loadMoreSearchResultFromServer(dictParams: params as [String : AnyObject])
    }
    
}
