//
//  RegisterViewController.swift
//  GreenCoimbatore
//
//  Created by Kunal on 12/03/23.
//

import UIKit
import Alamofire

class RegisterViewController: UIViewController {
  
  @IBOutlet weak var registerLabel: UILabel!
  @IBOutlet weak var nameTextField: UITextField!
  @IBOutlet weak var emailTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  @IBOutlet weak var confirmPasswordTextField: UITextField!
  @IBOutlet weak var registerButton: UIButton!
  @IBOutlet weak var cancelButton: UIButton!
  @IBOutlet weak var registerActivityIndicator: UIActivityIndicatorView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    nameTextField.roundedBorder()
    emailTextField.roundedBorder()
    passwordTextField.roundedBorder()
    confirmPasswordTextField.roundedBorder()
    registerButton.roundedBorder()
    cancelButton.roundedBorder()
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
  
  @IBAction func registerButtonHandler(_ sender: Any) {
    let name = nameTextField.text?.trim()
    let email = emailTextField.text?.trim()
    let password = passwordTextField.text?.trim()
    let confirmPassword = confirmPasswordTextField.text?.trim()
    
    if name!.isEmpty || email!.isEmpty || password!.isEmpty || confirmPassword!.isEmpty && password == confirmPassword {
      showAlert(title: "Error!", message: "Fill all necessary fields..")
      return
    }
    
    let isValid = isValidEmail(email: email!)
    if !isValid  {
      showAlert(title: "Error!", message: "Please enter a valid email..")
      return
    }
    
    showSignUpLoader()
    doSignup(name: name!, email: email!, password: password!)
  }
  
  @IBAction func CancelButtonHandler(_ sender: Any) {
  }
  
  func showSignUpLoader(shouldShow: Bool = true) {
    shouldShow ? registerActivityIndicator.startAnimating() : registerActivityIndicator.stopAnimating()
    registerButton.isHidden = shouldShow
  }
  
  func setHomeVCAsRootView() {
    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene, let delegate = windowScene.delegate as? SceneDelegate {
      delegate.window?.rootViewController = UIStoryboard.homeVC()
      delegate.window?.makeKeyAndVisible()
    }
  }
  
  func doSignup(name: String, email: String, password: String) {
    
    let parameters = ["name": name, "email": email, "password": password]
    
    AF.request(Endpoint.signUp, method: .post, parameters: parameters).responseDecodable(of: AuthenticationResponse.self) { response in
      
      switch response.result {
      case .success(let signupResponse):
        if let user = signupResponse.user {
          SessionManager.shared.storeUser(user)
          self.setHomeVCAsRootView()
        }
      case .failure(let error):
        self.showSignUpLoader(shouldShow: false)
        self.showAlert(title: "Error", message: error.localizedDescription)
      }
    }
  }
}
