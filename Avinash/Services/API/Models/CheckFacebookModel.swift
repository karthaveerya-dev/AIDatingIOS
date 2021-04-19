//
//  CheckFacebookModel.swift
//  AIDating
//
//  Created by Mihail Konoplitskyi on 17.04.2021.
//

import Foundation

struct CheckFacebookResponseModel: Codable {
    var profile: CheckFacebookModel
    
    enum CodingKeys: String, CodingKey {
        case profile = "data"
    }
}

struct CheckFacebookModel: Codable {
    var isConnected: Bool
    
    enum CodingKeys: String, CodingKey {
        case isConnected = "social_token_status"
    }
}
