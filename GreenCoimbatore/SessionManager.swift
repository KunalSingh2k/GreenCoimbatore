////
//  SessionManager
//  GreenCoimbatore
//
//  Created by Kunal on 15/04/23.
//

import Foundation

class SessionManager {
  static let shared = SessionManager()
  private init() {}
  
  private let defaults = UserDefaults.standard
  
  private let loggedInUserKey = "loggedIn_user"
  
  func storeUser(_ user: User) {
    let data = try! JSONEncoder().encode(user)
    defaults.setValue(data, forKey: loggedInUserKey)
  }
  
  func getUser() -> User? {
    guard let data = defaults.value(forKey: loggedInUserKey) as? Data else { return nil }
    return try! JSONDecoder().decode(User.self, from: data)
  }
  
  func logout() {
    defaults.set(nil, forKey: loggedInUserKey)
  }
}
