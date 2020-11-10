//
//  WeatherApiClient.swift
//  PuppyStep
//
//  Created by Sergey on 11/6/20.
//

import Foundation
import Alamofire
import RxSwift

typealias WeatherCompletion = (_ weather: WeatherInfo, _ success: Bool) -> ()

class ApiClient {
    
    static func getWeather(forCity cityName: String) -> Observable<WeatherInfo> {
        return request(WeatherApiRouter.getCurrentWeather(cityName: cityName))
    }
    
    private static func request<T: Decodable> (_ urlConvertible: URLRequestConvertible) -> Observable<T> {
        return Observable<T>.create { observer in
            let request = AF.request(urlConvertible).responseDecodable { (response: DataResponse<T, AFError>) in
                switch response.result {
                case .success(let value):
                    observer.onNext(value)
                    observer.onCompleted()
                case .failure(let error):
                    switch response.response?.statusCode {
                    case 403:
                        observer.onError(Constants.ApiError.forbidden)
                    case 404:
                        observer.onError(Constants.ApiError.notFound)
                    case 409:
                        observer.onError(Constants.ApiError.conflict)
                    case 500:
                        observer.onError(Constants.ApiError.internalServerError)
                    default:
                        observer.onError(error)
                    }
                }
            }
            return Disposables.create {
                request.cancel()
            }
        }
    }
}
