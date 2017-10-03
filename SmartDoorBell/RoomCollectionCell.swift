//
//  roomCollectionCell.swift
//  SmartDoorBell
//
//  Created by Archerwind on 5/23/17.
//  Copyright © 2017 Archerwind. All rights reserved.
//

import UIKit
import Spring

class RoomCollectionCell: UICollectionViewCell {
   
   @IBOutlet weak var roomImageView: UIImageView!
   
   func loadCell( indexPath: IndexPath ) {
      if indexPath.row % 2 == 0 {
         roomImageView.image = UIImage( named: "roomLivingroom" )
      }
      else {
         roomImageView.image = UIImage( named: "roomBedroom" )
      }
   }
}
