//
//  SearchViewModel.swift
//  MovieApp
//
//  Created by Ketan on 1/9/19.
//  Copyright © 2019 Ketan. All rights reserved.
//


import UIKit
import SwiftyJSON
import CoreData
import RxSwift

protocol ViewModelSearchDelegate: class {
    func reloadData()
}

class SearchViewModel:NSObject {
    
    
    private var repository = SearchRepository()
    weak var delegate: ViewModelSearchDelegate?
    var arrSearchResults = [SearchResult]()
    
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private let LimitRecord = 10
        
    //Manage coredata changes and update UI
    lazy var fetchedResultsController: NSFetchedResultsController<SearchResult> = {
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<SearchResult>(entityName: "SearchResult")
        let sortDescriptor = NSSortDescriptor(key: "searchTime", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        let fetchedResultsController = NSFetchedResultsController<SearchResult>(fetchRequest: fetchRequest, managedObjectContext: managedContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()
    
    //MARK:- Custom Methods
    
    func getAllSearchFromLocalDB(strSearchText:String) {
        
        if strSearchText.count > 0 {
            fetchedResultsController.fetchRequest.predicate = NSPredicate(format: "searchText contains[c] %@", strSearchText)
        }
        else{
            fetchedResultsController.fetchRequest.predicate = nil
        }
        
        
        do{
            try fetchedResultsController.performFetch()
            delegate?.reloadData()
        }
        catch{
            debugPrint(error)
        }
    }
 
    func deleteObject(objSearchResult: SearchResult) {
        self.appDelegate.persistentContainer.viewContext.delete(objSearchResult)
    }
    
    func addNewRecord(strSearchText:String) {
        
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "SearchResult", in: context)
        let SearchResult = NSManagedObject(entity: entity!, insertInto: context)
        
        SearchResult.setValue(strSearchText, forKey: "searchText")
        SearchResult.setValue(Date(), forKey: "searchTime")
        
        do {
            try context.save()
            deleteOtherSearch()
        }
        catch  {
            debugPrint(error)
            context.delete(SearchResult)
        }
    }
    
    private func deleteOtherSearch() {
        
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
                }
                catch {
                    debugPrint("Error: \(error.localizedDescription)")
                }
            }
        }
        catch let error as NSError {
            debugPrint("Error: \(error.localizedDescription)")
        }
    }
    
}

extension SearchViewModel: NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        delegate?.reloadData()
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {}
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {}
}
