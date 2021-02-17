//
//  NetworkHelper.swift
//  Thor
//
//  Created by Mihail Konoplitskyi on 10/18/17.
//  Copyright © 2017 Mihail Konoplitskyi. All rights reserved.
//

import Foundation
import Alamofire

class NetworkHelper: NSObject {
    fileprivate let url = "http://aidatingapi.dev2.4k.com.ua"
//    fileprivate let url = "https://touristdoc.dev2.4k.com.ua"
//    static let sharedUrl = "https://touristdoc.dev2.4k.com.ua"
    
    func get(method: String, success: @escaping (Any) -> Void) {
        self.get(method: method, params: nil, headers: nil, success: success, failure: nil)
    }
    
    func get(method: String, params: [String: String]?, headers: [String: String]?, success: @escaping (Any) -> Void, error: (()->Void)?) {
        self.get(method: method, params: params, headers: headers, success: success, failure: error)
    }
    
    func post(method: String, params: [String: Any]?, headers: [String:String]?, error: ((NetworkError)->Void)?, success: @escaping (Any) -> Void) {
        self.post(method: method, params: params, headers: headers, success: success, failure: error)
    }
    
    func postImage(method: String, params: [String:Any]?, userHeaders: [String:String]?, success: @escaping (Any) -> Void, failure: ((NetworkError) -> Void)?) {
        var headers = [String:String]()
        
        if let userHeaders = userHeaders {
            headers.merge(userHeaders) { (current, _) in current }
        }
        
        guard let params = params else {
            if let failure = failure {
                failure(.technicalErrorOnClientSide)
            }
            return
        }
        
        AF.upload(multipartFormData: { (formData) in
            params.keys.enumerated().forEach({ (index, key) in
                if let value = params[key] {
                    if let image = value as? UIImage,
                       let imageData = image.jpegData(compressionQuality: 0.6) {
                        formData.append(imageData, withName: key, fileName: "file.jpeg", mimeType: "image/jpeg")
                    } else {
                        if let valueString = value as? String,
                            let valueData = valueString.data(using: .utf8) {
                            formData.append(valueData, withName: key)
                        }
                    }
                }
            })
        }, to: url+method, usingThreshold: UInt64.init(), method: .post, headers: HTTPHeaders(headers)).responseJSON { (data) in
            switch data.result {
            case .success(let jsonData):
                success(jsonData)
            case .failure(let error):
                print(error)
                debugPrint(error.localizedDescription)
                if let failure = failure {
                    let networkError = self.getNetworkError(error: error)
                    failure(networkError)
                }
            }
        }
    }
    
    func post(method: String, params: [String:Any]?, headers: [String:String]?, success: @escaping (Any?) -> Void, failure: ((NetworkError) -> Void)?) {
        AF.request(url+method, method: .post, parameters: params, encoding: URLEncoding.httpBody, headers: HTTPHeaders(headers ?? [:])).responseJSON { [weak self] (result) in
            if let jsonData = result.value {
                if self?.checkIfUnauthorizeNeeded(value: jsonData) == true {
                    return
                }
                
                success(jsonData)
            } else if let failure = failure {
                if let networkError = self?.getNetworkError(error: result.error) {
                    failure(networkError)
                }
            }
        }
    }
    
    func put(method: String, params: [String:Any]?, userHeaders: [String:String]?, success: @escaping (Any?) -> Void, failure: (() -> Void)?) {
        var headers = [
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        
        if let userHeaders = userHeaders {
            headers.merge(userHeaders) { (current, _) in current }
        }
        
        AF.request(url+method, method: .put, parameters: params, encoding: URLEncoding.httpBody, headers: HTTPHeaders(headers)).responseJSON { (result) in
            if let jsonData = result.value {
                if self.checkIfUnauthorizeNeeded(value: jsonData) == true {
                    return
                }
                
                success(jsonData)
            } else if let failure = failure {
                print("FAILURE: ")
                print(result.error as Any)
                failure()
            }
        }
    }
    
    func delete(method: String, params: [String:Any]?, userHeaders: [String:String]?, success: @escaping (Any?) -> Void, failure: (() -> Void)?) {
        var headers = [
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        
        if let userHeaders = userHeaders {
            headers.merge(userHeaders) { (current, _) in current }
        }
        
        AF.request(url+method, method: .delete, parameters: params, encoding: URLEncoding.httpBody, headers: HTTPHeaders(headers)).responseJSON { (result) in
            if let jsonData = result.value {
                success(jsonData)
            } else if let failure = failure {
                print("FAILURE: ")
                print(result.error as Any)
                failure()
            }
        }
    }
    
    func get(method: String, params: [String:String]?, headers: [String:String]?, success: @escaping (Any?) -> Void, failure: (() -> Void)?) {
        
        let url = self.url(method: method, params: params)
        AF.request(url, method: .get, parameters: params, encoding: URLEncoding.httpBody, headers: HTTPHeaders(headers ?? [:])).responseJSON { (result) in
            if let jsonData = result.value {
                success(jsonData)
            } else if let failure = failure {
                print("FAILURE: ")
                print(result.error as Any)
                failure()
            }
        }
    }
    
    // MARK: - Private
    fileprivate func url(method: String, params: [String: String]?) -> String {
        var url = self.url + method
        
        url += "?"
        if let params = params, params.keys.count > 0 {
            for key in params.keys {
                if let value = params[key] {
                    url += key + "=" + value + "&"
                }
            }
        }
        
        if let url = url.substring(to: url.length - 1) {
            return url
        }
        
        return url
    }
    
    private func checkIfUnauthorizeNeeded(value: Any) -> Bool {
//        do {
//            if let data = try? JSONSerialization.data(withJSONObject: value as Any, options: .prettyPrinted) {
//                let defaultResponseModel = try JSONDecoder().decode(DefaultResponseModel.self, from: data)
//                if !defaultResponseModel.response.status && defaultResponseModel.response.code == 333 {
//                    AuthorizationService.shared.state = .noneAuthorized
//                    return true
//                }
//            }
//        } catch (let error) {
//            print(error.localizedDescription)
//            return false
//        }
        
        return false
    }
}

//MARK: -  helpers and handlers
extension NetworkHelper {
    private func getNetworkError(error: Error?) -> NetworkError {
        if let error = error as? AFError {
            switch error {
            case .invalidURL(let url):
                print("invalidURL \(url)")
            case .parameterEncodingFailed(let reason):
                print("parameterEncodingFailed - \(reason)")
            case .multipartEncodingFailed(let reason):
                print("multipartEncodingFailed \(reason)")
            case .responseValidationFailed(let reason):
                switch reason {
                case .customValidationFailed(error: let error):
                    print("dataFileReadFailed \(error)")
                case .dataFileNil:
                    print("dataFileNil")
                case .dataFileReadFailed(let at):
                    print("dataFileReadFailed \(at)")
                case .missingContentType(let acceptableContentTypes):
                    print("missingContentType \(acceptableContentTypes)")
                case .unacceptableContentType(let acceptableContentTypes, let responseContentType):
                    print("acceptableContentTypes \(acceptableContentTypes)\nresponseContentType \(responseContentType)")
                case .unacceptableStatusCode(let code):
                    print("unacceptableStatusCode \(code)")
                }
                
                return .technicalErrorOnClientSide
            case .responseSerializationFailed(let reason):
                switch reason {
                case .inputDataNilOrZeroLength:
                    print("inputDataNilOrZeroLength")
                case .inputFileNil:
                    print("inputFileNil")
                case .inputFileReadFailed(let at):
                    print("inputFileReadFailed \(at)")
                case .stringSerializationFailed(let encoding):
                    print("stringSerializationFailed \(encoding)")
                case .jsonSerializationFailed(let error):
                    print("jsonSerializationFailed \(error)")
                case .decodingFailed(error: let error):
                    print("decodingFailed \(error)")
                case .customSerializationFailed(error: let error):
                    print("customSerializationFailed \(error)")
                case .invalidEmptyResponse(type: let type):
                    print("invalidEmptyResponse \(type)")
                }
                
                return .errorParsingJson
            case .createUploadableFailed(error: let error):
                print("createUploadableFailed \(error)")
            case .createURLRequestFailed(error: let error):
                print("createURLRequestFailed \(error)")
            case .downloadedFileMoveFailed(error: let error, source: _, destination: _):
                print("downloadedFileMoveFailed \(error)")
            case .explicitlyCancelled:
                print("explicitlyCancelled")
            case .parameterEncoderFailed(reason: let reason):
                print("parameterEncoderFailed \(reason)")
            case .requestAdaptationFailed(error: let error):
                print("requestAdaptationFailed \(error)")
            case .requestRetryFailed(retryError: _, originalError: let originalError):
                print("requestRetryFailed \(originalError)")
            case .serverTrustEvaluationFailed(reason: let reason):
                print("serverTrustEvaluationFailed \(reason)")
            case .sessionDeinitialized:
                print("sessionDeinitialized")
            case .sessionInvalidated(error: let error):
                print("sessionInvalidated \(error?.localizedDescription ?? "")")
            case .sessionTaskFailed(error: let error):
                print("sessionTaskFailed \(error)")
            case .urlRequestValidationFailed(reason: let reason):
                print("urlRequestValidationFailed \(reason)")
            }
        } else if let error = error as? URLError {
            if error.code == .networkConnectionLost || error.code == .notConnectedToInternet {
                return .networkIsUnavailable
            } else if error.code == .cannotFindHost || error.code == .cannotConnectToHost {
                return .serverIsUnavailable
            } else if error.code == .timedOut {
                return .requestTimedOut
            }
            
            print(error)
        } else {
            print("Unknown error")
        }
        
        return NetworkError.unknown
    }
}
