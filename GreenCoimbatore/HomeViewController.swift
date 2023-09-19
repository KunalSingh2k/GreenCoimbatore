//
//  HomeViewController.swift
//  GreenCoimbatore
//
//  Created by Kunal on 22/03/23.
//

import UIKit
import GoogleMaps
import Alamofire

class HomeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  @IBOutlet weak var mapView: UIView!
  
  @IBOutlet weak var addressTextView: UITextView!
  
  @IBOutlet weak var descriptionTextField: UITextField!
  
  @IBOutlet weak var cameraButton: UIButton!
  
  @IBOutlet weak var doneButton: UIButton!
  
  @IBOutlet weak var doneActivityIndicator: UIActivityIndicatorView!
  
  @IBOutlet weak var imageContainerStackView: UIStackView!
  
  var complaint: Complaint?
  
  private var location: CLLocation?
  
  private var locationManager = CLLocationManager()
  
  private var gsMapView = GMSMapView()
  
  private var marker = GMSMarker()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    addressTextView.roundedBorder()
    descriptionTextField.roundedBorder()
    cameraButton.roundedBorder()
    doneButton.roundedBorder()
    doneButton.isHidden = false
    
    if let existingComplaint = complaint {
      doneButton.isHidden = true
      addressTextView.text = existingComplaint.address
      descriptionTextField.text = existingComplaint.title
      
      for imageUrl in existingComplaint.attachments {
        downloadImage(from: imageUrl)
      }
      
      let latitude = existingComplaint.location.latitude
      let longitude = existingComplaint.location.longitude
      
      fetchFullAddress(latitude: latitude, longitude: longitude)
      
      let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: 10.0)
      let gmsMapView = GMSMapView.map(withFrame: self.mapView.frame, camera: camera)
      mapView.addSubview(gmsMapView)
      
      marker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
      marker.map = gmsMapView
      return
    }
    
    locationManager.requestWhenInUseAuthorization()
    
    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
    locationManager.startUpdatingLocation()
  }
  
  @IBAction func cameraButtonHandler(_ sender: Any) {
    guard imageContainerStackView.arrangedSubviews.count < 2 else {
      showAlert(title: "Error!!", message: "Already selected maximum number of photos!! ")
      return
    }
    
    let imagePicker = UIImagePickerController()
    imagePicker.sourceType = .photoLibrary
    imagePicker.delegate = self
    present(imagePicker,animated: true)
  }
  
  public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    if let image = info[.originalImage] as? UIImage {
      let imageView = UIImageView()
      imageView.translatesAutoresizingMaskIntoConstraints = false
      imageView.widthAnchor.constraint(equalToConstant: 80.0).isActive = true
      imageView.image = image
      imageContainerStackView.addArrangedSubview(imageView)
    }
    
    picker.dismiss(animated: true, completion: nil)
  }
  
  @IBAction func doneButtonHandler(_ sender: Any) {
    let name = descriptionTextField.text?.trim()
    
    if name!.isEmpty {
      showAlert(title: "Error!", message: "Description is required")
      return
    }
    
    if imageContainerStackView.subviews.count == 0 {
      showAlert(title: "Error!", message: "Atleast one image needs to be uploaded")
      return
    }
    
    showLoader()
    createComplaint()
  }
}

extension HomeViewController: CLLocationManagerDelegate {
  
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    
    guard status == .authorizedWhenInUse else {
      return
    }
    
    locationManager.startUpdatingLocation()
    
    gsMapView.isMyLocationEnabled = true
    gsMapView.settings.myLocationButton = true
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    
    guard let location = locations.first else {
      return
    }
    
    self.location = location
    fetchFullAddress(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
    
    let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: 10.0)
    let gmsMapView = GMSMapView.map(withFrame: self.mapView.frame, camera: camera)
    mapView.addSubview(gmsMapView)
    
    marker.position = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
    marker.map = gmsMapView
  }
  
  func fetchFullAddress(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
    let geoCoder = CLGeocoder()
    let location = CLLocation(latitude: latitude, longitude: longitude)
    geoCoder.reverseGeocodeLocation(location) { placemark, error -> Void in
      guard let placemark = placemark?.first else {return}
      
      var fullAddress = ""
      
      // Street address
      if let streetAddress = placemark.thoroughfare {
        fullAddress = fullAddress + "\(streetAddress)"
      }
      // subLocality Name
      if let locationName = placemark.subLocality {
        fullAddress = fullAddress + "," + "\n" + "\(locationName)"
      }
      // City
      if let cityName = placemark.subAdministrativeArea {
        fullAddress = fullAddress + "," + "\n" + "\(cityName)"
      }
      // Postal code
      if let postalCode = placemark.postalCode {
        fullAddress = fullAddress + "," + "\(postalCode)"
      }
      //  Country
      if let country = placemark.country {
        fullAddress = fullAddress + "," + "\n" + "\(country)"
      }
      self.addressTextView.text = fullAddress
    }
  }
  
}

private extension HomeViewController {
  
  func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
    URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
  }
  
  func downloadImage(from url: URL) {
    getData(from: url) { data, response, error in
      guard let data = data, error == nil else { return }
      
      DispatchQueue.main.async() { [weak self] in
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: 80.0).isActive = true
        imageView.image = UIImage(data: data)
        self?.imageContainerStackView.addArrangedSubview(imageView)
      }
    }
  }
  
  
  func showAlert(title: String, message: String) {
    let alert = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
    let action = UIAlertAction.init(title: "OK", style: .default)
    alert.addAction(action)
    present(alert, animated: true)
  }
  
  func showLoader(shouldShow: Bool = true) {
    shouldShow ? doneActivityIndicator.startAnimating() : doneActivityIndicator.stopAnimating()
    doneButton.isHidden = shouldShow
  }
  
  func createComplaint() {
    guard let location = self.location else { return }
    
    let headers: HTTPHeaders = [
      "Content-type": "multipart/form-data"
    ]
    
    AF.upload(multipartFormData: { multipartData in
      let userId = SessionManager.shared.getUser()!.id
      multipartData.append(userId.data(using: .utf8, allowLossyConversion: false)!, withName: "userId")
      multipartData.append("\(location.coordinate.latitude)".data(using: .utf8, allowLossyConversion: false)!, withName: "latitude")
      multipartData.append("\(location.coordinate.longitude)".data(using: .utf8, allowLossyConversion: false)!, withName: "longitude")
      multipartData.append(self.addressTextView.text!.data(using: .utf8, allowLossyConversion: false)!, withName: "address")
      multipartData.append(self.descriptionTextField.text!.data(using: .utf8, allowLossyConversion: false)!, withName: "description")
      
      for (index, imageView) in self.imageContainerStackView.arrangedSubviews.enumerated() {
        if let image = (imageView as? UIImageView)?.image {
          multipartData.append(image.jpegData(compressionQuality: 0.5)!, withName: "media[\(index)]", fileName: "a\(index).jpg")
        }
      }
    }, to: Endpoint.complaints, method: .post, headers: headers).responseDecodable(of: CommonAPIResponse.self) { response in
      self.showLoader(shouldShow: false)
      
      switch response.result {
      case .success(let apiResponse):
        if apiResponse.status {
          self.descriptionTextField.text = ""
          self.imageContainerStackView.subviews.forEach({ $0.removeFromSuperview() })
          self.showAlert(title: "Success!!", message: "Your complaint was registered successfully")
        }
      case .failure(let error):
        self.showAlert(title: "Error!!", message: error.localizedDescription)
      }
    }
  }
}
