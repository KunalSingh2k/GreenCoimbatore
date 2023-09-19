//
//  ViewController.swift
//  GreenCoimbatore
//
//  Created by Kunal  on 21/03/23.
//

import UIKit
import Alamofire

class LogInViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
    @IBOutlet weak var loginActivityIndicator: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        emailTextField.roundedBorder()
        passwordTextField.roundedBorder()
        logInButton.roundedBorder()
        registerButton.roundedBorder()
        
        emailTextField.text = "jp@gmail.com"
        passwordTextField.text = "Test123@"
        
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction.init(title: "OK", style: .default)
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    func isValidEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format: "Self matches %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    @IBAction func logInButtonHandler(_ sender: Any) {
        let email = emailTextField.text?.trim()
        let password = passwordTextField.text?.trim()
        
        if email!.isEmpty || password!.isEmpty {
            showAlert(title: "Error!", message: "Fill all necessary fields..")
        }
        let isValid = isValidEmail(email: email!)
        if !isValid {
            showAlert(title: "Error!", message: "Please enter a valid email..")
        }
        showSignInLoader()
        doSignIn(email: email!, password: password!)
    }
    
    @IBAction func registerButtonHandler(_ sender: Any) {
    }
    
    func showHomeView() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene, let delegate = windowScene.delegate as? SceneDelegate {
            let navVC = UINavigationController(rootViewController: UIStoryboard.rootVC())
            delegate.window?.rootViewController = navVC
            delegate.window?.makeKeyAndVisible()
        }
    }
    
    func doSignIn(email: String, password: String) {
        let parameters = ["email": email, "password": password]
        AF.request(Endpoint.signIn, method: .post, parameters: parameters).responseDecodable(of: AuthenticationResponse.self) { response in
            switch response.result {
            case .success(let signInResponse):
                if let user = signInResponse.user {
                    SessionManager.shared.storeUser(user)
                    self.showHomeView()
                }
            case .failure(let error):
                self.showSignInLoader(shouldShow: false)
                self.showAlert(title: "Error", message: error.localizedDescription)
            }
        }
        
    }
    
    @IBAction func unwindFromRegister(segue: UIStoryboardSegue) {
        
    }
    
    func showSignInLoader(shouldShow: Bool = true) {
        shouldShow ? loginActivityIndicator.startAnimating() : loginActivityIndicator.stopAnimating()
        logInButton.isHidden = shouldShow
    }
}

struct Endpoint {
    static let host = "http://13.127.77.248/clean-city"
    static let api = "/api/"
    static let signIn = host + api + "signIn"
    static let signUp = host + api + "signUp"
    static let complaints = host + api +  "complaints"
}
