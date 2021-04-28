//
//  AuthorizationService.swift
//  Hushhh
//
//  Created by Mihail Konoplitskyi on 6/7/19.
//  Copyright © 2019 4K-SOFT. All rights reserved.
//

import Foundation
import UserNotifications

protocol AuthorizationServiceDelegate: class {
    func authStateChanged(to state: AuthorizationService.AuthorizationState)
}

class AuthorizationService: NSObject {
    static let shared = AuthorizationService()
    
    private let authStateKey = "authStateKey"
    private let networkTokenKey = "networkToken"
    private let userNameKey = "userNameKey"
    
    private let api = NetworkHelper()
    
    weak var delegate: AuthorizationServiceDelegate?
    
    var state: AuthorizationState {
        get {
            var state: AuthorizationState = .noneAuthorized
            if let currStateValue = UserDefaults.standard.object(forKey: authStateKey) as? Int,
               let currentState = AuthorizationState(rawValue: currStateValue) {
                    state = currentState
            }
            
            return state
        }
        
        set(newState) {
            if newState == .noneAuthorized {
                //clean up UserDefaults and other things that we no longer need
                cleanupAllCache()
            }
            
            UserDefaults.standard.set(newState.rawValue, forKey: authStateKey)
            delegate?.authStateChanged(to: newState)
        }
    }
    
    var networkToken: String {
        get {
            var token: String = ""
            if let currToken = UserDefaults.standard.object(forKey: networkTokenKey) as? String {
                token = currToken
            }
            
            return token
        }
        
        set(newToken) {
            UserDefaults.standard.set(newToken, forKey: networkTokenKey)
        }
    }
    
    var userName: String {
        get {
            var name: String = ""
            if let currName = UserDefaults.standard.object(forKey: userNameKey) as? String {
                name = currName
            }
            
            return name
        }
        
        set(newName) {
            UserDefaults.standard.set(newName, forKey: userNameKey)
        }
    }
    
    func cleanupAllCache() {
        //updateAPNSToken(apnsToken: "")
        
        networkToken = ""
        userName = ""
    }
    
    func registerUser(email: String,
                      username: String,
                      password: String,
                      handleNetworkError: ((NetworkError)->Void)?, success: @escaping (Data) -> Void) {
        let method = "/api/user/registration"
        var params = [String:Any]()
        
        params["email"] = email
        params["username"] = username
        params["password"] = password
        
        api.post(method: method, params: params, headers: nil, error: { (error) in
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
    
    func signIn(email: String,
                password: String,
                handleNetworkError: ((NetworkError)->Void)?, success: @escaping (Data) -> Void) {
        let method = "/api/user/auth"
        var params = [String:Any]()
        
        params["email"] = email
        params["password"] = password
        
        api.post(method: method, params: params, headers: nil, error: { (error) in
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
    
    func signInWithGoogle(networkType: SocialNetworkType,
                          email: String,
                          token: String,
                          handleNetworkError: ((NetworkError)->Void)?, success: @escaping (Data) -> Void) {
        let method = "/api/user/rasocialnet"
        var params = [String:Any]()
        
        params["social_net"] = networkType.rawValue
        params["email"] = email
        params["token"] = token
        
        api.post(method: method, params: params, headers: nil, error: { (error) in
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

extension AuthorizationService {
    enum AuthorizationState: Int {
        case noneAuthorized = 0
        case authorized = 1
    }
    
    enum SocialNetworkType: Int {
        case facebook = 1
        case google = 2
    }
}
