//
//  IndexCollectionViewController.swift
//  SmartDoorBell
//
//  Created by Archerwind on 5/23/17.
//  Copyright © 2017 Archerwind. All rights reserved.
//

import UIKit
import Spring

extension IndexViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

   func collectionView( _ collectionView: UICollectionView, numberOfItemsInSection section: Int ) -> Int {
      return 15
   }
   
   func collectionView( _ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath ) {
      if collectionView == self.sceneCollectionView {
         let current = collectionView.cellForItem( at: indexPath ) as! SceneCollectionCell
         current.toggleUI()
      }
      else if collectionView == self.deviceCollectionView {
         let current = collectionView.cellForItem( at: indexPath ) as! DeviceCollectionCell
         current.toggleUI()
      }
   }
   
   func collectionView( _ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath ) -> UICollectionViewCell {
      if collectionView == self.deviceCollectionView {
         let cell = collectionView.dequeueReusableCell( withReuseIdentifier: "deviceCell", for: indexPath as IndexPath ) as! DeviceCollectionCell
         cell.loadCell( indexPath: indexPath )
         return cell
      }
      else if collectionView == self.roomCollectionView {
         let cell = collectionView.dequeueReusableCell( withReuseIdentifier: "roomCell", for: indexPath as IndexPath ) as! RoomCollectionCell
         cell.loadCell( indexPath: indexPath )
         return cell
      }
      else {
         let cell = collectionView.dequeueReusableCell( withReuseIdentifier: "sceneCell", for: indexPath as IndexPath ) as! SceneCollectionCell
         cell.loadCell( indexPath: indexPath )
         return cell
      }
   }
   
//   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath ) -> CGSize {
//      if collectionView == self.favoriteCollectionView {
//         let width = self.favoriteCollectionView.bounds.width
//         let height = self.favoriteCollectionView.bounds.height
//         return CGSize(width: (width - 10)/5.5, height: (height-20) )
//      }
//      let width = self.giftCollectionView.bounds.width
//      let height = self.giftCollectionView.bounds.height
//      return CGSize( width: (width - 40), height: (height-10) )
//   }
}
