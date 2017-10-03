//
//  CallViewController.swift
//  SmartDoorBell
//
//  Created by Archerwind on 5/24/17.
//  Copyright © 2017 Archerwind. All rights reserved.
//

import UIKit
import Spring

class CallViewController: UIViewController {
   
   @IBAction func collapseAction(_ sender: Any) {
      dismiss( animated: true, completion: nil )
   }
   
   @IBAction func declineAction(_ sender: Any) {
      dismiss( animated: true, completion: nil )
   }
   
   @IBAction func unlockAction(_ sender: Any) {
      dismiss( animated: true, completion: nil )
   }
   
   @IBAction func answerAction(_ sender: Any) {
      dismiss( animated: true, completion: nil )
   }
   
   func initializer() {
   
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
