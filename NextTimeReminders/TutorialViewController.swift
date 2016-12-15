//
//  TutorialViewController.swift
//  NextTimeReminders
//
//  Created by Kasra Koushan on 2016-11-06.
//  Copyright © 2016 Kasra Koushan. All rights reserved.
//

import UIKit

class TutorialViewController: UIViewController, UIPageViewControllerDataSource {

    var pageViewController: UIPageViewController!
    static var pagePrompts = ["NextTime is a smart location based reminders app.",
                       "Tap to add a new reminder.",
                       "Write your note, and tap to search for locations.",
                       "See the results, and confirm or search again.",
                       "When you're near a tagged location, NextTime will send you a notification.",
                       "Swipe right and check off when you're done!"]
    static var pageImages = ["location", "tutorial2", "tutorial3", "tutorial4", "tutorial5", "tutorial6"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // modify page indicator
        let pageControl = UIPageControl.appearance()
        pageControl.pageIndicatorTintColor = UIColor.lightGray
        pageControl.currentPageIndicatorTintColor = UIColor.black
        pageControl.backgroundColor = UIColor.clear
        
        // set up page view controller
        pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageViewController.dataSource = self
        let startingViewController: TutorialContentViewController = self.viewControllerAtIndex(0)
        pageViewController.setViewControllers([startingViewController], direction: .forward, animated: true, completion: nil)
        
        // add page view controller as a subview
        self.pageViewController.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        self.addChildViewController(self.pageViewController)
        self.view.addSubview(self.pageViewController.view)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        if let index = (viewController as? TutorialContentViewController)?.pageIndex {
            if index == 0 {
                return nil
            } else {
                return self.viewControllerAtIndex(index - 1)
            }
        } else {
            return nil
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        if let index = (viewController as? TutorialContentViewController)?.pageIndex {
            if index == TutorialViewController.pagePrompts.count - 1 {
                return nil
            } else {
                return self.viewControllerAtIndex(index + 1)
            }
        } else {
            return nil
        }
    }
    
    func viewControllerAtIndex(_ index: Int) -> TutorialContentViewController {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TutorialContentView") as! TutorialContentViewController
        vc.pageIndex = index
        
        return vc
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return TutorialViewController.pagePrompts.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
