//
//  AppDelegate.swift
//  MovieApp
//
//  Created by Ketan on 1/3/19.
//  Copyright © 2019 Ketan. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let coreData = "MovieApp"
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.window?.backgroundColor = #colorLiteral(red: 0.1271243393, green: 0.2286310792, blue: 0.3835525513, alpha: 1)
        LoadMore.sharedInstance.setLoadingFooter()
        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        
    }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {

        let container = NSPersistentContainer(name: coreData)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                debugPrint("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
}

