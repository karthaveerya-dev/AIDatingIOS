//
//  ProfileDetailsModel.swift
//  AIDating
//
//  Created by Mihail Konoplitskyi on 17.04.2021.
//

import Foundation

struct ProfileDetailsResponseModel: Codable {
    var profile: ProfileDetailsModel
    
    enum CodingKeys: String, CodingKey {
        case profile = "data"
    }
}

struct ProfileDetailsModel: Codable {
    var userID: Int
    var userName: String
    var location: String
    var distanceTo: Int
    var distanceFrom: Int
    var sex: LookingForType
    var ageFrom: Int
    var ageTo: Int
    var latitude: Double
    var lontitude: Double
    
    enum CodingKeys: String, CodingKey {
        case userName = "user_name"
        case userID = "user_id"
        case location = "location"
        case distanceTo = "distance_to"
        case distanceFrom = "distance_from"
        case sex = "sex"
        case ageFrom = "age_from"
        case ageTo = "age_to"
        case latitude = "coord_lat"
        case lontitude = "coord_lon"
    }
}
