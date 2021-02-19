//
//  DefaultResponseModel.swift
//  Touristdoc
//
//  Created by Mihail Konoplitskyi on 20.03.2020.
//  Copyright © 2020 4K-SOFT. All rights reserved.
//

import Foundation

struct DefaultResponseModel: Codable {
    var status: Bool
    var statusCode: Int?
    var errorCode: Int?
    var errorText: String?
    
    enum CodingKeys: String, CodingKey {
        case status = "status"
        case statusCode = "statusCode"
        case errorCode = "errorCode"
        case errorText = "errorDescription"
    }
}
