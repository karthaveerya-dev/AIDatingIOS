//
//  ProfileService.swift
//  AIDating
//
//  Created by Mihail Konoplitskyi on 17.02.2021.
//

import Foundation
import UIKit

class ProfileService: NSObject {
    static let shared = ProfileService()
    private let api = NetworkHelper()
    
    func uploadPhotos(images: [UIImage], handleNetworkError: (()->Void)?, success: @escaping (Data) -> Void) {
        let method = "/api/photo/save-file"
        var params = [String:Any]()
        
        images.enumerated().forEach { (idx, image) in
            params["photo[\(idx)]"] = image
        }
        
        let networkToken = AuthorizationService.shared.networkToken
        let headers = ["accessToken": networkToken]
        
        api.postImage(method: method, params: params, userHeaders: headers, success: { (res) in
            if let data = try? JSONSerialization.data(withJSONObject: res, options: .prettyPrinted) {
                success(data)
            } else {
                if let handleNetworkError = handleNetworkError {
                    handleNetworkError()
                }
            }
        }) {_ in
            if let handleNetworkError = handleNetworkError {
                handleNetworkError()
            }
        }
    }
    
    func saveProfile(username: String,
                     locationString: String,
                     distanceFrom: Int,
                     distanceTo: Int,
                     sex: LookingForType,
                     ageFrom: Int,
                     ageTo: Int,
                     longtitude: Double,
                     latitude: Double,
                     handleNetworkError: ((NetworkError)->Void)?,
                     success: @escaping (Data) -> Void) {
        let method = "/api/profile/save-profile"
        var params = [String:Any]()
        
        var headers = [String: String]()
        headers["accessToken"] = AuthorizationService.shared.networkToken
        
        params["username"] = username
        params["location"] = locationString
        params["distance_from"] = distanceFrom
        params["distance_to"] = distanceTo
        params["sex"] = sex.rawValue
        params["age_from"] = ageFrom
        params["age_to"] = ageTo
        params["coord_lon"] = longtitude
        params["coord_lat"] = latitude
        
        api.post(method: method, params: params, headers: headers, error: { (error) in
            if let handleNetworkError = handleNetworkError {
                handleNetworkError(error)
            }
        }) { (res) in
            if let data = try? JSONSerialization.data(withJSONObject: res as Any, options: .prettyPrinted) {
                success(data)
            } else {
                if let handleNetworkError = handleNetworkError {
                    handleNetworkError(.errorParsingJson)
                }
            }
        }
    }
    
    func getProfile(handleNetworkError: ((NetworkError)->Void)?,
                    success: @escaping (Data) -> Void) {
        let method = "/api/profile/get-profile"
        let params = [String:Any]()
        
        var headers = [String: String]()
        headers["accessToken"] = AuthorizationService.shared.networkToken
        
        api.post(method: method, params: params, headers: headers, error: { (error) in
            if let handleNetworkError = handleNetworkError {
                handleNetworkError(error)
            }
        }) { (res) in
            if let data = try? JSONSerialization.data(withJSONObject: res as Any, options: .prettyPrinted) {
                success(data)
            } else {
                if let handleNetworkError = handleNetworkError {
                    handleNetworkError(.errorParsingJson)
                }
            }
        }
    }
    
    func checkIfFacebookConnected(handleNetworkError: ((NetworkError)->Void)?,
                                  success: @escaping (Data) -> Void) {
        let method = "/api/user/check-social-token-status"
        var params = [String:Any]()
        params["social_net"] = SocialNetworks.facebook.rawValue
        
        var headers = [String: String]()
        headers["accessToken"] = AuthorizationService.shared.networkToken
        
        api.post(method: method, params: params, headers: headers, error: { (error) in
            if let handleNetworkError = handleNetworkError {
                handleNetworkError(error)
            }
        }) { (res) in
            if let data = try? JSONSerialization.data(withJSONObject: res as Any, options: .prettyPrinted) {
                success(data)
            } else {
                if let handleNetworkError = handleNetworkError {
                    handleNetworkError(.errorParsingJson)
                }
            }
        }
    }
    
    func saveFacebookToken(accessToken: String,
                           facebookUserID: String,
                           handleNetworkError: ((NetworkError)->Void)?,
                           success: @escaping (Data) -> Void) {
        let method = "/api/user/save-social-token"
        
        var params = [String:Any]()
        params["social_token"] = accessToken
        params["social_net"] = SocialNetworks.facebook.rawValue
        params["key"] = facebookUserID
        
        var headers = [String: String]()
        headers["accessToken"] = AuthorizationService.shared.networkToken
        
        api.post(method: method, params: params, headers: headers, error: { (error) in
            if let handleNetworkError = handleNetworkError {
                handleNetworkError(error)
            }
        }) { (res) in
            if let data = try? JSONSerialization.data(withJSONObject: res as Any, options: .prettyPrinted) {
                success(data)
            } else {
                if let handleNetworkError = handleNetworkError {
                    handleNetworkError(.errorParsingJson)
                }
            }
        }
    }
}

extension ProfileService {
    enum SocialNetworks: Int {
        case facebook = 1
        case gmail = 2
    }
}
