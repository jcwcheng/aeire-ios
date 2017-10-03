//
//  CounterRealm.swift
//  SmartDoorBell
//
//  Created by Archerwind on 4/18/17.
//  Copyright © 2017 Archerwind. All rights reserved.
//

import Foundation
import RealmSwift

class CounterRealm: Object {
   dynamic var id: String = String()
   dynamic var counter: Int = Int()
   
   override class func primaryKey() -> String? {
      return "id"
   }
}
