////
//  User
//  GreenCoimbatore
//
//  Created by Kunal on 15/04/23.
//

import Foundation

struct User: Codable {
  let id: String
  let name: String
  let email: String
  
  private enum CodingKeys: String, CodingKey {
    case id = "_id", name, email
  }
}

struct CommonAPIResponse: Codable {
  let status: Bool
}
