//
//  IndexViewController.swift
//  SmartDoorBell
//
//  Created by Archerwind on 5/23/17.
//  Copyright © 2017 Archerwind. All rights reserved.
//


import UIKit
import Spring
import InteractiveSideMenu

class IndexViewController: UIViewController, MenuContainerViewController {

   @IBOutlet weak var deviceCollectionView: UICollectionView!
   @IBOutlet weak var roomCollectionView: UICollectionView!
   @IBOutlet weak var sceneCollectionView: UICollectionView!
   @IBOutlet weak var homeButton: DesignableButton!
   @IBOutlet weak var officeButton: DesignableButton!
   @IBOutlet weak var cottageButton: DesignableButton!
   
   
   @IBAction func notificationAction(_ sender: Any) {
      let vc = storyboard?.instantiateViewController( withIdentifier: "CallViewController" ) as! CallViewController
      present( vc, animated: true, completion: nil )
   }
   
   @IBAction func menuAction(_ sender: Any) {
      showMenu()
   }
   
   @IBAction func cottageAction(_ sender: Any) {
      UIView.animate( withDuration: 0.25, animations: {
         self.homeButton.alpha = 0.3
         self.officeButton.alpha = 0.3
         self.cottageButton.alpha = 1.0
      })
      self.sceneCollectionView.reloadData()
   }
   
   @IBAction func officeAction(_ sender: Any) {
      UIView.animate( withDuration: 0.25, animations: {
         self.homeButton.alpha = 0.3
         self.officeButton.alpha = 1.0
         self.cottageButton.alpha = 0.3
      })
      self.roomCollectionView.reloadData()
   }
   
   @IBAction func homeAction(_ sender: Any) {
      UIView.animate( withDuration: 0.25, animations: {
         self.homeButton.alpha = 1.0
         self.officeButton.alpha = 0.3
         self.cottageButton.alpha = 0.3
      })
      self.deviceCollectionView.reloadData()
   }
   
   func initializer() {
      self.deviceCollectionView.delegate = self
      self.deviceCollectionView.dataSource = self
      self.roomCollectionView.delegate = self
      self.roomCollectionView.dataSource = self
      self.sceneCollectionView.delegate = self
      self.sceneCollectionView.dataSource = self
    
      self.deviceCollectionView.layer.backgroundColor = UIColor.transparent.cgColor
      self.roomCollectionView.layer.backgroundColor = UIColor.transparent.cgColor
      self.sceneCollectionView.layer.backgroundColor = UIColor.transparent.cgColor
      
      homeButton.kern( 1.2 )
      officeButton.kern( 1.2 )
      cottageButton.kern( 1.2 )
      
      let countNotification = Notification.Name( "count" )
      NotificationCenter.default.addObserver( self, selector: #selector( self.notificationAction(_:) ), name: countNotification, object: nil )
      
      menuViewController = self.storyboard!.instantiateViewController( withIdentifier: "CallViewController" ) as! MenuViewController
      contentViewControllers = contentControllers()
      selectContentViewController(contentViewControllers.first!)
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
