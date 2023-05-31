//
//  NavigationController.swift
//  GoogleLogin
//
//  Created by user on 6/12/20.
//  Copyright © 2020 vinova. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {

    lazy var mainViewController = MainViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.barTintColor = UIColor.rgb(r: 25, g: 51, b: 102)
        
        navigationBar.tintColor = UIColor.rgb(r: 0, g: 0, b: 0)
        
//        mainViewController.view.frame.origin = CGPoint(x:0, y:0)
//        mainViewController.view.bounds.size.height = self.view.bounds.height/2
        
        
         pushViewController(mainViewController, animated: true)

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


extension UIColor {
    static let mainTextBlue = UIColor.rgb(r: 7, g: 71, b: 89)
    static let highlightColor = UIColor.rgb(r: 50, g: 199, b: 242)
    
    static func rgb(r: CGFloat, g: CGFloat, b: CGFloat) -> UIColor {
        return UIColor(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
}

class CustomNavigationController: UINavigationController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
