//
//  FetchCurrentWeatherUseCase.swift
//  PuppyStep
//
//  Created by Sergey on 11/10/20.
//

import Foundation
import RxSwift

protocol FetchCurrentWeatherUseCase {
    associatedtype Result: Any
    associatedtype Params: RequestValues
    typealias Completion = WeatherCompletion
    
    func execute(_ requestValues: Params, completion: @escaping Completion)
}

class FetchCurrentWeatherUseCaseImpl: FetchCurrentWeatherUseCase {
    
    let disposeBag = DisposeBag()
    
    typealias Result = WeatherInfo
    typealias Params = CityRequestValue
    
    func execute(_ requestValues: CityRequestValue, completion: @escaping Completion) {
        ApiClient.getWeather(forCity: "Minsk")
            .subscribe(onNext: { weather in
                completion(weather, true)
            }, onError: { error in
                switch error {
                case Constants.ApiError.conflict:
                    print("Conflict error")
                case Constants.ApiError.forbidden:
                    print("Forbidden error")
                case Constants.ApiError.notFound:
                    print("Not found error")
                default:
                    print("Unknown error:", error)
                }
            })
            .disposed(by: disposeBag)
    }
}
