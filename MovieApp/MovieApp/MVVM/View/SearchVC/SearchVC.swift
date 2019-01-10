//
//  SearchVC.swift
//  MovieApp
//
//  Created by Ketan on 1/7/19.
//  Copyright © 2019 Ketan. All rights reserved.
//

import UIKit
import CoreData
import RxSwift
import RxCocoa

class SearchVC: UIViewController {
    
    //MARK:- IBOutlate
    @IBOutlet weak var tblSearchView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    //MARK:- Variables
    private let searchViewModel = SearchViewModel()
    
    
    
    //MARK:- View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchViewModel.delegate = self
        tblSearchView.registerNib("SearchCell")
        tblSearchView.tableFooterView = UIView()
        self.searchViewModel.getAllSearchFromLocalDB(strSearchText: "")        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpNavigationbar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        setUpNavigationbar()
    }
    
    func setUpNavigationbar() {
        navigationController?.view.setNeedsLayout()
        navigationController?.view.layoutIfNeeded()
    }
    
    // Move to Search Result
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destinationVC = segue.destination as? SearchResultVC {
            
            if let indexPath = sender as? IndexPath {
                let objSearchResult = self.searchViewModel.fetchedResultsController.object(at: indexPath)
                destinationVC.strSearchText = objSearchResult.searchText
            }
            else {
                destinationVC.strSearchText = searchBar.text
            }
        }
    }
    
    @IBAction func btnCancelCliecked(_ btnSender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension SearchVC: ViewModelSearchDelegate {
    
    func reloadData() {
        self.tblSearchView.reloadData()
    }
}

//MARK:- UISearchBarDelegate

extension SearchVC : UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //self.searchViewModel.getAllSearchFromLocalDB(strSearchText: searchBar.text!)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        self.searchBar.endEditing(true)
        
        if searchBar.text!.count > 0 {
            self.searchViewModel.addNewRecord(strSearchText: searchBar.text!)
        }
        
        self.performSegue(withIdentifier: "ResultToList", sender: nil)
    }
}


//MARK:- UITableViewDelegate, UITableViewDataSource

extension SearchVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let sections = self.searchViewModel.fetchedResultsController.sections else {
            return 0
        }
        
        let sectionInfo = sections[section]
        return sectionInfo.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:SearchCell = tableView.dequeueReusableCell(withIdentifier: "SearchCell", for: indexPath) as! SearchCell
        cell.searchObject = self.searchViewModel.fetchedResultsController.object(at: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "ResultToList", sender: indexPath)
        self.searchBar.endEditing(true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .normal, title: "Delete") { (action, sourceView, completionHandler) in
            let objSearchResult = self.searchViewModel.fetchedResultsController.object(at: indexPath)
            self.searchViewModel.deleteObject(objSearchResult: objSearchResult)
            completionHandler(true)
        }
        
        deleteAction.backgroundColor = UIColor.red
        let swipeAction = UISwipeActionsConfiguration(actions: [deleteAction])
        swipeAction.performsFirstActionWithFullSwipe = false
        return swipeAction
    }
}
