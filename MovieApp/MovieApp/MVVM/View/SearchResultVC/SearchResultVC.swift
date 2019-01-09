//
//  SearchResultVC.swift
//  MovieApp
//
//  Created by Ketan on 1/7/19.
//  Copyright © 2019 Ketan. All rights reserved.
//

import UIKit

class SearchResultVC: UIViewController {
    
    @IBOutlet weak var constantViewLeft: NSLayoutConstraint!
    @IBOutlet var btnNowShowing: UIButton!
    @IBOutlet var btnCommingSoon: UIButton!
    @IBOutlet weak var viewMenu: UIView!
    @IBOutlet var viewLine: UIView!
    
    var pageController: UIPageViewController!
    var indexOfViewController : String?
    var arrVC:[UIViewController] = []
    var strSearchText:String!
    var currentPage: Int!
    
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setInitialUI()
    }
    
    //MARK: - Custom Methods
    
    private func setInitialUI() {
        
        currentPage = 0
        createPageViewController()
        
        pageController.dataSource = self
        pageController.delegate = self
        
        viewMenu.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        viewMenu.layer.shadowColor = UIColor.black.cgColor
        viewMenu.layer.masksToBounds = false
        viewMenu.layer.shadowOpacity = 0.2
        viewMenu.layer.shadowRadius = 0.3
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    private func createPageViewController() {
        
        pageController = UIPageViewController.init(transitionStyle: UIPageViewController.TransitionStyle.scroll, navigationOrientation: UIPageViewController.NavigationOrientation.horizontal, options: nil)
        
        pageController.view.backgroundColor = UIColor.clear
        
        for svScroll in pageController.view.subviews as! [UIScrollView] {
            svScroll.delegate = self as UIScrollViewDelegate
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.pageController.view.frame = CGRect(x: 0, y: (self.viewMenu.frame.origin.y + self.viewMenu.frame.size.height + 4) , width: self.view.frame.size.width, height: self.view.frame.size.height - (self.viewMenu.frame.origin.y + self.viewMenu.frame.size.height - 4))
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
    
    private func selectedButton(btn: UIButton) {
        btn.setTitleColor(UIColor.white, for: UIControl.State.normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        constantViewLeft.constant = btn.frame.origin.x
        self.view.layoutIfNeeded()
    }
    
    private func unSelectedButton(btn: UIButton) {
        btn.setTitleColor(UIColor.white.withAlphaComponent(0.7), for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
    }
    
    private func indexofviewController(viewCOntroller: UIViewController) -> Int {
        
        if(arrVC .contains(viewCOntroller)) {
            return  arrVC.index(of: viewCOntroller)!
        }
        return -1
    }
    
    private func resetTabBarForTag(tag: Int) {
        
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

extension SearchResultVC: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController1: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        if(completed) {
            currentPage = arrVC.index(of: (pageViewController1.viewControllers?.last)!)
            resetTabBarForTag(tag: currentPage)
        }
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
}

extension SearchResultVC: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let xFromCenter: CGFloat = self.view.frame.size.width-scrollView.contentOffset.x
        let xCoor: CGFloat = CGFloat(viewLine.frame.size.width) * CGFloat(currentPage)
        let xPosition: CGFloat = xCoor - xFromCenter/CGFloat(arrVC.count)
        constantViewLeft.constant = xPosition
    }
}
