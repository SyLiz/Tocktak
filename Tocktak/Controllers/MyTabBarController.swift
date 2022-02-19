//
//  MyTabBarController.swift
//  Tocktak
//
//  Created by BOICOMP21070027 on 19/2/2565 BE.
//

import UIKit

class MyTabBarController: UITabBarController , UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        // Do any additional setup after loading the view.
    }
    
    // UITabBarDelegate
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        //Reset navigationBar
        self.navigationController?.navigationBar.topItem?.titleView = UIView()
        self.navigationController!.navigationBar.topItem?.rightBarButtonItem = nil
        self.navigationController!.navigationBar.topItem?.leftBarButtonItem = nil
        print("Selected item")
    }

    // UITabBarControllerDelegate
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        print("Selected view controller")
    }
}
