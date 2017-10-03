//
//  DeviceCollectionCell.swift
//  SmartDoorBell
//
//  Created by Archerwind on 5/23/17.
//  Copyright © 2017 Archerwind. All rights reserved.
//

import UIKit
import Spring

class DeviceCollectionCell: UICollectionViewCell {
   
   @IBOutlet weak var iconImageView: UIImageView!
   @IBOutlet weak var deviceNameLabel: UILabel!
   @IBOutlet weak var areaLabel: UILabel!
   @IBOutlet weak var switchImageView: UIImageView!
   
   var isOpen = false

   func loadCell( indexPath: IndexPath ) {
      if indexPath.row % 2 != 0 {
         switchImageView.image = UIImage(named: "iconPowerOn")
         iconImageView.image = UIImage(named: "deviceDoorbell")
         deviceNameLabel.text = "Door Bell"
         areaLabel.text = "Entrance"
      }
      else {
         switchImageView.image = UIImage(named: "iconPowerOn")
         iconImageView.image = UIImage(named: "deviceThermostat")
         deviceNameLabel.text = "Thermostat"
         areaLabel.text = "Living Room"
         iconImageView.alpha = 1.0
      }
   }
   
   func toggleUI() {
      if isOpen {
         switchImageView.image = UIImage(named: "iconPowerOff")
         UIView.animate( withDuration: 0.25, animations: {
            //self.deviceNameLabel.alpha = 0.3
            //self.areaLabel.alpha = 0.3
            self.iconImageView.alpha = 0.3
         })
      }
      else {
         switchImageView.image = UIImage(named: "iconPowerOn")
         UIView.animate( withDuration: 0.25, animations: {
            //self.deviceNameLabel.alpha = 1.0
            //self.areaLabel.alpha = 1.0
            self.iconImageView.alpha = 1.0
         })
      }
      isOpen = !isOpen
   }
}
