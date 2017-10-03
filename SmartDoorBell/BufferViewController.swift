//
//  BufferViewController.swift
//  SmartDoorBell
//
//  Created by Archerwind on 4/17/17.
//  Copyright © 2017 Archerwind. All rights reserved.
//

import UIKit
import RealmSwift

class BufferViewController: UIViewController {
   
   @IBOutlet weak var titleLabel: UILabel!
   @IBOutlet weak var subtitleLabel: UILabel!
   @IBOutlet weak var CounterLabel: UILabel!
   @IBOutlet weak var displayLabel: UILabel!
   @IBOutlet weak var configButton: UIButton!
   @IBOutlet weak var clearButton: UIButton!
   
   @IBAction func clearAction( _ sender: Any ) {
      let realm = try! Realm()
      let count = realm.objects( CounterRealm.self )
      
      try! realm.write {
         realm.create( CounterRealm.self, value: ["id": (count.first?.id)!, "counter": 0], update: true )
      }
      self.CounterLabel.text = "0"
   }
   
   func readCounterValue() {
      let realm = try! Realm()
      let counter = realm.objects( CounterRealm.self )
      
      if counter.count == 0 {
         let count = CounterRealm()
         count.counter = 0
         try! realm.write {
            realm.add( count )
         }
         self.CounterLabel.text = "0"
      }
      else {
         self.CounterLabel.text = String( format: "%d", (counter.first?.counter)! )
      }
   }
   
   func initializer() {
      self.titleLabel.kern( 2.0 )
      self.subtitleLabel.kern( 1.5 )
      self.displayLabel.kern( 1.5 )
      self.configButton.kern( 2.0 )
      self.clearButton.kern( 2.0 )
      self.CounterLabel.kern( 4.0 )
   }

   override func viewDidLoad() {
      super.viewDidLoad()
      self.initializer()
      let countNotification = Notification.Name( "count" )
      NotificationCenter.default.addObserver( self, selector: #selector( self.readCounterValue ), name: countNotification, object: nil )
   }
   
   override func viewWillAppear( _ animated: Bool ) {
      self.readCounterValue()
   }
   
   override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
   }
   
   
}
