//
//  ComplaintTableViewCell.swift
//  GreenCoimbatore
//
//  Created by Kunal on 26/03/23.
//

import UIKit

class ComplaintTableViewCell: UITableViewCell {
  
  @IBOutlet weak var titleLabel: UILabel!
  
  @IBOutlet weak var subTitleLabel: UILabel!
  
  @IBOutlet weak var rightArrowImageView: UIImageView!
  
  @IBOutlet weak var containerView: UIView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    contentView.backgroundColor = .white
    containerView.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
    containerView.layer.shadowOpacity = 1
    containerView.layer.shadowOffset = .zero
    containerView.layer.shadowRadius = 2
    containerView.layer.cornerRadius = 5
  }
  
  func bind(_ complaint: Complaint) {
    titleLabel.text = complaint.title.capitalized
    subTitleLabel.text = complaint.createdAt
  }
}
