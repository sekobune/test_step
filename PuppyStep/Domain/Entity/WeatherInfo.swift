//
//  WeatherInfo.swift
//  PuppyStep
//
//  Created by Sergey on 11/6/20.
//

import Foundation

struct WeatherInfo: Decodable {
    
    // MARK: - Properties
    let temperature: Double
    let humidity: Int
    let weather: [Weather]
    let windSpeed: Int
    
    enum WeatherInfoCodingKeys: String, CodingKey {
        case weather = "weather"
        case mainInfo = "main"
        case wind = "wind"
    }
    
    enum MainCodingKeys: String, CodingKey {
        case temperature = "temp"
        case humidity = "humidity"
    }
    
    enum WindCodingKeys: String, CodingKey {
        case speed = "speed"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: WeatherInfoCodingKeys.self)
        weather = try container.decode([Weather].self, forKey: .weather)
        let mainInfo = try container.nestedContainer(keyedBy: MainCodingKeys.self, forKey: .mainInfo)
        temperature = try mainInfo.decode(Double.self, forKey: .temperature)
        humidity = try mainInfo.decode(Int.self, forKey: .humidity)
        let windInfo = try container.nestedContainer(keyedBy: WindCodingKeys.self, forKey: .wind)
        windSpeed = try windInfo.decode(Int.self, forKey: .speed)
    }
}

struct Weather: Decodable {
    let weatherTitle: String
    let weatherDescription: String
    let iconUrl: String
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: WeatherCodingKeys.self)
        weatherTitle = try container.decode(String.self, forKey: .weatherTitle)
        weatherDescription = try container.decode(String.self, forKey: .weatherDescription)
        let iconName = try container.decode(String.self, forKey: .iconUrl)
        iconUrl = "\(Constants.baseUrl.replacingOccurrences(of: "api.", with: ""))/img/wn/\(iconName)@2x.png"
    }
    
    enum WeatherCodingKeys: String, CodingKey {
        case weatherTitle = "main"
        case weatherDescription = "description"
        case iconUrl = "icon"
    }
}
