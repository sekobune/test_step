//
//  NetworkConstants.swift
//  PuppyStep
//
//  Created by Sergey on 11/6/20.
//

import Foundation

struct Constants {
    
    static let baseUrl = "https://api.openweathermap.org"
    static let baseUrlSource = "https://openweathermap.org"
    
    struct Parameters {
        static let query = "q"
        static let appId = "appid"
        static let language = "lang"
    }
    
    enum HttpHeaderField: String {
        case authentication = "Authorization"
        case contentType = "Content-Type"
        case acceptType = "Accept"
        case acceptEncoding = "Accept-Encoding"
    }
    
    enum ContentType: String {
        case json = "application/json"
    }
    
    enum ApiError: Error {
        case forbidden // 403
        case notFound // 404
        case conflict // 409
        case internalServerError // 500
    }
}
