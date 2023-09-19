//
//  SignupResponse.swift
//  GreenCoimbatore
//
//  Created by Kunal on 01/04/23.
//

import Foundation

struct AuthenticationResponse: Decodable {
    let status: Bool
    let user: User?
}
