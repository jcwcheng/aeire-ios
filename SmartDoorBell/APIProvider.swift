//
//  APIProvider.swift
//  SmartDoorBell
//
//  Created by Archerwind on 4/17/17.
//  Copyright © 2017 Archerwind. All rights reserved.
//

import Foundation
import Moya

public func url( route: TargetType ) -> String {
   return route.baseURL.appendingPathComponent( route.path ).absoluteString
}

let endpointClosure = { ( target: GiftpackAPIService ) -> Endpoint<GiftpackAPIService> in
   return Endpoint<GiftpackAPIService>( url: url(route: target), sampleResponseClosure: {.networkResponse(200, target.sampleData)}, method: target.method, parameters: target.parameters )
}
