//
//  SearchResultVC.swift
//  MovieApp
//
//  Created by Ketan on 1/7/19.
//  Copyright © 2019 Ketan. All rights reserved.
//

import UIKit

class SearchResultVC: UIViewController,UIPageViewControllerDelegate,UIPageViewControllerDataSource {
    
    @IBOutlet var btnNowShowing: UIButton!
    @IBOutlet var btnCommingSoon: UIButton!
    var indexOfViewController : String?
    
    @IBOutlet var viewLine: UIView!
    @IBOutlet weak var constantViewLeft: NSLayoutConstraint!
    @IBOutlet weak var viewMenu: UIView!
    
    var pageController: UIPageViewController!
    var arrVC:[UIViewController] = []
    var currentPage: Int!
    
    
    var strSearchText:String!
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        currentPage = 0
        createPageViewController()
        
        pageController.delegate = self
        pageController.dataSource = self
    }
    
    func createPageViewController() {
        
        pageController = UIPageViewController.init(transitionStyle: UIPageViewController.TransitionStyle.scroll, navigationOrientation: UIPageViewController.NavigationOrientation.horizontal, options: nil)
        
        pageController.view.backgroundColor = UIColor.clear
        
        for svScroll in pageController.view.subviews as! [UIScrollView] {
            svScroll.delegate = self as UIScrollViewDelegate
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.pageController.view.frame = CGRect(x: 0, y: (self.viewMenu.frame.origin.y + self.viewMenu.frame.size.height) , width: self.view.frame.size.width, height: self.view.frame.size.height - (self.viewMenu.frame.origin.y + self.viewMenu.frame.size.height))
        }
        
        let showNowVC = storyboard?.instantiateViewController(withIdentifier: "ShowNowVC") as! ShowNowVC
        showNowVC.strSearchText = strSearchText
        showNowVC.strType = "nowshowing"
        
        let commingSoonVC = storyboard?.instantiateViewController(withIdentifier: "ShowNowVC") as! ShowNowVC
        commingSoonVC.strSearchText = strSearchText
        commingSoonVC.strType = "comingsoon"
        
        arrVC = [showNowVC,commingSoonVC]
        
        pageController.setViewControllers([showNowVC], direction: UIPageViewController.NavigationDirection.forward, animated: false, completion: nil)
        
        self.addChild(pageController)
        self.view.addSubview(pageController.view)
        pageController.didMove(toParent: self)
        
    }
    
    //MARK: - Custom Methods
    
    func selectedButton(btn: UIButton) {
        btn.setTitleColor(UIColor.white, for: UIControl.State.normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        constantViewLeft.constant = btn.frame.origin.x
        self.view.layoutIfNeeded()
    }
    
    func unSelectedButton(btn: UIButton) {
        btn.setTitleColor(UIColor.white.withAlphaComponent(0.7), for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
    }
    
    func indexofviewController(viewCOntroller: UIViewController) -> Int {
        if(arrVC .contains(viewCOntroller)) {
            return  arrVC.index(of: viewCOntroller)!
        }
        
        return -1
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        var index = indexofviewController(viewCOntroller: viewController)
        
        if(index != -1) {
            index = index - 1
        }
        
        if(index < 0) {
            return nil
        }
        else {
            return  arrVC[index]
        }
        
    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        var index = indexofviewController(viewCOntroller: viewController)
        
        if(index != -1) {
            index = index + 1
        }
        
        if(index >= arrVC.count) {
            return nil
        }
        else {
            return arrVC[index]
        }
        
    }
    
    func pageViewController(_ pageViewController1: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        if(completed) {
            currentPage = arrVC.index(of: (pageViewController1.viewControllers?.last)!)
            resetTabBarForTag(tag: currentPage)
            
        }
    }
    
    func resetTabBarForTag(tag: Int) {
        
        var sender: UIButton!
        if(tag == 0) {
            sender = btnNowShowing
        }
        else if(tag == 1) {
            sender = btnCommingSoon
        }
        
        currentPage = tag
        
        unSelectedButton(btn: btnNowShowing)
        unSelectedButton(btn: btnCommingSoon)
        selectedButton(btn: sender)
    }
    
    //MARK:- IBAction Methods
    
    @IBAction func btnBackCliecked(_ sender: UIBarButtonItem) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnOptionClicked(btn: UIButton) {
        
        pageController.setViewControllers([arrVC[btn.tag-1]], direction: UIPageViewController.NavigationDirection.reverse, animated: false, completion: {(Bool) -> Void in
        })
        
        resetTabBarForTag(tag: btn.tag-1)
    }
}

extension SearchResultVC:UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let xFromCenter: CGFloat = self.view.frame.size.width-scrollView.contentOffset.x
        let xCoor: CGFloat = CGFloat(viewLine.frame.size.width) * CGFloat(currentPage)
        let xPosition: CGFloat = xCoor - xFromCenter/CGFloat(arrVC.count)
        constantViewLeft.constant = xPosition
    }
    
}
