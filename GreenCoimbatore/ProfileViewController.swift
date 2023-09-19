//
//  ProfileViewController.swift
//  GreenCoimbatore
//
//  Created by DQI on 19/04/23.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let user = SessionManager.shared.getUser() {
            nameLabel.text = user.name
            emailLabel.text = user.email
        }
    }
    
    @IBAction func logoutHandler() {
        SessionManager.shared.logout()
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene, let delegate = windowScene.delegate as? SceneDelegate {
            let navVC = UIStoryboard.guestNavVC()
            delegate.window?.rootViewController = navVC
            delegate.window?.makeKeyAndVisible()
        }
    }

}
