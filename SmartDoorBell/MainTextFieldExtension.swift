//
//  MainTextFieldExtension.swift
//  SmartDoorBell
//
//  Created by Archerwind on 4/18/17.
//  Copyright © 2017 Archerwind. All rights reserved.
//

import UIKit

extension MainViewController: UITextFieldDelegate {
   
   override func touchesBegan( _ touches: Set<UITouch>, with event: UIEvent? ) {
      //      if let touch = touches.first as! UITouch {
      //         // ...
      //      }
      super.touchesBegan( touches , with:event )
      self.view.endEditing( true )
   }
   
   func textFieldShouldReturn( _ textField: UITextField ) -> Bool {
      textField.resignFirstResponder()
      return true
   }
   
   func textFieldDidBeginEditing( _ textField: UITextField ) {
      UIView.animate( withDuration: 0.25, animations: { () -> Void in
         self.view.center = CGPoint( x: self.view.center.x, y: self.view.center.y - 40 )
      })
   }
   
   func textFieldDidEndEditing( _ textField: UITextField ) {
      UIView.animate( withDuration: 0.25, animations: { () -> Void in
         self.view.center = CGPoint( x: self.view.center.x, y: self.view.center.y + 40 )
      })
   }
}
