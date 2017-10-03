//
//  GiftpackMoyaAPIService.swift
//  Giftpack Delivery
//
//  Created by Archerwind on 1/28/17.
//  Copyright © 2017 Giftpack. All rights reserved.
//

import Foundation
import Moya

enum GiftpackAPIService {
   // User API
   case register( phone: String, countryCode: String, password: String )
   
}

// MARK: - TargetType Protocol Implementation

extension GiftpackAPIService: TargetType {
   
   var baseURL: URL {
      return URL( string: "https://client.giftpack.io/api/giftpack/ios/v1" )!
   }
   
   var path: String {
      switch self {
      case .register: return "/user"
      }
   }
   
   var method: Moya.Method {
      switch self {
      case .register: return .post
      }
   }
   
   var parameters: [ String: Any ]? {
      switch self {
      case .register( let phone, let countryCode, let password ):
         return ["user_phone": phone, "country_code": countryCode, "user_password": password]
      }
   }
   
   var multipartBody: [MultipartFormData]? {
      switch self {
      default:
         return nil
      }
   }
   
   var parameterEncoding: ParameterEncoding {
      switch self {
      case .register:
         return URLEncoding.default
      }
   }
   
   var sampleData: Data {
      return "".utf8Encoded
   }
   
   var task: Task {
      switch self {
      case .register:
         return .request
      }
   }
   
   var validate: Bool {
      return false
   }
}

// MARK: - Moya Helpers

private extension String {
   
   var urlEscaped: String {
      return self.addingPercentEncoding( withAllowedCharacters: .urlHostAllowed )!
   }
   
   var utf8Encoded: Data {
      return self.data( using: .utf8 )!
   }
}
