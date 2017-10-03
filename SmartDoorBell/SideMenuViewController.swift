//
//  SideMenuViewController.swift
//  SmartDoorBell
//
//  Created by Archerwind on 5/24/17.
//  Copyright © 2017 Archerwind. All rights reserved.
//

import UIKit
import Spring
import InteractiveSideMenu

class SideMenuViewController: UIViewController, MenuContainerViewController {
   
   func initializer() {
      menuViewController = self.storyboard!.instantiateViewController( withIdentifier: "NavigationMenu" ) as! MenuViewController
      
      contentViewControllers = contentControllers()
      
      selectContentViewController(contentViewControllers.first!)
   }
   
   private func contentControllers() -> [MenuItemContentViewController] {
      var contentList = [MenuItemContentViewController]()
      contentList.append(self.storyboard?.instantiateViewController(withIdentifier: "First") as! MenuItemContentViewController)
      contentList.append(self.storyboard?.instantiateViewController(withIdentifier: "Second") as! MenuItemContentViewController)
      return contentList
   }
   
   override func viewDidLoad() {
      super.viewDidLoad()
      self.initializer()
   }
   
   override func viewWillAppear( _ animated: Bool ) {
      
   }
   
   override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
   }
}
