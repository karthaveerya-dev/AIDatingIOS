//
//  ProfileModel.swift
//  AIDating
//
//  Created by Mihail Konoplitskyi on 17.02.2021.
//

import Foundation

struct ProfileResponseModel: Codable {
    var profile: ProfileModel
    
    enum CodingKeys: String, CodingKey {
        case profile = "data"
    }
}

struct ProfileModel: Codable {
    var userName: String
    var userID: Int
    var email: String
    var status: Int
    var accessToken: String
    
    enum CodingKeys: String, CodingKey {
        case userName = "username"
        case userID = "id"
        case email = "email"
        case status = "status"
        case accessToken = "accessToken"
    }
}
