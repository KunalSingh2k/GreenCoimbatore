//
//  ViewComplaintsViewController.swift
//  GreenCoimbatore
//
//  Created by Kunal on 25/03/23.
//

import UIKit
import Alamofire

class ViewComplaintsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
  
  @IBOutlet weak var viewComplaintsTableView: UITableView!
  
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  
  var complaints: [Complaint] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    setupView()
  }
  
  func setupView() {
    activityIndicator.startAnimating()
    viewComplaintsTableView.isHidden = true
    fetchComplaints()
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return complaints.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ViewComplaintsTableViewCell", for: indexPath) as! ComplaintTableViewCell
    let complaint = complaints[indexPath.row]
    cell.bind(complaint)
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let vc = UIStoryboard.homeVC()
    vc.complaint = complaints[indexPath.row]
    present(vc, animated: true)
  }
  
}

private extension ViewComplaintsViewController {
  
  func fetchComplaints() {
    let endpoint = Endpoint.complaints
    
    guard let userId = SessionManager.shared.getUser()?.id else { return }
    let parameters = ["userId": userId]
    
    AF.request(endpoint, method: .get, parameters: parameters).responseDecodable(of: [Complaint].self) { response in
      self.viewComplaintsTableView.isHidden = false
      self.activityIndicator.stopAnimating()
      
      switch response.result {
      case .success(let complaints):
        self.complaints = complaints
        self.viewComplaintsTableView.reloadData()
        
      case .failure(let error):
        print(error.localizedDescription)
      }
    }
  }
}
