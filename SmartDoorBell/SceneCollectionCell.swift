//
//  SceneCollectionCell.swift
//  SmartDoorBell
//
//  Created by Archerwind on 5/23/17.
//  Copyright © 2017 Archerwind. All rights reserved.
//

import UIKit
import Spring

class SceneCollectionCell: UICollectionViewCell {
   
   
   @IBOutlet weak var backgroundImageView: UIImageView!
   @IBOutlet weak var switchImageView: UIImageView!
   @IBOutlet weak var firstLabel: UILabel!
   @IBOutlet weak var secondLabel: UILabel!
   
   var isOpen = false
   
   func loadCell( indexPath: IndexPath ) {
      if indexPath.row % 2 == 0 {
         firstLabel.text = "AWAY"
         secondLabel.text = ""
      }
      else {
         firstLabel.text = "ENERGY"
         secondLabel.text = "SAVER"
      }
   }
   
   func toggleUI() {
      if isOpen {
         UIView.animate( withDuration: 0.25, animations: {
            self.switchImageView.alpha = 1.0
            self.backgroundImageView.image = UIImage(named: "cardBgSceneOn")
         })
      }
      else {
         UIView.animate( withDuration: 0.25, animations: {
            self.switchImageView.alpha = 0.0
            self.backgroundImageView.image = UIImage(named: "cardBgSceneOff")
         })
      }
      isOpen = !isOpen
   }
}
