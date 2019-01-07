//
//  SearchVC.swift
//  MovieApp
//
//  Created by Ketan on 1/7/19.
//  Copyright © 2019 Ketan. All rights reserved.
//

import UIKit
import CoreData

class SearchVC: UIViewController {

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let LimitRecord = 10
    var arrSearchResults = [SearchResult]()
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tblSearchView: UITableView!
    
    lazy var fetchedResultsController: NSFetchedResultsController<SearchResult> = {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<SearchResult>(entityName: "SearchResult")
        let sortDescriptor = NSSortDescriptor(key: "searchTime", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        let fetchedResultsController = NSFetchedResultsController<SearchResult>(fetchRequest: fetchRequest, managedObjectContext: managedContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblSearchView.tableFooterView = UIView()
        
        do{
            try fetchedResultsController.performFetch()
            self.tblSearchView.reloadData()
        }
        catch{
            debugPrint(error)
        }
    }
    
    func deleteOtherSearch() {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "SearchResult")
        
        do {
        
            let count = try appDelegate.persistentContainer.viewContext.count(for:fetchRequest)
            
            if count > LimitRecord {
                let sortDescriptor = NSSortDescriptor(key: "searchTime", ascending: true)
                fetchRequest.sortDescriptors = [sortDescriptor]
                fetchRequest.fetchLimit = count - LimitRecord
                let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            
                do {
                    try appDelegate.persistentContainer.viewContext.execute(batchDeleteRequest)
                } catch {
                    debugPrint("Error: \(error.localizedDescription)")
                }
            }
        } catch let error as NSError {
            debugPrint("Error: \(error.localizedDescription)")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? SearchResultVC {
            let objSearchResult = fetchedResultsController.object(at: sender as! IndexPath)
            destinationVC.strSearchText = objSearchResult.searchText
        }
    }
    
    @IBAction func btnCancelCliecked(_ btnSender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension SearchVC : NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch (type) {
        case .insert:
            if let indexPath = newIndexPath {
                tblSearchView.insertRows(at: [indexPath], with: .fade)
            }
        case .delete:
            if let indexPath = indexPath {
                tblSearchView.deleteRows(at: [indexPath], with: .fade)
            }
        default:
            break;
        }
        
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tblSearchView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tblSearchView.endUpdates()
    }
    
}

extension SearchVC : UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.count > 0 {
            fetchedResultsController.fetchRequest.predicate = NSPredicate(format: "searchText contains[c] %@", searchText)
        }else{
            fetchedResultsController.fetchRequest.predicate = nil
        }
        
        do{
            try fetchedResultsController.performFetch()
            self.tblSearchView.reloadData()
        }catch{
            debugPrint(error)
        }
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if searchBar.text!.count > 0 {
            
            let context = appDelegate.persistentContainer.viewContext
            let entity = NSEntityDescription.entity(forEntityName: "SearchResult", in: context)
            let SearchResult = NSManagedObject(entity: entity!, insertInto: context)
            
            SearchResult.setValue(searchBar.text!, forKey: "searchText")
            SearchResult.setValue(Date(), forKey: "searchTime")
            
            do {
                try context.save()
                deleteOtherSearch()
            } catch  {
                
                debugPrint(error)
                debugPrint("Failed saving")
                context.delete(SearchResult)
            }
        }
    }
    
}



extension SearchVC : UITableViewDelegate, UITableViewDataSource {
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = fetchedResultsController.sections else {
            return 0
        }
        
        let sectionInfo = sections[section]
        return sectionInfo.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:SearchCell = tableView.dequeueReusableCell(withIdentifier: "SearchCell", for: indexPath) as! SearchCell
        let objSearchResult = fetchedResultsController.object(at: indexPath)
        cell.lblSearchText.text = objSearchResult.searchText
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "ResultToList", sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .normal, title: "Delete") { (action, sourceView, completionHandler) in
            let objSearchResult = self.fetchedResultsController.object(at: indexPath)
            self.appDelegate.persistentContainer.viewContext.delete(objSearchResult)
            completionHandler(true)
        }
        
        deleteAction.backgroundColor = UIColor.red
        let swipeAction = UISwipeActionsConfiguration(actions: [deleteAction])
        swipeAction.performsFirstActionWithFullSwipe = false
        return swipeAction
    }
}
