//
//  Complaint.swift
//  GreenCoimbatore
//
//  Created by DQI Technologies on 16/04/23.
//

import Foundation
import CoreLocation

struct Complaint: Decodable {
    let id: String
    let title: String
    let location: CLLocationCoordinate2D
    let attachments: [URL]
    let createdAt: String
    let address: String
    
    private enum CodingKeys: String, CodingKey {
        case id = "id", title = "description", latitude, longitude, attachments, address
        case createdAt = "createdOn"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        createdAt = try container.decode(String.self, forKey: .createdAt)
        address = try container.decode(String.self, forKey: .address)
        
        let latitude = try container.decode(String.self, forKey: .latitude)
        let longitude = try container.decode(String.self, forKey: .longitude)
        
        location = CLLocationCoordinate2D(latitude: Double(latitude) ?? 0.0, longitude: Double(longitude) ?? 0.0)
      attachments =  try container.decode([URL].self, forKey: .attachments)
    }
}
