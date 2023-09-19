////
//  UIStoryboard
//  GreenCoimbatore
//
//  Created by Kunal on 16/04/23.
//

import UIKit
 
extension UIStoryboard {
  
  static func main() -> UIStoryboard {
    return UIStoryboard(name: "Main", bundle: Bundle.main)
  }
  
  static func homeVC() -> HomeViewController {
    return main().instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
  }

    static func viewComplaintsVC() -> ViewComplaintsViewController {
      return main().instantiateViewController(withIdentifier: "ViewComplaintsViewController") as! ViewComplaintsViewController
    }
    
    static func rootVC() -> UITabBarController {
        main().instantiateViewController(withIdentifier: "RootVC") as! UITabBarController
    }
    
    static func guestNavVC() -> UINavigationController {
        main().instantiateViewController(withIdentifier: "GuestNavVC") as! UINavigationController
    }
}
