//
//  WeatherApiRouter.swift
//  PuppyStep
//
//  Created by Sergey on 11/6/20.
//

import Foundation
import Alamofire

fileprivate let API_KEY = "a2fa1d6f717c4dd232d0fbddfed38a36"

enum WeatherApiRouter: URLRequestConvertible {
        
    case getCurrentWeather(cityName: String)
    
    //MARK: - URLRequestConvertible
    func asURLRequest() throws -> URLRequest {
        let url = try Constants.baseUrl.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        
        urlRequest.httpMethod = method.rawValue
        
        urlRequest.setValue(Constants.ContentType.json.rawValue, forHTTPHeaderField: Constants.HttpHeaderField.acceptType.rawValue)
        urlRequest.setValue(Constants.ContentType.json.rawValue, forHTTPHeaderField: Constants.HttpHeaderField.contentType.rawValue)
        
        let encoding: ParameterEncoding = {
            switch method {
            case .get:
                return URLEncoding.default
            default:
                return JSONEncoding.default
            }
        }()
        
        return try encoding.encode(urlRequest, with: parameters)
    }
    
    //MARK: - HttpMethod
    private var method: HTTPMethod {
        switch self {
        case .getCurrentWeather:
            return .get
        }
    }
    
    //MARK: - Path
    private var path: String {
        switch self {
        case .getCurrentWeather:
            return "data/2.5/weather"
        }
    }
    
    //MARK: - Parameters
    private var parameters: Parameters? {
        switch self {
        case .getCurrentWeather(let cityName):
            return [Constants.Parameters.appId : API_KEY, Constants.Parameters.query : cityName]
        }
    }
}
